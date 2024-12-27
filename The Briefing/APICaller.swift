//
//  ApiCaller.swift
//  The Briefing
//
//  Created by Pranav Sharma on 2024-12-24.
//

import Foundation

final class APICaller {
    static let shared = APICaller()

    struct Constants {
        static let topHeadlinesURL = URL(
            string:
                "https://newsapi.org/v2/top-headlines?country=us&apiKey=c90dbadd2b144b9d93119c77ef544fde"
        )
        static let searchUrlString =
            "https://newsapi.org/v2/everything?sortBy=popularity&apiKey=c90dbadd2b144b9d93119c77ef544fde&q="
    }

    public init() {}

    func getTopStories(
        completion: @escaping (Result<[Article], Error>) -> Void
    ) {
        guard let url = Constants.topHeadlinesURL else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(
                        APIResponse.self, from: data)

                    print("Article = \(result.articles.count)")
                    completion(.success(result.articles))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }

    func search(
        with query: String,
        completion: @escaping (Result<[Article], Error>) -> Void
    ) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        let urlString = Constants.searchUrlString + query
        guard let url = URL(string: urlString) else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(
                        APIResponse.self, from: data)

                    print("Article = \(result.articles.count)")
                    completion(.success(result.articles))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
