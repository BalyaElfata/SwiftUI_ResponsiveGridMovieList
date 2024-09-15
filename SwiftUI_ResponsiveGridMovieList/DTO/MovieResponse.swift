//
//  MovieResponse.swift
//  SwiftUI_ResponsiveGridMovieList
//
//  Created by hendra on 15/09/24.
//

import Foundation

struct MovieResponse: Codable {
    let dates: Dates
    let page: Int
    let results: [Movie]
}
