//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

class ImageCommentsMapperTests: XCTestCase {
	func test_map_throwsErrorOnNon200HTTPResponse() throws {
		let json = makeItemsJSON([])
		let samples = [199, 201, 300, 400, 500]

		try samples.forEach { code in
			XCTAssertThrowsError(
				try ImageCommentsMapper.map(json, from: HTTPURLResponse(statusCode: code))
			)
		}
	}

	func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
		let invalidJSON = Data("invalid json".utf8)

		do {
			let _ = try ImageCommentsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
		} catch {
			let error = error as? ImageCommentsMapper.Error
			XCTAssertEqual(error, .invalidData)
		}
	}

	func test_map_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() throws {
		let emptyListJSON = makeItemsJSON([])

		let result = try ImageCommentsMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: 200))

		XCTAssertEqual(result, [])
	}

	class ImageCommentsMapper {
		struct Root: Decodable {
			let items: [RemoteImageComment]

			struct RemoteImageComment: Decodable {
				let id: UUID
				let message: String
				let created_at: Date
				let author: Author
			}

			struct Author: Decodable {
				let username: String
			}

			var comments: [ImageComment] {
				return items.map { ImageComment(id: $0.id, message: $0.message, createdAt: $0.created_at, userName: $0.author.username) }
			}
		}

		enum Error: Swift.Error {
			case invalidData
		}

		static func map(_ data: Data, from response: HTTPURLResponse) throws -> [ImageComment] {
			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .iso8601
			guard response.statusCode == 200, let root = try? decoder.decode(Root.self, from: data) else {
				throw Error.invalidData
			}

			return root.comments
		}
	}

	// ("2020-05-31T02:41:40-0700", Date(timeIntervalSince1970: 1590918100)),

	func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
		let item1 = makeItem(id: UUID(), message: "a message", createdAt: (date: Date(timeIntervalSince1970: 1622429594), iso8601String: "2021-05-31T02:53:14+00:00"), userName: "a user")

		let item2 = makeItem(id: UUID(), message: "another message", createdAt: (date: Date(timeIntervalSince1970: 1590918100), iso8601String: "2020-05-31T02:41:40-0700"), userName: "another user")

		let json = makeItemsJSON([item1.json, item2.json])

		let result = try ImageCommentsMapper.map(json, from: HTTPURLResponse(statusCode: 200))

		XCTAssertEqual(result, [item1.model, item2.model])
	}

	// MARK: - Helpers
	struct ImageComment: Hashable {
		internal init(id: UUID, message: String, createdAt: Date, userName: String) {
			self.id = id
			self.message = message
			self.createdAt = createdAt
			self.userName = userName
		}

		public let id: UUID
		public let message: String
		public let createdAt: Date
		public let userName: String
	}

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
