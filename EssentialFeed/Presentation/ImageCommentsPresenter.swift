//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

public class ImageCommentsPresenter {
	public static var title: String = {
		NSLocalizedString(
			"IMAGE_COMMENTS_VIEW_TITLE",
			tableName: "ImageComments",
			bundle: Bundle(for: ImageCommentsPresenter.self),
			comment: "Title for the image comments view")
	}()

	public static func map(_ imageComments: [ImageComment], currentDate: Date, calendar: Calendar, locale: Locale) -> ImageCommentsViewModel {
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
