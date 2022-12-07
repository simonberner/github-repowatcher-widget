//
//  ContributorWidget.swift
//  RepoWatcherWidgetExtension
//
//  Created by Simon Berner on 04.12.22.
//

import SwiftUI
import WidgetKit

// update the widget's display
struct ContributorProvider: IntentTimelineProvider {
    // Provides a timeline entry representing a placeholder version of the widget for the search
    func placeholder(in context: Context) -> ContributorEntry {
        ContributorEntry(date: .now, repo: MockData.repoOne, configuration: ConfigurationIntent())
    }

    // Provides the timeline entry that represents the current time and state of a widget.
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (ContributorEntry) -> Void) {
        let entry = ContributorEntry(date: .now, repo: MockData.repoOne, configuration: configuration)
        completion(entry)
    }

    // Provides an array of timeline entries for the current time and, optionally any future times to update a widget.
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<ContributorEntry>) -> Void) {

        Task {
            // Set update to every 43200 seconds (12 hours)
            let nextUpdate = Date().addingTimeInterval(43200)

            do {
                // Get Repo and avatar
                let repoToShow = RepoURL.google
                var repo = try await NetworkManager.shared.getRepo(atUrl: repoToShow)
                let avatarImageData = await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
                repo.avatarData = avatarImageData ?? Data()

                // Get Contributors
                let contributors = try await NetworkManager.shared.getContributors(atUrl: repoToShow + "/contributors")

                // Filter out the top 4 (with the most contributions)
                // prefix(4): this gives us the first 4 contributors
                // (GitHub already gives us the a JSON with the contributors in a descending order which have
                // the most contributions)
                var topFour = Array(contributors.prefix(4))

                // Get avatar for each of the topFour and assign it to each of them
                for i in topFour.indices {
                    let avatarData = await NetworkManager.shared.downloadImageData(from: topFour[i].avatarUrl)
                    topFour[i].avatarData = avatarData ?? Data()
                }

                repo.contributors = topFour

                // Create entry in timeline
                let entry = ContributorEntry(date: .now, repo: repo, configuration: configuration)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            } catch {
                print("❌ Error = \(error.localizedDescription)")
            }
        }

    }
}

struct ContributorEntry: TimelineEntry {
    var date: Date
    var repo: Repository
    let configuration: ConfigurationIntent
}

struct ContributorEntryView : View {
    var entry: ContributorEntry

    var body: some View {
        VStack {
            RepoMediumView(repo: entry.repo)
            ContributorMediumView(repo: entry.repo)
        }
    }

}

struct ContributorWidget: Widget {
    let kind: String = "ContributorWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: ContributorProvider()) { entry in
            ContributorEntryView(entry: entry)
        }
        .configurationDisplayName("Contributors")
        .description("Keep track of a repository's top contributors")
        .supportedFamilies([.systemLarge])
    }
}

struct ContributorWidget_Previews: PreviewProvider {
    static var previews: some View {
        ContributorEntryView(entry: ContributorEntry(date: Date(),
                                                     repo: MockData.repoOne,
                                                     configuration: ConfigurationIntent()))
        .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
