//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

class ImageCommentsMapperTests: XCTestCase {
	func test_map_throwsErrorOnNon2XXHTTPResponse() throws {
		let json = makeItemsJSON([])
		let samples = [199, 300, 400, 500]

		try samples.forEach { code in
			XCTAssertThrowsError(
				try ImageCommentsMapper.map(json, from: HTTPURLResponse(statusCode: code))
			)
		}
	}

	func test_map_throwsErrorOn2XXHTTPResponseWithInvalidJSON() {
		let invalidJSON = Data("invalid json".utf8)
		let sampleCodes = [200, 201, 250, 299]

		for code in sampleCodes {
			do {
				let _ = try ImageCommentsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: code))
			} catch {
				let error = error as? ImageCommentsMapper.Error
				XCTAssertEqual(error, .invalidData)
			}
		}
	}

	func test_map_deliversNoItemsOn2XXHTTPResponseWithEmptyJSONList() throws {
		let emptyListJSON = makeItemsJSON([])

		let sampleCodes = [200, 201, 250, 299]
		for code in sampleCodes {
			let result = try ImageCommentsMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: code))

			XCTAssertEqual(result, [])
		}
	}

	func test_map_deliversItemsOn2XXHTTPResponseWithJSONItems() throws {
		let item1 = makeItem(id: UUID(), message: "a message", createdAt: (date: Date(timeIntervalSince1970: 1622429594), iso8601String: "2021-05-31T02:53:14+00:00"), userName: "a user")

		let item2 = makeItem(id: UUID(), message: "another message", createdAt: (date: Date(timeIntervalSince1970: 1590918100), iso8601String: "2020-05-31T02:41:40-0700"), userName: "another user")

		let json = makeItemsJSON([item1.json, item2.json])
		let sampleCodes = [200, 201, 250, 299]
		for code in sampleCodes {
			let result = try ImageCommentsMapper.map(json, from: HTTPURLResponse(statusCode: code))
			XCTAssertEqual(result, [item1.model, item2.model])
		}
	}

	// MARK: - Helpers
	private func makeItem(id: UUID, message: String, createdAt: (date: Date, iso8601String: String), userName: String) -> (model: ImageComment, json: [String: Any]) {
		let item = ImageComment(id: id, message: message, createdAt: createdAt.date, userName: userName)

		let json: [String: Any] = [
			"id": id.uuidString,
			"message": message,
			"created_at": createdAt.iso8601String,
			"author": [
				"username": userName
			]
		]

		return (item, json)
	}
}
