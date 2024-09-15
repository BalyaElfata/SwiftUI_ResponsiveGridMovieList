import SwiftUI

struct ContentView: View {
    let data = Array(1...50)
    
    var columns = Array(repeating: GridItem(.flexible(), spacing: 1), count: 4)
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                let itemWidth = proxy.size.width / 4 - 4
                let itemHeight = proxy.size.height / 6
                LazyVGrid(columns: self.columns, spacing: 4) {
                    ForEach(data, id: \.self) { number in
                        Color.blue
                            .frame(width: itemWidth, height: itemHeight)
                    }
                }
            }
        }
        .padding()
    }
}
#Preview {
    ContentView()
}
