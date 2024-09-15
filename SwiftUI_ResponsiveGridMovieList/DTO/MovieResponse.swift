import Foundation

struct MovieResponse: Codable {
    let dates: Dates
    let page: Int
    let results: [Movie]
}
