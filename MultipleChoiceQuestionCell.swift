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
	private var variantsElements: [(UIButton, UITextField?)] = []
	private enum Sizes {
		static let underlineHeight: CGFloat = 1
	}

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

	private lazy var choicesStack: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.distribution = .fill
		return stackView
	}()

	/// Initializer
	/// - Parameters:
	///   - questionUUID: question UUID
	///   - text: question text
	///   - choices: variants for user choosing
	///   - output: object for reacting on user interactions
	init(questionUUID: UUID, text: NSAttributedString, choices: [MultipleChoiceElement], output: QuestionCellOutput?) {
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

	private func setupUI(text: NSAttributedString, choices: [MultipleChoiceElement]) {
		selectionStyle = .none
		backgroundColor = .clear
		questionLabel.attributedText = text
		makeChoicesUIElements(for: choices).forEach { choicesStack.addArrangedSubview($0) }
	}

	private func makeChoicesUIElements(for choices: [MultipleChoiceElement]) -> [UIStackView] {
		var choicesStackView: [UIStackView] = []
		choices.forEach { element in
			let button: UIButton = {
				var configuration = UIButton.Configuration.filled()
				configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
				configuration.image = SemanticImages.bulletPointPassive
				configuration.baseForegroundColor = .black
				configuration.baseBackgroundColor = .clear
				configuration.imagePadding = 10

				let button = UIButton()
				button.configuration = configuration
				button.contentHorizontalAlignment = .leading
				button.addTarget(self, action: #selector(buttonDidTapped(_:)), for: .touchUpInside)
				return button
			}()

			let textField = UITextField()
			textField.delegate = self
			textField.isUserInteractionEnabled = false

			let textFieldUnderlineView = UIView()
			textFieldUnderlineView.backgroundColor = Constants.Design.Colors.background
			textFieldUnderlineView.heightAnchor.constraint(equalToConstant: Sizes.underlineHeight).isActive = true

			let choiceStackView = UIStackView()
			choiceStackView.distribution = .fill
			choiceStackView.axis = .horizontal
			choiceStackView.spacing = 20

			switch element {
			case .plain(let text):
				button.setTitle(text, for: .normal)
				choiceStackView.addArrangedSubview(button)
				variantsElements.append((button, nil))
			case .textFilling(let text, let placeholder):
				textField.placeholder = placeholder
				button.setTitle(text, for: .normal)
				button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
				choiceStackView.addArrangedSubview(button)

				let verticalStack = UIStackView(arrangedSubviews: [textField, textFieldUnderlineView])
				verticalStack.distribution = .fill
				verticalStack.axis = .vertical

				choiceStackView.addArrangedSubview(verticalStack)
				variantsElements.append((button, textField))
			}
			choicesStackView.append(choiceStackView)
		}
		return choicesStackView
	}

	@objc private func buttonDidTapped(_ button: UIButton) {
		variantsElements.forEach { variantElement in
			if variantElement.0 === button,
			   variantElement.1 != nil {
				variantElement.0.setImage(SemanticImages.bulletPointActive, for: .normal)
				variantElement.1?.isUserInteractionEnabled = true
				answerReceived(nil)
			} else if variantElement.0 === button {
				variantElement.0.setImage(SemanticImages.bulletPointActive, for: .normal)
				answerReceived(button.titleLabel?.text)
			} else {
				variantElement.0.setImage(SemanticImages.bulletPointPassive, for: .normal)
				variantElement.1?.isUserInteractionEnabled = false
				variantElement.1?.text = nil
			}
		}
	}

	private func answerReceived(_ answer: String?) {
		output?.answerFor(questionUUID: questionUUID, answer: answer)
	}

	private func setupConstraints() {
		[underView, questionLabel, choicesStack].forEach { contentView.addSubview($0) }
		contentView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

		NSLayoutConstraint.activate([
			underView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.Design.Sizes.cellsVerticalIndent),
			underView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.Design.Sizes.cellsVerticalIndent),
			underView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Design.Sizes.cellsHorizontalIndent),
			underView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Design.Sizes.cellsHorizontalIndent),

			questionLabel.topAnchor.constraint(equalTo: underView.topAnchor, constant: Constants.Design.Sizes.verticalBigIndent),
			questionLabel.leadingAnchor.constraint(equalTo: underView.leadingAnchor, constant: Constants.Design.Sizes.cellsContentHorizontalIndent),
			questionLabel.trailingAnchor.constraint(equalTo: underView.trailingAnchor, constant: -Constants.Design.Sizes.cellsContentHorizontalIndent),

			choicesStack.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: Constants.Design.Sizes.verticalBigIndent),
			choicesStack.leadingAnchor.constraint(equalTo: underView.leadingAnchor, constant: Constants.Design.Sizes.cellsContentHorizontalIndent),
			choicesStack.trailingAnchor.constraint(equalTo: underView.trailingAnchor,  constant: -Constants.Design.Sizes.cellsContentHorizontalIndent),
			choicesStack.bottomAnchor.constraint(equalTo: underView.bottomAnchor, constant: -Constants.Design.Sizes.verticalBigIndent),
		])
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
		var resultAnswer: String? = nil
		if let text = textField.text {
			let variantElements = variantsElements.first{ $0.1 === textField }
			resultAnswer = variantElements?.0.currentTitle?.appending(text)
		}
		answerReceived(resultAnswer)
	}
}
