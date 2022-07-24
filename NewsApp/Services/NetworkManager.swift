//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Nikolai Maksimov on 22.07.2022.
//

import Foundation

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
   private let url = "https://newsapi.org/v2/top-headlines?country=US&apiKey=eda6154a62744b7bbad849130a7f7b6f"
    private let searchUrlString = "https://newsapi.org/v2/everything?sortedBy=popularity&apiKey=eda6154a62744b7bbad849130a7f7b6f&q="
    
    func fetchData(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = URL(string: url) else { return }
        
        let _ = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func search(with query: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let urlString = searchUrlString + query
        guard let url = URL(string: urlString) else { return }
        
        let _ = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
