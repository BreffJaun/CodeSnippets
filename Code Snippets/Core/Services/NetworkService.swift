//
//  NetworkService.swift
//  Quotely
//
//  Created by Jeff Braun on 29.08.25.
//

import Foundation

struct NetworkService {

    /// Generic sendData for any HTTP method (POST, PUT, PATCH, DELETE, GET with body)
    static func sendData<T: Decodable, U: Encodable>(
        to urlString: String,
        method: String = "GET",
        body: U? = nil,
        responseType: T.Type
    ) async throws -> T {
        
        guard let url = URL(string: urlString) else {
            throw HTTPError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        // Only use body if provided -> POST, PUT, PATCH, DELETE
        if let body = body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse,
           !(200...299).contains(httpResponse.statusCode) {
            throw HTTPError.requestFailed(statusCode: httpResponse.statusCode)
        }
        
        guard !data.isEmpty else {
            throw HTTPError.noData
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw HTTPError.decodingError
        }
    }
    
    /// Overload for GET requests without body
    static func sendData<T: Decodable>(
        to urlString: String,
        responseType: T.Type
    ) async throws -> T {
        return try await sendData(to: urlString, method: "GET", body: Optional<EmptyBody>.none, responseType: T.self)
    }
}

struct EmptyBody: Encodable {}

