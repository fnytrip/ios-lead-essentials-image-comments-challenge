//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

class ImageCommentsPresenterTests: XCTestCase {
	func test_title_isLocalized() {
		XCTAssertEqual(ImageCommentsPresenter.title, localized("IMAGE_COMMENTS_VIEW_TITLE"))
	}

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
