//
//  Movies.swift
//  SwiftUI_ResponsiveGridMovieList
//
//  Created by hendra on 15/09/24.
//

import Foundation

struct Movie: Identifiable, Codable {
    var id = UUID().uuidString
    let originalTitle: String
    let releaseDate: String
    let posterPath: String
    
    enum CodingKeys: String, CodingKey
    {
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case posterPath = "poster_path"
    }
}
