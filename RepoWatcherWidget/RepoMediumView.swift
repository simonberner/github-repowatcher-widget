//
//  RepoMediumView.swift
//  RepoWatcherWidgetExtension
//
//  Created by Simon Berner on 30.11.22.
//

import SwiftUI
import WidgetKit

struct RepoMediumView: View {
    let repo: Repository

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Image(uiImage: UIImage(data: repo.avatarData) ?? UIImage(named: "avatar")!)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    Text(repo.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                }
                .padding(.bottom, 6)

                HStack {
                    StatLabel(value: repo.watchers, systemImageName: "star.fill")
                    StatLabel(value: repo.forks, systemImageName: "tuningfork")
                    if repo.hasIssues {
                        StatLabel(value: repo.openIssues, systemImageName: "exclamationmark.triangle.fill")
                    }
                }
            }

            Spacer()

            VStack {
                Text("\(repo.daysSinceLastActivity)")
                    .bold()
                    .font(.system(size: 70))
                    .frame(width: 90, height: 80)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .foregroundColor(repo.daysSinceLastActivity < 50 ? .green : .red)
                    .contentTransition(.numericText())

                Text("days ago")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .containerBackground(for: .widget) { }
    }
}

#Preview(as: .systemMedium) {
    DoubleRepoWidget()
} timeline: {
    DoubleRepoEntry(date: .now, topRepo: MockData.repoOne, bottomRepo: nil)
    DoubleRepoEntry(date: .now, topRepo: MockData.repoOneV2, bottomRepo: nil)
}

// fileprivate: only accessible inside this file
fileprivate struct StatLabel: View {
    let value: Int
    let systemImageName: String

    var body: some View {
        Label {
            Text("\(value)")
                .font(.footnote)
                .contentTransition(.numericText())
        } icon: {
            Image(systemName: systemImageName)
                .foregroundColor(.green)
        }
        .fontWeight(.medium)
    }
}
//
