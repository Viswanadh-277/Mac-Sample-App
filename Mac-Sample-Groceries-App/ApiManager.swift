//
//  ApiManager.swift
//  Mac-Sample-Groceries-App
//
//  Created by KSMACMINI-016 on 12/07/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case unknown
}

struct ApiManager {
    static let shared = ApiManager() // Singleton instance
    
    init() {}
    
    // MARK: - Generic Request Function
    
    private func request<T: Codable>(url: URL, method: String, body: Data? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if let requestBody = body {
            #if DEBUG
            print("\(url.lastPathComponent) input : ", responseBeforeDecode(data: requestBody)!)
            #endif
        } else {
            #if DEBUG
            print("\(url.lastPathComponent) input : Request body is nil")
            #endif
        }
        
        if let body = body {
            request.httpBody = body
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(.failure(NetworkError.unknown))
                return
            }
                        
            if let prettyData = responseBeforeDecode(data: data) {
                print("Response Before Decode : \(prettyData)")
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    func performRequest<T: Codable, U: Codable>(url: URL, method: String, body: U, completion: @escaping (Result<T, Error>) -> Void) {
        do {
            let jsonData = try JSONEncoder().encode(body)
            request(url: url, method: method, body: jsonData, completion: completion)
        } catch {
            print("Encoding error: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    // MARK: - GET Request
    
    func get<T: Codable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        request(url: url, method: "GET", completion: completion)
    }
    
    // MARK: - POST Request
    
    func post<T: Codable, U: Codable>(url: URL, body: U, completion: @escaping (Result<T, Error>) -> Void) {
        performRequest(url: url, method: "POST", body: body, completion: completion)
    }
    
    // MARK: - PATCH Request
    
    func patch<T: Codable, U: Codable>(url: URL, body: U, completion: @escaping (Result<T, Error>) -> Void) {
        performRequest(url: url, method: "PATCH", body: body, completion: completion)
    }
    
    // MARK: - DELETE Request
    
    func delete<T: Codable, U: Codable>(url: URL, body: U, completion: @escaping (Result<T, Error>) -> Void) {
        performRequest(url: url, method: "DELETE", body: body, completion: completion)
    }
    
    //MARK: - Pretty Printed Data
    func responseBeforeDecode(data:Data)->String?{
        if let prettyPrintedString = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed),
           let prettyPrintedData = try? JSONSerialization.data(withJSONObject: prettyPrintedString, options: .prettyPrinted),
           let prettyPrintedStringResult = String(data: prettyPrintedData, encoding: .utf8) {
            return prettyPrintedStringResult
        } else {
            return nil
        }
        
    }
}

