//
//  loadJson.swift
//  Reddit-ShowcaseTests
//
//  Created by Gustavo on 9/06/21.
//

import Foundation

func loadJson(named name: String) -> Data? {
    let bundle = Bundle(for: RemoteRedditTopFeedLoaderTests.self)
    guard let url = bundle.url(forResource: name, withExtension: "json") else { return nil }
    return try? Data(contentsOf: url)
}
