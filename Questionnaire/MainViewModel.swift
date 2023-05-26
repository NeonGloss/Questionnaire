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

	private var answers: [Answer] = []

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
				self?.handleError(withText: "Could not load questions")
			}
		}
	}

	func submitButtonTapped() {
		dataProvider.saveAnswers(answers) { [weak self] result in
			switch result {
			case .success:
				self?.handleSavingAnswersSuccess()
			case .failure:
				self?.handleError(withText: "Could not load questions")
			}
		}
	}

	// MARK: - Private

	private func handleFetchedQuestions(_ questions: [Question]) {
		var items: [RKTableViewCellProtocol] = []
		questions.forEach {
			items.append(makeCellFor($0))
		}
		viewController?.setUIData(items)
	}

	private func handleSavingAnswersSuccess() {
	}

	private func handleError(withText text: String) {
	}

	private func makeCellFor(_ question: Question) -> RKTableViewCellProtocol {
		switch question.questionType {
		case .multipleChoice(let multipleChoiceData):
			return MultipleChoiceQuestionCell(questionUUID: question.uuid,
											  text: question.questionText,
											  choices: multipleChoiceData,
											  output: self)
		case .textFilling(let placeholder):
			return TextFillingQuestionCell(questionUUID: question.uuid,
										   text: question.questionText,
										   placeholder: placeholder,
										   output: self)
		}
	}
}

extension MainViewModel: QuestionCellOutput {

	func answerFor(questionUUID: UUID, answer: String) {
		if let existedAnswer = answers.first(where: { $0.questionUUID == questionUUID } ) {
			existedAnswer.answer = answer
		} else {
			answers.append(Answer(questionUUID: questionUUID, answer: answer))
		}
	}
}
