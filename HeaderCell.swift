//
//  HeaderCell.swift
//  Questionnaire
//
//  Created by Roman on 27/05/2023.
//

import UIKit

/// Cell with basic information displayed
final class HeaderCell: UITableViewCell, RKTableViewCellProtocol {

	var shouldReuse = false

	private var underView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		view.layer.cornerRadius = Constants.Design.Sizes.cellCornerRadius
		return view
	}()

	private let headerLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 30).bold()
		label.numberOfLines = 2
		return label
	}()

	private let subheaderLabel: UILabel = {
		let label = UILabel()
		return label
	}()

	private let cautionLabel: UILabel = {
		let label = UILabel()
		label.textColor = .red
		return label
	}()

	private var thickLineView: TopCornerRoundedUIView = {
		let view = TopCornerRoundedUIView()
		view.radius = Int(Constants.Design.Sizes.cellCornerRadius)
		view.backgroundColor = Constants.Design.Colors.nuance0
		return view
	}()

	private var thinLineView: UIView = {
		let view = UIView()
		view.backgroundColor = Constants.Design.Colors.background
		return view
	}()

	private enum Sizes {
		static let thickLineHeight: CGFloat = 10
		static let thinLineHeight: CGFloat = 1
	}

	/// Initializer
	/// - Parameters:
	///   - questionUUID: question UUID
	///   - text: question text
	///   - placeholder: placeholer
	///   - output: object for reacting on user interactions
	init(headerText: String, subText: String?, cautionText: String?) {
		super.init(style: .subtitle, reuseIdentifier: nil)
		setupUI(headerText: headerText, subText: subText, cautionText: cautionText)
		setupConstraints()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private

	private func setupUI(headerText: String, subText: String?, cautionText: String?) {
		selectionStyle = .none
		backgroundColor = .clear

		headerLabel.text = headerText
		subheaderLabel.text = subText
		cautionLabel.text = cautionText
	}

	private func setupConstraints() {
		contentView.addSubview(underView)
		contentView.addSubview(headerLabel)
		contentView.addSubview(cautionLabel)
		contentView.addSubview(thinLineView)
		contentView.addSubview(thickLineView)
		contentView.addSubview(subheaderLabel)

		contentView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

		NSLayoutConstraint.activate([
			underView.topAnchor.constraint(equalTo: contentView.topAnchor,
										   constant: Constants.Design.Sizes.cellsVerticalIndent),
			underView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
											  constant: -Constants.Design.Sizes.cellsVerticalIndent),
			underView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
											   constant: Constants.Design.Sizes.cellsHorizontalIndent),
			underView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
												constant: -Constants.Design.Sizes.cellsHorizontalIndent),

			thickLineView.topAnchor.constraint(equalTo: underView.topAnchor),
			thickLineView.centerXAnchor.constraint(equalTo: underView.centerXAnchor),
			thickLineView.widthAnchor.constraint(equalTo: underView.widthAnchor),
			thickLineView.heightAnchor.constraint(equalToConstant: Sizes.thickLineHeight),

			headerLabel.topAnchor.constraint(equalTo: thickLineView.topAnchor,
											 constant: Constants.Design.Sizes.verticalBigIndent),
			headerLabel.leadingAnchor.constraint(equalTo: underView.leadingAnchor,
												 constant: Constants.Design.Sizes.cellsContentHorizontalIndent),
			headerLabel.trailingAnchor.constraint(equalTo: underView.trailingAnchor,
												  constant: -Constants.Design.Sizes.cellsContentHorizontalIndent),

			subheaderLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor,
												constant: Constants.Design.Sizes.verticalBigIndent),
			subheaderLabel.leadingAnchor.constraint(equalTo: headerLabel.leadingAnchor),
			subheaderLabel.trailingAnchor.constraint(equalTo: headerLabel.trailingAnchor),

			thinLineView.topAnchor.constraint(equalTo: subheaderLabel.bottomAnchor,
											  constant: Constants.Design.Sizes.verticalSmallIndent),
			thinLineView.leadingAnchor.constraint(equalTo: underView.leadingAnchor),
			thinLineView.trailingAnchor.constraint(equalTo: underView.trailingAnchor),
			thinLineView.heightAnchor.constraint(equalToConstant: Sizes.thinLineHeight),

			cautionLabel.topAnchor.constraint(equalTo: thinLineView.bottomAnchor,
											  constant: Constants.Design.Sizes.verticalSmallIndent),
			cautionLabel.bottomAnchor.constraint(equalTo: underView.bottomAnchor,
												 constant: -Constants.Design.Sizes.verticalSmallIndent),
			cautionLabel.leadingAnchor.constraint(equalTo: headerLabel.leadingAnchor),
			cautionLabel.trailingAnchor.constraint(equalTo: headerLabel.trailingAnchor)
		])
	}

	// MARK: - RKTableViewCellProtocol

	func didSelected() {}

	func selectedToBeEdited() {}

	func someCellWasSelected() {}

	func emptySpaceOnTableWasTapped() {}

	func selectedToBeRemoved(complition: @escaping (Bool) -> ()) {}
}
