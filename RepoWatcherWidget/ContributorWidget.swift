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
        ContributorEntry(date: .now, configuration: ConfigurationIntent())
    }

    // Provides the timeline entry that represents the current time and state of a widget.
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (ContributorEntry) -> Void) {
        let entry = ContributorEntry(date: .now, configuration: configuration)
        completion(entry)
    }

    // Provides an array of timeline entries for the current time and, optionally any future times to update a widget.
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<ContributorEntry>) -> Void) {
        let nextUpdate = Date().addingTimeInterval(43200) // next update in the future (12 hours in seconds)
        let entry = ContributorEntry(date: .now, configuration: configuration)
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

struct ContributorEntry: TimelineEntry {
    var date: Date
    let configuration: ConfigurationIntent
}

struct ContributorEntryView : View {
    var entry: ContributorEntry

    var body: some View {
        Text(entry.date.formatted())

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
                                                    configuration: ConfigurationIntent()))
        .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
