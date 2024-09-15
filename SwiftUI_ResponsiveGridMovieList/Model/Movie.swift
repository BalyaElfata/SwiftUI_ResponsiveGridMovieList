import Foundation

struct Movie: Identifiable, Codable {
    var id = UUID().uuidString
    let originalTitle: String
    let releaseDate: String
    
    enum CodingKeys : String, CodingKey {
        case originalTitle = "original_title"
        case releaseDate = "release_date"
    }
}
