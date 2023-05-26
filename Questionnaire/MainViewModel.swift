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
		dataProvider.fetchQuestions() { [weak self] questions, error in
			guard error == nil else {
				self?.handleFetchingError(error)
				return
			}
			self?.handleFetchedQuestions(questions)
		}
	}

	func submitButtonTapped() {}

	// MARK: - Private

	private func handleFetchedQuestions(_ questions: [Question]) {
		var items: [RKTableViewCellProtocol] = []
		questions.forEach {
			items.append(makeCellFor($0))
		}
		viewController?.setUIData(items)
	}

	private func handleFetchingError(_ error: Error?) {}

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
		if var existedAnswer = answers.first(where: { $0.questionUUID == questionUUID } ) {
			existedAnswer.answer = answer
		} else {
			answers.append(Answer(questionUUID: questionUUID, answer: answer))
		}
	}
}
