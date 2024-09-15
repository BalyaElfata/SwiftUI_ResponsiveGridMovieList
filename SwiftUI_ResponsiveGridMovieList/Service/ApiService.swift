//
//  ApiService.swift
//  SwiftUI_ResponsiveGridMovieList
//
//  Created by hendra on 15/09/24.
//

import Foundation

class ApiService: APIServiceProtocol {
    func fetchMovies(page: String = "1") async throws -> [Movie] {
        try await URLSession.shared.fetchMovies(page: page)
    }
}

extension URLSession {
    func fetchMovies(page: String = "1") async throws -> [Movie] {
        let endpoint = Endpoint.movies(page: page)
        let (data, response) = try await URLSession.shared.makeRequest(to: endpoint.url, with: endpoint.headers)
        try handleResponse(data: data, response: response)
        
        let decoder = JSONDecoder()

        do {
            let response = try decoder.decode(MovieResponse.self, from: data)
            return response.results
        } catch {
            throw APIError.decodingError(error)
        }
    }
    
    private func handleResponse(data: Data, response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        let statusCode = HTTPStatusCode(rawValue: httpResponse.statusCode) ?? .unknown
        
        switch statusCode {
        case .ok:
            return
        default:
            throw APIError.httpError(statusCode)
        }
    }
}
