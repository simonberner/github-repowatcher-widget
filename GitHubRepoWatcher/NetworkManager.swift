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

    /// Get a GitHub repository object
    /// - Parameter urlString: The url of the GitHub repository
    /// - Returns: The repository object
    func getRepo(atUrl urlString: String) async throws -> Repository {
        // check we have a valid url
        guard let url = URL(string: urlString) else { throw NetworkError.invalidURL }
        // make the async/await network call to the github api
        let (data, response) = try await URLSession.shared.data(from: url)
        // check if we have a valid response code 200
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw NetworkError.invalidServerResponse }

        do {
            // try to decode the json data we got back from the api
            let codingData =  try decoder.decode(Repository.CodingData.self, from: data)
            return codingData.repo
        } catch {
            throw NetworkError.invalidRepoData
        }
    }

    /// Get an array of contributors of a repository
    /// - Parameter urlString: The contributors url of the GitHub repository
    /// - Returns: An array of contributors
    func getContributors(atUrl urlString: String) async throws -> [Contributor] {
        // check valid url
        guard let url = URL(string: urlString) else { throw NetworkError.invalidURL }
        // make the async/await network call to the github api
        let (data, response) = try await URLSession.shared.data(from: url)
        // check if we have a valid response code 200
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw NetworkError.invalidServerResponse }

        do {
            // try to decode the json data we got back from the api
            let codingData =  try decoder.decode([Contributor.CodingData].self, from: data)
            return codingData.map { $0.contributor } // map returns an array with contributors of each codingData
        } catch {
            throw NetworkError.invalidRepoData
        }
    }

    /// Download user avatar image data
    ///
    /// This call is a successor of the getRepo call. If the URL is not valid or the network calls fails,
    /// the placeholder avatar will be used.
    ///
    /// - Parameter urlString: The url of the user avatar image
    /// - Returns: The image data or nil in case of an error
    func downloadImageData(from urlString: String) async -> Data? {
        guard let url = URL(string: urlString) else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            return nil
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
    static let prefix = "https://api.github.com/repos/"
    static let githubRepoWatcher = "https://api.github.com/repos/simonberner/github-repowatcher-widget"
    static let publish = "https://api.github.com/repos/johnsundell/publish"
    static let google = "https://api.github.com/repos/google/GoogleSignIn-iOS"
}
