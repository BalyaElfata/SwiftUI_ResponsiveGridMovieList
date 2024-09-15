//
//  ContentViewModel.swift
//  SwiftUI_ResponsiveGridMovieList
//
//  Created by hendra on 15/09/24.
//

import Foundation

class ContentViewModel: ObservableObject {
    @Published var resultState: ResultState<[Movie]> = .initial
    @Published var movies: [Movie] = []
    
    private let apiService: ApiService
    
    init(apiService: ApiService = ApiService()) {
        self.apiService = apiService
    }
    
    func fetchMovies(page: String = "1") async {
        DispatchQueue.main.async {
            self.resultState = .loading
        }
        
        do {
            let movies = try await apiService.fetchMovies(page: page)

            DispatchQueue.main.async {
                self.movies.append(contentsOf: movies)
                self.resultState = .success(self.movies)
            }
        } catch {
            DispatchQueue.main.async {
                self.resultState = .error("Failed to load movies: \(error.localizedDescription)")
            }
        }
    }
}
