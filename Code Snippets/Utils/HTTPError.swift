//
//  HTTPError.swift
//  03_W06_Notes
//
//  Created by Jeff Braun on 26.08.25.
//

import Foundation

enum HTTPError: LocalizedError {
    case invalidURL
    case requestFailed(statusCode: Int)
    case noData
    case decodingError
    case transportError(URLError) 
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .requestFailed(let statusCode):
            return "The request failed with status code \(statusCode)."
        case .noData:
            return "No data received from the server."
        case .decodingError:
            return "Failed to decode the response."
        case .transportError(let urlError):
            return "A transport error occurred: \(urlError.localizedDescription)"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}
