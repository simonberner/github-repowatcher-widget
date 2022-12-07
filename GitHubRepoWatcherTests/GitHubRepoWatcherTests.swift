//
//  GitHubRepoWatcherTests.swift
//  GitHubRepoWatcherTests
//
//  Created by Simon Berner on 27.11.22.
//

import XCTest
@testable import GitHubRepoWatcher

// https://www.hackingwithswift.com/read/39/2/creating-our-first-unit-test-using-xctest
final class GitHubRepoWatcherTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testThatApiCallReturnsRepoName() async throws {
        // Arrange
        let repoURL = "https://api.github.com/repos/simonberner/github-repowatcher-widget"

        // Act
        let repo = try await NetworkManager.shared.getRepo(atUrl: repoURL)

        // Assert
        XCTAssertEqual(repo.name, "github-repowatcher-widget")
    }

    func testThatApiCallReturnsContributors() async throws {
        // Arrange

        // Act

        // Assert
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
