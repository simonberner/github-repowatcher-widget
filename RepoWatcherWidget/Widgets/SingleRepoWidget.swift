//
//  SingelRepoWidget.swift
//  RepoWatcherWidgetExtension
//
//  Created by Simon Berner on 04.12.22.
//

import SwiftUI
import WidgetKit

// update the widget's display
struct SingleRepoProvider: AppIntentTimelineProvider {
    
    // Provides a timeline entry representing a placeholder version of the widget for the search
    func placeholder(in context: Context) -> SingleRepoEntry {
        SingleRepoEntry(date: .now, repo: MockData.repoOne)
    }
    
    // Provides the timeline entry that represents the current time and state of a widget.
    func snapshot(for configuration: SelectSingleRepo, in context: Context) async -> SingleRepoEntry {
        SingleRepoEntry(date: .now, repo: MockData.repoOne)
    }
    
    // Provides an array of timeline entries for the current time and, optionally any future times to update a widget.
    func timeline(for configuration: SelectSingleRepo, in context: Context) async -> Timeline<SingleRepoEntry> {
        // Set update to every 43200 seconds (12 hours)
        let nextUpdate = Date().addingTimeInterval(43200)
        
        do {
            // Get Repo and avatar
            let repoToShow = RepoURL.prefix + configuration.repo!
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
            let entry = SingleRepoEntry(date: .now, repo: repo)
            return Timeline(entries: [entry], policy: .after(nextUpdate))
        } catch {
            return Timeline(entries: [], policy: .after(nextUpdate))
        }
    }
}

struct SingleRepoEntry: TimelineEntry {
    var date: Date
    var repo: Repository
}

struct SingleRepoEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: SingleRepoEntry
    
    var body: some View {
        switch family {
        case .systemMedium:
            // adopt for container background
            RepoMediumView(repo: entry.repo)
                .containerBackground(for: .widget) { }
        case .systemLarge:
            VStack(spacing: 50) {
                RepoMediumView(repo: entry.repo)
                ContributorMediumView(repo: entry.repo)
            }
            .containerBackground(for: .widget) { }
            // Lock Screen Widget Families
        case .accessoryInline:
            Text("\(entry.repo.name) - \(entry.repo.daysSinceLastActivity)")
                .containerBackground(for: .widget) { }
        case .accessoryRectangular:
            VStack(alignment: .leading) {
                Text(entry.repo.name)
                    .font(.headline)
                Text("\(entry.repo.daysSinceLastActivity) days")
                HStack {
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width: 12, height: 12)
                        .aspectRatio(contentMode: .fit)
                    
                    Text("\(entry.repo.watchers)")
                    
                    Image(systemName: "tuningfork")
                        .resizable()
                        .frame(width: 12, height: 12)
                        .aspectRatio(contentMode: .fit)
                    
                    Text("\(entry.repo.forks)")
                    
                    if entry.repo.hasIssues {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .frame(width: 12, height: 12)
                            .aspectRatio(contentMode: .fit)
                        
                        Text("\(entry.repo.openIssues)")
                    }
                    
                }
                .font(.caption)
            }
            .containerBackground(for: .widget) { }
        case .accessoryCircular:
            ZStack {
                AccessoryWidgetBackground()
                VStack {
                    Text("\(entry.repo.daysSinceLastActivity)")
                        .font(.headline)
                    Text("days")
                        .font(.caption)
                }
            }
            .containerBackground(for: .widget) {}
        case .systemSmall, .systemExtraLarge:
            EmptyView()
        @unknown default:
            EmptyView()
        }
        
    }
    
}

@main
struct SingleRepoWidget: Widget {
    let kind: String = "ContributorWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: SelectSingleRepo.self, provider: SingleRepoProvider()) { entry in
            if #available(iOS 17, *) {
                SingleRepoEntryView(entry: entry)
                    .containerBackground(for: .widget) { }
            } else {
                SingleRepoEntryView(entry: entry)
            }
        }
        .configurationDisplayName("Single Repo")
        .description("Track a single repository")
        .supportedFamilies([.systemMedium,
                            .systemLarge,
                            .accessoryInline,
                            .accessoryCircular,
                            .accessoryRectangular])
    }
}

#Preview(as: .systemLarge) {
    SingleRepoWidget()
} timeline: {
    SingleRepoEntry(date: .now, repo: MockData.repoOne)
    SingleRepoEntry(date: .now, repo: MockData.repoOneV2)
}
