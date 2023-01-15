//
//  IntentHandler.swift
//  RepoWatcherIntents
//
//  Created by Simon Berner on 15.01.23.
//

import Intents

/// Communication layer between what the user picks and the system
class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
}

extension IntentHandler: SelectSingleRepoIntentHandling {

    // Get list of repos from UserDefaults database
    func provideRepoOptionsCollection(for intent: SelectSingleRepoIntent) async throws -> INObjectCollection<NSString> {
        guard let repos = UserDefaults.shared.value(forKey: UserDefaults.repoKey) as? [String] else {
            throw UserDefaultsError.retreival
        }

        // Return the list of repos
        return INObjectCollection(items: repos as [NSString])
    }

    // Is called when a user adds the widget for the very first time onto the screen
    func defaultRepo(for intent: SelectSingleRepoIntent) -> String? {
        return "simonberner/github-repowatcher-widget"
    }
}
