import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    @State private var currentPage = 1
    @State private var isFetching = false
    @State private var lastMovieId: String? = nil // To track the last movie's ID

    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 1), count: 4)
    
    var body: some View {
        GeometryReader  { proxy in
            switch viewModel.resultState {
            case .initial:
                Text("Tes")
            case .loading:
                ProgressView("Loading...")
            case .success(let movies):
                let itemWidth = (proxy.size.width / 4) - 4
                let itemHeight = proxy.size.height / 3
                ScrollView {
                    LazyVGrid (columns: columns, spacing: 4) {
                        ForEach(movies, id: \.id) { movie in
                            ZStack {
                                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/original/\(movie.posterPath)")) { image in
                                    image.resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    Color.gray.overlay {
                                        ProgressView()
                                    }
                                }
                                .frame(width: itemWidth, height: itemHeight)
                                .clipped()
                                VStack(alignment: .leading) {
                                    Spacer()
                                    
                                    Text("\(movie.originalTitle)")
                                        .foregroundStyle(.white)
                                    Text("\(yearFromDate(movie.releaseDate))")
                                        .foregroundStyle(.white)
                                }
                                .frame(width: itemWidth, height: itemHeight, alignment: .leading)
                            }
                            .onAppear {
                                if let lastId = lastMovieId, lastId == movie.id {
                                    loadMoreMovies()
                                }
                            }
                        }
                    }
                }
                .onAppear {
                    lastMovieId = movies.last?.id
                }
            case .error(let string):
                ContentUnavailableView(
                    "We couldn't fetch the data",
                    systemImage: "icloud.and.arrow.down",
                    description: Text(string)
                )
            }
        }
        .task {
            await viewModel.fetchMovies(page: "\(currentPage)")
        }
    }
    
    private func yearFromDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: dateString) else {
            return "Unknown Year"
        }
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }
    
    private func loadMoreMovies() {
        guard !isFetching else { return }
        isFetching = true
        currentPage += 1
        Task {
            await viewModel.fetchMovies(page: "\(currentPage)")
            isFetching = false
        }
    }
}

#Preview {
    ContentView()
}
