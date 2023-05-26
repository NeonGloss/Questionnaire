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
	func fetchQuestions(completion: @escaping ([Question], Error?) -> Void)
}

/// Questionnaire data provider
final class QuestionnaireDataProvider: QuestionnaireDataProviderProtocol {
    
    func fetchQuestions(completion: @escaping ([Question], Error?) -> Void) {
		let questions = [Question(type: QuestionType.multipleChoice([.plain("Kotlin"),
																	 .plain("Java"),
																	 .plain("C++")]),
								  question: "What language is your favorite?",
								  isRequired: false),
						 Question(type: .textFilling(placeHolder: "Your answer"),
								  question: "What do you like about programming? added many words to see if everything is ok", isRequired: false),
						 Question(type: .multipleChoice([.plain("Easy"),
														 .plain("Normal"),
														 .plain("Hard"),
														 .textFilling(text: "Other", placeHolder: nil)]),
								  question: "How was the assignment?",
								  isRequired: true)]
		let encodeer = JSONEncoder()
		encodeer.outputFormatting = .prettyPrinted
		let encodedData = try? encodeer.encode(questions)
		print(String(data: encodedData!, encoding: .utf8)!)

		completion(questions, nil)
    }
}
