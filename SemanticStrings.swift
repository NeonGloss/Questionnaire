//
//  SemanticStrings.swift
//  Questionnaire
//
//  Created by Roman on 26/05/2023.
//

/// Strings provider
final class SemanticStrings {

	static let submit: String = "Submit"
	static let submittedSuccessfully: String = "Submitted successfully"

	enum Errors {
		static let answerRequiredQuestions: String = "Not all required answers are answered"
		static let questionsUnreacheble: String = "Server is unreacheble\n(try to check it😉)\nAdding default questions"
		static let answersUnsaved: String = "Could not save answers"
		static let serverUnavailable: String = "Could not reach a server"
	}
}
