//
//  QuestionnaireDataProvider.swift
//  Questionnaire
//
//  Created by Roman on 25/05/2023.
//

import Foundation

/// Questionnaire data provider service protocol
protocol QuestionnaireDataProviderProtocol {

	/// Fetch questions
	/// - Parameter completion: completion that returns fetched questions array or/and error received while fetching
	func fetchQuestions(completion: @escaping (Result<[Question], Error>) -> Void)

	/// Save answers
	/// - Parameter answers: answers
	/// - Parameter completion: completion with the result
	func saveAnswers(_ answers: [UUID: String], completion: @escaping (Result<Bool, Error>) -> Void)
}

/// Questionnaire data provider
final class QuestionnaireDataProvider: QuestionnaireDataProviderProtocol {

	private let networkService: NetworkServiceProtocol

	/// Initializer
	/// - Parameter networkService: network service
	init(networkService: NetworkServiceProtocol) {
		self.networkService = networkService
	}

	func fetchQuestions(completion: @escaping (Result<[Question], Error>) -> Void) {
		guard let url = Constants.urlForQuestions else {
			completion(.failure(CustomError.customError(SemanticStrings.Errors.serverUnavailable)))
			return
		}
		networkService.fetchData(by: url) { [weak self] result in
			self?.handleFetchedResults(result, completion: completion)
		}
	}

	func saveAnswers(_ answers: [UUID: String], completion: @escaping (Result<Bool, Error>) -> Void) {
		guard let url = Constants.urlForAnswers else {
			completion(.failure(CustomError.customError(SemanticStrings.Errors.serverUnavailable)))
			return
		}

		let encodeer = JSONEncoder()
		guard let encodedData = try? encodeer.encode(answers) else {
			completion(.failure(CustomError.customError(SemanticStrings.Errors.answersUnsaved)))
			return
		}

		print("📀📀📀 JSON to save:\n")
		print(String(data: encodedData, encoding: .utf8) ?? String())

		networkService.uploadData(by: url, data: encodedData) { result in
			switch result {
			case .success:
				completion(.success(true))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}

	// MARK: - Private

	func handleFetchedResults(_ result: Result<Data, Error>, completion: @escaping (Result<[Question], Error>) -> Void) {
		switch result {
		case .success(let data):
			let fetchedQuestions = try? JSONDecoder().decode([Question].self, from: data)
			completion(.success(fetchedQuestions ?? []))
		case .failure(let error):
			completion(.failure(error))
		}
	}
}
