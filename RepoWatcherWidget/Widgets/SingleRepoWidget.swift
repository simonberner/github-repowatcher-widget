//
//  SingelRepoWidget.swift
//  RepoWatcherWidgetExtension
//
//  Created by Simon Berner on 04.12.22.
//

import SwiftUI
import WidgetKit

// update the widget's display
struct SingleRepoProvider: IntentTimelineProvider {
    // Provides a timeline entry representing a placeholder version of the widget for the search
    func placeholder(in context: Context) -> SingleRepoEntry {
        SingleRepoEntry(date: .now, repo: MockData.repoOne, configuration: ConfigurationIntent())
    }

    // Provides the timeline entry that represents the current time and state of a widget.
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SingleRepoEntry) -> Void) {
        let entry = SingleRepoEntry(date: .now, repo: MockData.repoOne, configuration: configuration)
        completion(entry)
    }

    // Provides an array of timeline entries for the current time and, optionally any future times to update a widget.
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SingleRepoEntry>) -> Void) {

        Task {
            // Set update to every 43200 seconds (12 hours)
            let nextUpdate = Date().addingTimeInterval(43200)

            do {
                // Get Repo and avatar
                let repoToShow = RepoURL.google
                var repo = try await NetworkManager.shared.getRepo(atUrl: repoToShow)
                let avatarImageData = await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
                repo.avatarData = avatarImageData ?? Data()

                // Only do the call when the widget family is large
                if context.family == .systemLarge {
                    // Get Contributors
                    let contributors = try await NetworkManager.shared.getContributors(atUrl: repoToShow + "/contributors")

                    // Filter out the top 4 (with the most contributions)
                    // prefix(4): this gives us the first 4 contributors
                    // (GitHub already gives us the JSON with the contributors
                    // in a descending order which have the most contributions)
                    var topFour = Array(contributors.prefix(4))

                    // Get avatar for each of the topFour and assign it to each of them
                    for i in topFour.indices {
                        let avatarData = await NetworkManager.shared.downloadImageData(from: topFour[i].avatarUrl)
                        topFour[i].avatarData = avatarData ?? Data()
                    }
                    repo.contributors = topFour
                }


                // Create entry in timeline
                let entry = SingleRepoEntry(date: .now, repo: repo, configuration: configuration)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            } catch {
                print("??? Error = \(error.localizedDescription)")
            }
        }

    }
}

struct SingleRepoEntry: TimelineEntry {
    var date: Date
    var repo: Repository
    let configuration: ConfigurationIntent
}

struct SingleRepoEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: SingleRepoEntry

    var body: some View {
        switch family {
            case .systemMedium:
                RepoMediumView(repo: entry.repo)
            case .systemLarge:
                VStack {
                    RepoMediumView(repo: entry.repo)
                    ContributorMediumView(repo: entry.repo)
                }
            case .systemSmall, .systemExtraLarge, .accessoryCircular, .accessoryRectangular, .accessoryInline:
                EmptyView()
            @unknown default:
                EmptyView()
        }

    }

}

struct SingleRepoWidget: Widget {
    let kind: String = "ContributorWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: SingleRepoProvider()) { entry in
            SingleRepoEntryView(entry: entry)
        }
        .configurationDisplayName("Single Repo")
        .description("Track a single repository")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

struct SingleRepoWidget_Previews: PreviewProvider {
    static var previews: some View {
        SingleRepoEntryView(entry: SingleRepoEntry(date: Date(),
                                                     repo: MockData.repoOne,
                                                     configuration: ConfigurationIntent()))
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
