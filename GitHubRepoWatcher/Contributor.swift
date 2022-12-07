//
//  Contributor.swift
//  GitHubRepoWatcher
//
//  Created by Simon Berner on 05.12.22.
//

import Foundation

struct Contributor: Identifiable {
    let id = UUID()
    let login: String
    let avatarUrl: String
    let contributions: Int
    var avatarData: Data // additional, not part of the JSON
}

extension Contributor {
    // Conforms to the JSON structure and used to decode the JSON into an object
    // This is the JSON prison ;)
    struct CodingData: Decodable {
        let login: String
        let avatarUrl: String
        let contributions: Int
        // a computed property which consist of a decoded repository data object
        // and the additional Contributor avatarData
        var contributor :Contributor {
            Contributor(login: login,
                        avatarUrl: avatarUrl,
                        contributions:contributions,
                        avatarData: Data())
        }
    }
}
