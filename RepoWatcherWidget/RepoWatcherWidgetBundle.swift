//
//  RepoWatcherWidgetBundle.swift
//  RepoWatcherWidget
//
//  Created by Simon Berner on 27.11.22.
//

import WidgetKit
import SwiftUI

@main
struct RepoWatcherWidgetBundle: WidgetBundle {
    var body: some Widget {
        CompactRepoWidget()
        SingleRepoWidget()
        RepoWatcherWidgetLiveActivity()
    }
}
