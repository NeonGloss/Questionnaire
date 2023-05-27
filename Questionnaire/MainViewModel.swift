//
//  MainViewModel.swift
//  Questionnaire
//
//  Created by Roman on 25/05/2023.
//

import Foundation

/// Main view model protocol
protocol MainViewModelProtocol {

	/// Notify that view did load
    func viewDidLoad()

	/// Notify that submit button tapped
	func submitButtonTapped()
}

/// Main view model
final class MainViewModel: MainViewModelProtocol {

	/// View controller
	var viewController: MainViewControllerProtocol?

	private var dataProvider: QuestionnaireDataProviderProtocol

	private var questions: [Question] = []
	private var answers: [UUID: String] = [:]

	/// Initializer
	/// - Parameter dataProvider: data provider
	init(dataProvider: QuestionnaireDataProviderProtocol) {
		self.dataProvider = dataProvider
	}

	// MARK: - MainViewModelProtocol

	func viewDidLoad() {
		dataProvider.fetchQuestions() { [weak self] result in
			switch result {
			case .success(let questions):
				self?.handleFetchedQuestions(questions)
			case .failure:
				self?.handleError(withText: SemanticStrings.Errors.questionsUnreacheble)
				self?.handleFetchedQuestions(Constants.questions)
			}
		}
	}

	func submitButtonTapped() {
		let requiredQuestionsUUIDs = Set(questions.compactMap { $0.isRequired ? $0.uuid : nil } )
		guard requiredQuestionsUUIDs.subtracting(answers.keys).isEmpty else {
			handleError(withText: SemanticStrings.Errors.answerRequiredQuestions)
			return
		}

		dataProvider.saveAnswers(answers) { [weak self] result in
			switch result {
			case .success:
				self?.handleSavingAnswersSuccess()
			case .failure:
				self?.handleError(withText: SemanticStrings.Errors.answersUnsaved)
			}
		}
	}

	// MARK: - Private

	private func handleFetchedQuestions(_ questions: [Question]) {
		self.questions = questions
		viewController?.setUIData(makeItemsFor(questions))
	}

	private func handleSavingAnswersSuccess() {
		viewController?.displayAlertWith(text: SemanticStrings.submittedSuccessfully)
	}

	private func handleError(withText text: String) {
		viewController?.displayAlertWith(text: text)
	}

	private func makeItemsFor(_ questions: [Question]) -> [RKTableViewCellProtocol] {
		var items: [RKTableViewCellProtocol] = []
		items.append(HeaderCell(headerText: "GoTech\nQuestionnaire",
								subText: "Show me what you got!",
								cautionText: "* Required"))
		questions.forEach {
			items.append(makeCellFor($0))
		}
		return items
	}

	private func makeCellFor(_ question: Question) -> RKTableViewCellProtocol {
		let questionString = !question.isRequired ? NSAttributedString(string:question.questionText) :
													makeQuestionStringWithRedStar(question.questionText)

		switch question.questionType {

		case .multipleChoice(let multipleChoiceData):
			return MultipleChoiceQuestionCell(questionUUID: question.uuid,
											  text: questionString,
											  choices: multipleChoiceData,
											  output: self)
		case .textFilling(let placeholder):
			return TextFillingQuestionCell(questionUUID: question.uuid,
										   text: questionString,
										   placeholder: placeholder,
										   output: self)
		}
	}

	private func makeQuestionStringWithRedStar(_ text: String) -> NSAttributedString {
		let resultText = text + " *"
		let range = (resultText as NSString).range(of: " *")

		let attributedString = NSMutableAttributedString(string:resultText)
		attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
									  value: Constants.Design.Colors.alert,
									  range: range)
		return attributedString
	}
}

extension MainViewModel: QuestionCellOutput {

	func answerFor(questionUUID: UUID, answer: String?) {
		answers[questionUUID] = answer
	}
}
