//
//  TextFillingQuestionCell.swift
//  Questionnaire
//
//  Created by Roman on 25/05/2023.
//

import UIKit

/// Cell for multiple choice question
final class MultipleChoiceQuestionCell: UITableViewCell, RKTableViewCellProtocol {

	var shouldReuse = false

	private let output: QuestionCellOutput?
	private let questionUUID: UUID

	private let questionLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 3
		return label
	}()

	private var underView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		view.layer.cornerRadius = Constants.Design.Sizes.cellCornerRadius
		return view
	}()

	private var buttons: [UIButton] = []

	private var textFieldUnderline: UIView = {
		let view = UIView()
		view.backgroundColor = .blue
		return view
	}()

	private var textField: UITextField = {
		let textField = UITextField()
		textField.autocapitalizationType = .none
		textField.autocorrectionType = .no
		return textField
	}()

	private enum Sizes {
		static let verticalIndent: CGFloat = 10
		static let underlineHeight: CGFloat = 1
		static let contentToBottom: CGFloat = 30
		static let textFieldHeight: CGFloat = 20
		static let horizontalIndent: CGFloat = 15
		static let textFieldToUnderline: CGFloat = 5
		static let verticalUnderViewInden: CGFloat = 10
		static let underViewHorizontalIndent: CGFloat = 20

		static let firstButtonToBottom: CGFloat = 15
		static let buttonHeight: CGFloat = 40
		static let indentBetweenButtons: CGFloat = 15
		static let contentToSubcontentMultiplier: CGFloat = 0.8
		static let underlineToButton: CGFloat = 5
	}

	/// Initializer
	/// - Parameters:
	///   - questionUUID: question UUID
	///   - text: question text
	///   - choices: variants for user choosing
	///   - output: object for reacting on user interactions
	init(questionUUID: UUID, text: String, choices: [MultipleChoiceElement], output: QuestionCellOutput?) {
		self.output = output
		self.questionUUID = questionUUID
		super.init(style: .subtitle, reuseIdentifier: nil)
		setupUI(text: text, choices: choices)
		setupConstraints()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private

	private func setupUI(text: String, choices: [MultipleChoiceElement]) {
		selectionStyle = .none
		textField.delegate = self
		backgroundColor = .clear

		questionLabel.text = text

		choices.forEach { element in
			let resultText: String
			switch element {
			case .plain(let text):
				resultText = text
			case .textFilling(let text, _):
				resultText = text
			}
			let button = UIButton()
			button.backgroundColor = .white
			button.layer.borderColor = UIColor.black.cgColor
			button.setImage(SemanticImages.bulletPointPassive, for: .normal)

			button.setTitle(resultText, for: .normal)
			button.setTitleColor(.black, for: .normal)
			button.layer.borderWidth = 1
			button.layer.cornerRadius = 18
			button.addTarget(self, action: #selector(buttonDidTapped(_:)), for: .touchUpInside)
			buttons.append(button)
		}

	}

	@objc private func buttonDidTapped(_ button: UIButton) {
		answerReceived(button.titleLabel?.text)
	}

	private func answerReceived(_ answer: String?) {
		guard let answer = answer,
			  !answer.isEmpty else { return }
		
		output?.answerFor(questionUUID: questionUUID, answer: answer)
	}

	private func setupConstraints() {
		contentView.addSubview(underView)
		contentView.addSubview(questionLabel)
		contentView.addSubview(textField)
		contentView.addSubview(textFieldUnderline)
		buttons.forEach {
			contentView.addSubview($0)
		}

		contentView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

		NSLayoutConstraint.activate([
			underView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Sizes.verticalUnderViewInden),
			underView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Sizes.verticalUnderViewInden),
			underView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Sizes.underViewHorizontalIndent),
			underView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Sizes.underViewHorizontalIndent),

			questionLabel.topAnchor.constraint(equalTo: underView.topAnchor, constant: Sizes.verticalIndent),
			questionLabel.leadingAnchor.constraint(equalTo: underView.leadingAnchor, constant: Sizes.horizontalIndent),
			questionLabel.trailingAnchor.constraint(equalTo: underView.trailingAnchor, constant: -Sizes.horizontalIndent),

			textField.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: Sizes.verticalIndent),
			textField.leadingAnchor.constraint(equalTo: questionLabel.leadingAnchor),
			textField.trailingAnchor.constraint(equalTo: questionLabel.trailingAnchor),
			textField.heightAnchor.constraint(equalToConstant: Sizes.textFieldHeight),

			textFieldUnderline.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: Sizes.textFieldToUnderline),
			textFieldUnderline.leadingAnchor.constraint(equalTo: questionLabel.leadingAnchor),
			textFieldUnderline.trailingAnchor.constraint(equalTo: questionLabel.trailingAnchor),
			textFieldUnderline.heightAnchor.constraint(equalToConstant: Sizes.underlineHeight),
		])

		buttons.enumerated().forEach { index, button in
			let indentFromBottom =
				Sizes.contentToBottom + ((Sizes.buttonHeight + Sizes.indentBetweenButtons) * CGFloat(index))
			NSLayoutConstraint.activate([
				button.leadingAnchor.constraint(equalTo: questionLabel.leadingAnchor),
				button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -indentFromBottom),
				button.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: Sizes.contentToSubcontentMultiplier),
				button.heightAnchor.constraint(equalToConstant: Sizes.buttonHeight)
			])
			if index == buttons.count - 1 {
				NSLayoutConstraint.activate([
					button.topAnchor.constraint(equalTo: textFieldUnderline.bottomAnchor, constant: Sizes.underlineToButton)
				])
			}
		}
	}

	// MARK: - RKTableViewCellProtocol

	func didSelected() {}

	func selectedToBeEdited() {}

	func someCellWasSelected() {}

	func emptySpaceOnTableWasTapped() {}

	func selectedToBeRemoved(complition: @escaping (Bool) -> ()) {}
}

extension MultipleChoiceQuestionCell: UITextFieldDelegate {

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textChanged(in: textField)
		return false
	}

	func textFieldDidChangeSelection(_ textField: UITextField) {
		textChanged(in: textField)
	}

	// MARK: Private

	private func textChanged(in textField: UITextField) {
		answerReceived(textField.text)
	}
}
