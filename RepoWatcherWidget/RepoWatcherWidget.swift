//
//  RepoWatcherWidget.swift
//  RepoWatcherWidget
//
//  Created by Simon Berner on 27.11.22.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {

    // placeholder for the Widget Search (static mock data)
    func placeholder(in context: Context) -> RepoEntry {
        RepoEntry(date: Date(), repo: .placeholder, avatarImageData: Data(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (RepoEntry) -> ()) {
        let entry = RepoEntry(date: Date(), repo: .placeholder, avatarImageData: Data(), configuration: configuration)
        completion(entry)
    }

    // get updated timeline entry after each interval
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            let nextUpdate = Date().addingTimeInterval(43200) // 12 hours in seconds

            do {
                let repo = try await NetworkManager.shared.getRepo(atUrl: RepoURL.google)
                let avatarImageData = await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
                let entry = RepoEntry(date: .now, repo: repo, avatarImageData: avatarImageData ?? Data(), configuration: configuration)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            } catch {
                print("❌ Error = \(error.localizedDescription)")
            }
        }
    }
}

struct RepoEntry: TimelineEntry {
    let date: Date
    let repo: Repository
    let avatarImageData: Data
    let configuration: ConfigurationIntent
}

struct RepoWatcherWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: RepoEntry

    var body: some View {
        switch family {
            case .systemMedium:
                RepoMediumView(repo: entry.repo)
            case .systemLarge:
                VStack(spacing: 36) {
                    RepoMediumView(repo: entry.repo)
                    RepoMediumView(repo: entry.repo)
                }
                RepoMediumView(repo: entry.repo)
            case .systemSmall, .systemExtraLarge, .accessoryCircular, .accessoryRectangular, .accessoryInline:
                EmptyView()
            @unknown default:
                EmptyView()
        }
        RepoMediumView(repo: entry.repo)
    }

}

struct RepoWatcherWidget: Widget {
    let kind: String = "RepoWatcherWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            RepoWatcherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("GitHub Repo Watcher")
        .description("Keep an eye on one or two GitHub Repositories")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

struct RepoWatcherWidget_Previews: PreviewProvider {
    static var previews: some View {
        RepoWatcherWidgetEntryView(entry: RepoEntry(date: Date(),
                                                    repo: .placeholder,
                                                    avatarImageData: Data(),
                                                    configuration: ConfigurationIntent()))
        .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
