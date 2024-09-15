//
//  Protocol.swift
//  SwiftUI_ResponsiveGridMovieList
//
//  Created by Balya Elfata on 15/09/24.
//

import Foundation

// MARK: - API Service Protocol
protocol APIServiceProtocol {
    func fetchMovies() async throws -> [Movie]
}

// **MARK: - Request Protocol**
protocol RequestProtocol {
    func makeRequest(to url: URL, with headers: [String: String]) async throws -> (Data, URLResponse)
}

extension URLSession: RequestProtocol {
    func makeRequest(to url: URL, with headers: [String: String]) async throws -> (Data, URLResponse) {
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        return try await data(for: request)
    }
}

// MARK: - Endpoint
enum Endpoint {
    case movies/*(page: String)*/
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = "/3/movie/now_playing"
        
        switch self {
        case .movies/*(let page)*/:
            components.queryItems = [
                URLQueryItem(name: "language", value: "en-US"),
//                URLQueryItem(name: "page", value: page)
            ]
            
            guard let url = components.url else {
                preconditionFailure("Invalid URL components: \(components)")
            }
            
            return url
        }
    }
    
    var headers: [String: String] {
        return [
            "apikey": "\(ProcessInfo.processInfo.environment["MOVIE_API_READ_ACCESS_TOKEN"] ?? "")",
            "Authorization": "Bearer \(ProcessInfo.processInfo.environment["MOVIE_API_READ_ACCESS_TOKEN"] ?? "")"
        ]
    }
}

// MARK: - API Error
enum APIError: Error {
    case invalidResponse
    case httpError(HTTPStatusCode)
    case decodingError(Error)
}

enum HTTPStatusCode: Int {
    case ok = 200
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case internalServerError = 500
    case unknown
}
