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
}

/// Main view model
final class MainViewModel: MainViewModelProtocol {

	/// View controller
	var viewController: MainViewControllerProtocol?

	private var dataProvider: QuestionnaireDataProviderProtocol

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

	// MARK: - Private

	private func handleFetchedQuestions(_ questions: [Question]) {
		var items: [RKTableViewCellProtocol] = []
		questions.forEach {
			items.append(PlainCell(title: $0.question))
		}
		viewController?.setUIData(items)
	}

	private func handleFetchingError(_ error: Error?) {}
}
