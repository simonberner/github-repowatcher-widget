//
//  CompactRepoWidget.swift
//  CompactRepoWidget
//
//  Created by Simon Berner on 27.11.22.
//

import WidgetKit
import SwiftUI
import Intents

struct CompactRepoProvider: IntentTimelineProvider {

    // placeholder for the Widget Search (static mock data)
    func placeholder(in context: Context) -> CompactRepoEntry {
        CompactRepoEntry(date: Date(), repo: MockData.repoOne, bottomRepo: MockData.repoTwo, configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (CompactRepoEntry) -> ()) {
        let entry = CompactRepoEntry(date: Date(), repo: MockData.repoOne, bottomRepo: MockData.repoTwo, configuration: configuration)
        completion(entry)
    }

    // get updated timeline entry after each interval
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            let nextUpdate = Date().addingTimeInterval(43200) // 12 hours in seconds

            do {
                // Get Top Repo
                var repo = try await NetworkManager.shared.getRepo(atUrl: RepoURL.githubRepoWatcher)
                let avatarImageData = await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
                repo.avatarData = avatarImageData ?? Data()

                // Get Bottom Repo if large Widget
                var buttomRepo: Repository?
                if context.family == .systemLarge {
                    buttomRepo = try await NetworkManager.shared.getRepo(atUrl: RepoURL.publish)
                    // force unwrap 'buttomRepo' because if the above call fails, the below steps won't be executed
                    let avatarImageData = await NetworkManager.shared.downloadImageData(from: buttomRepo!.owner.avatarUrl)
                    buttomRepo!.avatarData = avatarImageData ?? Data()
                }

                // Create Entry & Timeline
                let entry = CompactRepoEntry(date: .now, repo: repo, bottomRepo: buttomRepo, configuration: configuration)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            } catch {
                print("❌ Error = \(error.localizedDescription)")
            }
        }
    }
}

struct CompactRepoEntry: TimelineEntry {
    let date: Date
    let repo: Repository
    let bottomRepo: Repository? // second repo to show (optional because only needed for family .systemLarge)
    let configuration: ConfigurationIntent
}

struct CompactRepoEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: CompactRepoEntry

    var body: some View {
        switch family {
            case .systemMedium:
                RepoMediumView(repo: entry.repo)
            case .systemLarge:
                VStack(spacing: 36) {
                    RepoMediumView(repo: entry.repo)
                    if let bottomRepo = entry.bottomRepo { // only show repo when not nil
                        RepoMediumView(repo: bottomRepo)
                    }
                }
            case .systemSmall, .systemExtraLarge, .accessoryCircular, .accessoryRectangular, .accessoryInline:
                EmptyView()
            @unknown default:
                EmptyView()
        }
    }

}

struct CompactRepoWidget: Widget {
    let kind: String = "CompactRepoWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: CompactRepoProvider()) { entry in
            CompactRepoEntryView(entry: entry)
        }
        .configurationDisplayName("GitHub Repo Watcher")
        .description("Keep an eye on one or two GitHub Repositories")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

struct CompactRepoWidget_Previews: PreviewProvider {
    static var previews: some View {
        CompactRepoEntryView(entry: CompactRepoEntry(date: Date(),
                                                    repo: MockData.repoOne,
                                                    bottomRepo: MockData.repoTwo,
                                                    configuration: ConfigurationIntent()))
        .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
