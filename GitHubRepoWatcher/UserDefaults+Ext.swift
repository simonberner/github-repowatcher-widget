//
//  UserDefaults+Ext.swift
//  GitHubRepoWatcher
//
//  Created by Simon Berner on 08.01.23.
//

import Foundation

extension UserDefaults {

    /// Shared UserDefaults database with the AppGroup name
    static var shared: UserDefaults {
        UserDefaults(suiteName: "group.dev.simonberner.RepoWatcher")!
    }
}
