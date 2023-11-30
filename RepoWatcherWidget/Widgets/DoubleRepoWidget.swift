//
//  DoubleRepoWidget.swift
//  DoubleRepoWidget
//
//  Created by Simon Berner on 27.11.22.
//

import WidgetKit
import SwiftUI
import Intents

struct DoubleRepoProvider: IntentTimelineProvider {

    // placeholder for the Widget Search (static mock data)
    func placeholder(in context: Context) -> DoubleRepoEntry {
        DoubleRepoEntry(date: Date(), topRepo: MockData.repoOne, bottomRepo: MockData.repoTwo)
    }

    func getSnapshot(for configuration: SelectTwoReposIntent, in context: Context, completion: @escaping (DoubleRepoEntry) -> ()) {
        let entry = DoubleRepoEntry(date: Date(), topRepo: MockData.repoOne, bottomRepo: MockData.repoTwo)
        completion(entry)
    }

    // get updated timeline entry after each interval
    func getTimeline(for configuration: SelectTwoReposIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            let nextUpdate = Date().addingTimeInterval(43200) // 12 hours in seconds

            do {
                // Get top Repo
                var topRepo = try await NetworkManager.shared.getRepo(atUrl: RepoURL.prefix + configuration.topRepo!)
                let topAvatarImageData = await NetworkManager.shared.downloadImageData(from: topRepo.owner.avatarUrl)
                topRepo.avatarData = topAvatarImageData ?? Data()

                // Get bottom Repo
                var bottomRepo = try await NetworkManager.shared.getRepo(atUrl: RepoURL.prefix + configuration.bottomRepo!)
                // force unwrap 'buttomRepo' because if the above call fails, the below steps won't be executed
                let bottomAvatarImageData = await NetworkManager.shared.downloadImageData(from: bottomRepo.owner.avatarUrl)
                bottomRepo.avatarData = bottomAvatarImageData ?? Data()

                // Create Entry & Timeline
                let entry = DoubleRepoEntry(date: .now, topRepo: topRepo, bottomRepo: bottomRepo)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            } catch {
                print("❌ Error = \(error.localizedDescription)")
            }
        }
    }
}

struct DoubleRepoEntry: TimelineEntry {
    let date: Date
    let topRepo: Repository
    let bottomRepo: Repository?
}

struct DoubleRepoEntryView : View {
    var entry: DoubleRepoEntry

    var body: some View {
        VStack(spacing: 36) {
            RepoMediumView(repo: entry.topRepo)
            if let bottomRepo = entry.bottomRepo { // only show repo when not nil
                RepoMediumView(repo: bottomRepo)
            }
        }
    }

}

struct DoubleRepoWidget: Widget {
    let kind: String = "DoubleRepoWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: SelectTwoReposIntent.self, provider: DoubleRepoProvider()) { entry in
            DoubleRepoEntryView(entry: entry)
        }
        .configurationDisplayName("GitHub Repo Watcher")
        .description("Keep an eye on two GitHub Repositories")
        .supportedFamilies([.systemLarge])
    }
}

struct DoubleRepoWidget_Previews: PreviewProvider {
    static var previews: some View {
        DoubleRepoEntryView(entry: DoubleRepoEntry(date: Date(),
                                                   topRepo: MockData.repoOne,
                                                   bottomRepo: MockData.repoTwo))
        .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
