//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

public struct ImageCommentViewModel: Equatable {
	public init(message: String, date: String, userName: String) {
		self.message = message
		self.date = date
		self.userName = userName
	}

	public let message: String
	public let date: String
	public let userName: String
}
