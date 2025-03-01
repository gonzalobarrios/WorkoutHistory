//
//  NetworkManager.swift
//  WorkoutHistory
//
//  Created by Gonzalo on 2/26/25.
//

import Foundation

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE, PATCH
}

protocol NetworkManagerProtocol {
    func performRequest<T: Codable>(url: URL, method: HTTPMethod, body: Data?, headers: [String: String]?) async throws -> T
    func uploadRequest<T: Codable>(url: URL, method: HTTPMethod, parameters: [String: String], imageData: Data?, imageName: String, headers: [String: String]?) async throws -> T
}

class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager(session: .shared)
    private let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func performRequest<T: Codable>(url: URL, method: HTTPMethod, body: Data? = nil, headers: [String: String]? = nil) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body

        headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

        if body != nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse(statusCode: -1)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse(statusCode: httpResponse.statusCode)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }

    func uploadRequest<T: Codable>(
        url: URL,
        method: HTTPMethod,
        parameters: [String: String],
        imageData: Data?,
        imageName: String,
        headers: [String: String]?
    ) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        let boundary = UUID().uuidString
        var body = Data()
        let lineBreak = "\r\n".data(using: .utf8)!

        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }

        if let imageData = imageData {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"image\"; filename=\"\(imageName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append(lineBreak)
        } else {
            print("No Image Data Found")
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

        print("Upload Request Headers:", request.allHTTPHeaderFields ?? [:])

        do {
            let (data, response) = try await session.upload(for: request, from: body)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse(statusCode: -1)
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse(statusCode: httpResponse.statusCode)
            }

            print("Upload Success: HTTP \(httpResponse.statusCode)")
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Upload Failed: \(error.localizedDescription)")
            throw error
        }
    }
}
