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
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .textFieldStyle(.roundedBorder)
                    Button {
                        // If it is not already in the list and it is not an empty String
                        // TODO: refactor out in a func and add proper url validation with regex in
                        if !repos.contains(newRepo) && !newRepo.isEmpty {
                            repos.append(newRepo)
                            // Save in UserDefaults
                            UserDefaults.shared.set(repos, forKey: UserDefaults.repoKey)
                            // Reset input text
                            newRepo.removeAll()
                        } else {
                            // TODO: show alert
                            print("repo already exists or name is empty")
                        }

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
                                    // The last repo can't be deleted!
                                    if repos.count > 1 {
                                        repos.removeAll { $0 == repo }
                                        // Overwrite the repos
                                        UserDefaults.shared.set(repos, forKey: UserDefaults.repoKey)
                                    } else {
                                        // TODO: show alert
                                    }
                                }
                                .tint(.red)
                            }
                    }
                }
            }
            .navigationTitle("Repo List")
            .onAppear {
                // TODO: refactor out in a func?
                guard let retrievedRepos = UserDefaults.shared.value(forKey: UserDefaults.repoKey) as? [String] else {
                    // Set default values
                    let defaultValues = ["simonberner/github-repowatcher-widget"]
                    UserDefaults.shared.set(defaultValues, forKey: UserDefaults.repoKey)
                    repos = defaultValues
                    return
                }
                repos = retrievedRepos
            }
        }
    }
}

struct GitHubRepoWatcherView_Previews: PreviewProvider {
    static var previews: some View {
        GitHubRepoWatcherView()
    }
}
