//
//  ResultState.swift
//  SwiftUI_ResponsiveGridMovieList
//
//  Created by hendra on 15/09/24.
//

import Foundation

enum ResultState<T> {
    case initial
    case loading
    case success(T)
    case error(String)
}
