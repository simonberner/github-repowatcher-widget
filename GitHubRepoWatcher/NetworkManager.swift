//
//  NetworkManager.swift
//  GitHubRepoWatcher
//
//  Created by Simon Berner on 28.11.22.
//

import Foundation

// singleton
class NetworkManager {
    static let shared = NetworkManager()
    let decoder = JSONDecoder()

    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase // convert from JSON snake_case to Swift's camelCase
        decoder.dateDecodingStrategy = .iso8601
    }

    // Swift 5.5 async/await call
    func getRepo(atUrl urlString: String) async throws -> Repository {
        // check we have a valid url
        guard let url = URL(string: urlString) else { throw NetworkError.invalidURL }
        // make the async/await network call to the github api
        let (data, response) = try await URLSession.shared.data(from: url)
        // check if we have a valid response code 200
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw NetworkError.invalidServerResponse }

        do {
            // try to decode the json data we got back from the api
            return try decoder.decode(Repository.self, from: data)
        } catch {
            throw NetworkError.invalidRepoData
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidServerResponse
    case invalidRepoData
}

// some mock urls
enum RepoURL {
    static let githubRepoWatcher = "https://api.github.com/repos/simonberner/github-repowatcher-widget"
    static let publish = "https://api.github.com/repos/johnsundell/publish"
    static let google = "https://api.github.com/repos/google/GoogleSignIn-iOS"
}
