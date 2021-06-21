//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import UIKit
import EssentialFeed

public class ImageCommentCellController: NSObject {
	private let viewModel: ImageCommentViewModel
	private var cell: ImageCommentCell?

	public init(model: ImageCommentViewModel) {
		self.viewModel = model
	}
}

extension ImageCommentCellController: UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		1
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		cell = tableView.dequeueReusableCell()
		// configure cell
		cell?.messageLabel.text = viewModel.message
		cell?.dateLabel.text = viewModel.date
		cell?.userNameLabel.text = viewModel.userName
		return cell!
	}

	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}

	public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {}

	public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {}

	public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {}

	private func releaseCellForReuse() {
		cell = nil
	}
}
