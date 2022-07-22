//
//  APICaller.swift
//  NewsApp
//
//  Created by Nikolai Maksimov on 22.07.2022.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    struct Contacts {
        static let topHeadLineURL = URL(string: "https://newsapi.org/v2/top-headlines?country=US&apiKey=eda6154a62744b7bbad849130a7f7b6f")
    }
    
    private init() {}
    
    func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = Contacts.topHeadLineURL else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}


struct APIResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable {
    let name: String
}
