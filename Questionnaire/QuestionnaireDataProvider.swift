//
//  QuestionnaireDataProvider.swift
//  Questionnaire
//
//  Created by Roman on 25/05/2023.
//

/// Questionnaire data provider service protocol
protocol QuestionnaireDataProviderProtocol {

	/// Fetch questions
	/// - Parameter completion: completion that returns fetched questions array or/and error received while fetching
	func fetchQuestions(completion: @escaping ([Question], Error?) -> Void)
}

/// Questionnaire data provider
final class QuestionnaireDataProvider: QuestionnaireDataProviderProtocol {
    
    func fetchQuestions(completion: @escaping ([Question], Error?) -> Void) {
		let questions = [Question(question: "question1", correctAnswer: "questiion1Answer"),
						 Question(question: "question2", correctAnswer: "questiion2Answer"),
						 Question(question: "question3", correctAnswer: "questiion3Answer")]
		completion(questions, nil)
    }
}
