//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

struct ImageCommentsViewModel: Equatable {
	let comments: [ImageCommentViewModel]
}

struct ImageCommentViewModel: Equatable {
	init(message: String, date: String, userName: String) {
		self.message = message
		self.date = date
		self.userName = userName
	}

	let message: String
	let date: String
	let userName: String
}

class ImageCommentsPresenter {
	static var title: String = {
		NSLocalizedString(
			"IMAGE_COMMENTS_VIEW_TITLE",
			tableName: "ImageComments",
			bundle: Bundle(for: ImageCommentsPresenter.self),
			comment: "Title for the image comments view")
	}()

	static func map(_ imageComments: [ImageComment], currentDate: Date, calendar: Calendar, locale: Locale) -> ImageCommentsViewModel {
		let formatter = RelativeDateTimeFormatter()
		formatter.calendar = calendar
		formatter.locale = locale

		return ImageCommentsViewModel(comments: imageComments.map({
			ImageCommentViewModel(
				message: $0.message,
				date: formatter.localizedString(for: $0.createdAt, relativeTo: currentDate),
				userName: $0.userName)
		}))
	}
}

class ImageCommentsPresenterTests: XCTestCase {
//	func test_title_isLocalized() {
//		XCTAssertEqual(ImageCommentsPresenter.title, localized("IMAGE_COMMENTS_VIEW_TITLE"))
//	}

	func test_map_createsViewModel() {
		let now = Date()
		let calendar = Calendar(identifier: .gregorian)
		let locale = Locale(identifier: "en_US_POSIX")

		let date1 = now.adding(minutes: -5, calendar: calendar)
		let date2 = now.adding(days: -1, calendar: calendar)

		let message1 = "a message"
		let message2 = "another message"

		let userName1 = "a user"
		let userName2 = "another user"

		let item1 = ImageComment(id: UUID(), message: message1, createdAt: date1, userName: userName1)
		let item2 = ImageComment(id: UUID(), message: message2, createdAt: date2, userName: userName2)

		let imageComments = [item1, item2]

		let viewModel = ImageCommentsPresenter.map(imageComments, currentDate: now, calendar: calendar
		                                           , locale: locale)

		XCTAssertEqual(viewModel.comments, [ImageCommentViewModel(message: message1, date: "5 minutes ago", userName: userName1), ImageCommentViewModel(message: message2, date: "1 day ago", userName: userName2)])
	}

	// MARK: - Helpers

	private func localized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
		let table = "ImageComments"
		let bundle = Bundle(for: ImageCommentsPresenter.self)
		let value = bundle.localizedString(forKey: key, value: nil, table: table)
		if value == key {
			XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
		}
		return value
	}
}
