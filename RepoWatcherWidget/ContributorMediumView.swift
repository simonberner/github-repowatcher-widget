//
//  ContributorMediumView.swift
//  RepoWatcherWidgetExtension
//
//  Created by Simon Berner on 05.12.22.
//

import SwiftUI
import WidgetKit

struct ContributorMediumView: View {

    var repo: Repository

    var body: some View {
        VStack {
            HStack {
                Text("Top Contributors")
                    .font(.callout).bold()
                    .foregroundColor(.secondary)
                Spacer()
            }
            // LazyVGrid with 4 HStacks for the top contributors
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2),
                      alignment: .leading,
                      spacing: 20) {
                ForEach(repo.contributors) { contributor in
                    HStack {
                        Image(uiImage: UIImage(data: contributor.avatarData) ?? UIImage(named: "avatar")!)
                            .resizable()
                            .frame(width: 44, height: 44)
                            .clipShape(Circle())

                        VStack(alignment: .leading) {
                            Text(contributor.login)
                                .font(.caption)
                                .minimumScaleFactor(0.7)
                            Text("\(contributor.contributions)")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .id(repo.name)
                                .transition(.push(from: .trailing))
                        }
                    }
                }
            }
        }
    }
}
