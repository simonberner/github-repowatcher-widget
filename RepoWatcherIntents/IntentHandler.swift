//
//  IntentHandler.swift
//  RepoWatcherIntents
//
//  Created by Simon Berner on 11.01.23.
//

import Intents

/// Communication layer between when the user configures the widget and the system
class IntentHandler: INExtension {

    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}

extension IntentHandler: SelectSingleRepoIntentHandling {

    // Get the list of repos
    func provideRepoOptionsCollection(for intent: SelectSingleRepoIntent) async throws -> INObjectCollection<NSString> {
        guard let repos = UserDefaults.shared.value(forKey: UserDefaults.repoKey) as? [String] else {
            throw UserDefaultsError.retrieval
        }

        return INObjectCollection(items: repos as [NSString])
    }

    // Default value will show up when the user puts up the Widget for the very first time
    func defaultRepo(for intent: SelectSingleRepoIntent) -> String? {
        return "simonberner/github-repo-watcher"
    }
}