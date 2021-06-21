//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

public final class ImageCommentsMapper {
	public struct Root: Decodable {
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

	public enum Error: Swift.Error {
		case invalidData
	}

	public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [ImageComment] {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		guard (200 ... 299).contains(response.statusCode), let root = try? decoder.decode(Root.self, from: data) else {
			throw Error.invalidData
		}

		return root.comments
	}
}
