//
//  ApiService.swift
//  SwiftUI_ResponsiveGridMovieList
//
//  Created by Balya Elfata on 15/09/24.
//

import Foundation

class ApiService {
    private let movieApiReadAccessToken: String = ProcessInfo.processInfo.environment["MOVIE_API_READ_ACCESS_TOKEN"] ?? ""
}

// MARK: - URLSession Extension
extension URLSession {
    
    func fetchMovies() async throws -> [Movie] {
        let endpoint = Endpoint.movies
        let (data, response) = try await URLSession.shared.makeRequest(to: endpoint.url, with: endpoint.headers)
        try handleResponse(data: data, response: response)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        do {
            let quests = try decoder.decode([Movie].self, from: data)
            return quests
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
