//
//  SelectSingleRepo.swift
//  GitHubRepoWatcher
//
//  Created by Simon Berner on 24.12.2023.
//

import Foundation
import AppIntents

@available(iOS 17.0, macOS 14.0, watchOS 10.0, *)
struct SelectSingleRepo: AppIntent, WidgetConfigurationIntent, CustomIntentMigratedAppIntent {
    static let intentClassName = "SelectSingleRepoIntent"

    static var title: LocalizedStringResource = "Select Single Repo"
    static var description = IntentDescription("Choose a repository to watch")

    @Parameter(title: "Repo", optionsProvider: RepoOptionsProvider())
    var repo: String?

    struct RepoOptionsProvider: DynamicOptionsProvider {
        func results() async throws -> [String] {
            guard let repos = UserDefaults.shared.value(forKey: UserDefaults.repoKey) as? [String] else { throw UserDefaultsError.retreival }
            return repos
        }
        
        func defaultResult() async -> String? { "simonberner/github-repowatcher-widget" }
    }
}
