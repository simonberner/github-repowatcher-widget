//
//  ContributorMediumView.swift
//  RepoWatcherWidgetExtension
//
//  Created by Simon Berner on 05.12.22.
//

import SwiftUI
import WidgetKit

struct ContributorMediumView: View {
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
                ForEach(0..<4) { i in
                    HStack {
                        Image(uiImage: UIImage(named: "avatar")!)
                            .resizable()
                            .frame(width: 44, height: 44)
                            .clipShape(Circle())

                        VStack(alignment: .leading) {
                            Text("simonberner")
                                .font(.caption)
                                .minimumScaleFactor(0.7)
                            Text("5")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .padding()
    }
}

struct ContributorMediumView_Previews: PreviewProvider {
    static var previews: some View {
        ContributorMediumView()
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
