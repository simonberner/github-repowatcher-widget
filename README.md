# GitHub Repo Watcher Widget

This is a more advanced iOS16+ widget project to learn how to create a medium and large widget which relies on network calls to update its content.

<p align="center">
    <a href="https://en.wikipedia.org/wiki/IOS">
        <img src="https://img.shields.io/badge/iOS-16+-blue.svg?style=for-the-badge" />
    </a>
    <a href="https://www.swift.org/">
        <img src="https://img.shields.io/badge/Swift-5.7.1-brightgreen.svg?style=for-the-badge&logo=swift" />
    </a>
    <a href="https://developer.apple.com/xcode/swiftui">
        <img src="https://img.shields.io/badge/SwiftUI-blue.svg?style=for-the-badge&logo=swift&logoColor=black" />
    </a>
    <a href="https://developer.apple.com/xcode">
        <img src="https://img.shields.io/badge/Xcode-14.1-blue.svg?style=for-the-badge" />
    </a>
    <a href="https://mastodon.green/@simonberner">
        <img src="https://img.shields.io/badge/Contact-@simonberner-orange?style=for-the-badge" alt="mastodon.green/@simonberner" />
    </a>
    <a href="https://gitmoji.dev">
        <img src="https://img.shields.io/badge/gitmoji-%20😜%20😍-FFDD67.svg?style=for-the-badge" alt="Gitmoji">
    </a>
    <a href="https://github.com/conventional-commits/conventionalcommits.org">
        <img src="https://img.shields.io/badge/Conventional%20Commits-📝-lightgrey.svg?style=for-the-badge" alt="Conventional Commits">
    </a>
    <a href="https://opensource.org/licenses/MIT">
        <img src="https://img.shields.io/badge/license-MIT-black.svg?style=for-the-badge" />
    </a>
</p>

---

## Contents
* [Functionality](#functionality)
* [Tech Stack](#tech-stack)
* [Frameworks](#frameworks)
* [Device Compatibility](#device-compatibility)
* [Screenshots](#screenshots)
* [Learnings](#learnings)
* [GitHub API Call](#gitHub-api-call)
* [Code Comments](#code-comments)
* [Credits](#credits)

---

## Functionality
A medium and large sized Widget that gets a GitHub repository and displays the following infos:
- Owner avatar image
- Repository name
- Days since last pushes
- Number of watchers
- Number of forks
- Number of open issues

## Tech Stack
- Xcode 14.1
- Swift 5.7.1

## Frameworks
- SwiftUI
- WidgetKit

## Device Compatibility
- iPhone >= iOS16+
- iPad >= iOS16+

## Screenshots

![repo](compact-widgets.png)
![contributors](contributor-widget.png)

## Learnings
- AsyncImage is not working for widgets.
- To chose good useful information to show to a user of a widget is fundamental. A good widget has to show to a user:
    - Glanceable UI Elements
    - Graphical attractive data
    - Quick information
### Widget Gallery
Point of contention:
- Apple recommends giving a Widget some placeholder (mock data) to show it in the Widget Gallery instead of doing any network calls.
(Note: Twitch does network calls in getSnapshot, but probably because of some business reasons)
- But we want to show our users the best representation of our widgets, so how do we do that? Better mock-data?
### Alerts
- Normally there are no error alerts shown to a user in a widget.
    - But there are cases where it makes sense to tell the user an issue (eg. 'Sign in with Google').
    - How you handle errors in Widgets is a unique product decision.
    - To make our lives as developer easier, add log/print statements for debugging errors.
### Network calls
- A successive network call is a network call that relies on a parent network call
### JSON
- [Codable: A type alias for Encodable and Decodable](https://www.swiftbysundell.com/basics/codable/)
- [Ignoring invalid JSON elements when using Codable](https://www.swiftbysundell.com/articles/ignoring-invalid-json-elements-codable/)
### Structured Concurrency
- Async/await: 'try await' is like a guard statement, if it fails nothing is being executed below it (because it falls into the catch block)
### Widget Bundle
- If we have an App with different widget types, we can put them into a [WidgetBundle](https://developer.apple.com/documentation/swiftui/widgetbundle)
    
## GitHub API Call
- [Get a repository](https://docs.github.com/en/rest/repos/repos#get-a-repository)

## Code Comments
I love putting in the effort of adding comments to my code, [here is why](https://www.youtube.com/watch?v=1NEa-OcsTow).

## Credits
🙏🏽 Sean Allen

