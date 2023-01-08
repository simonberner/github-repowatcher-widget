//
//  ContentView.swift
//  GitHubRepoWatcher
//
//  Created by Simon Berner on 27.11.22.
//

import SwiftUI

struct GitHubRepoWatcherView: View {
    @State private var newRepo = ""
    @State private var repos: [String] = []

    var body: some View {
        NavigationStack{
            VStack {
                HStack {
                    TextField("ex. simonberner/github-repowatcher-widget", text: $newRepo)
                        .textInputAutocapitalization(.none)
                        .autocorrectionDisabled()
                        .textFieldStyle(.roundedBorder)
                    Button {

                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.green)
                    }
                }
                .padding()

                VStack(alignment: .leading) {
                    Text("Saved Repos")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.leading)

                    List(repos, id: \.self) { repo in
                        Text(repo)
                            .swipeActions {
                                Button("Delete") {

                                }
                                .tint(.red)
                            }
                    }
                }
            }
            .navigationTitle("Repo List")
        }
    }
}

struct GitHubRepoWatcherView_Previews: PreviewProvider {
    static var previews: some View {
        GitHubRepoWatcherView()
    }
}
