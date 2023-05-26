//
//  Question.swift
//  Questionnaire
//
//  Created by Roman on 25/05/2023.
//

import Foundation

/// Question type
enum QuestionType: Codable {

	/// multiple choice with associated value of variants
	case multipleChoice(_ variants: [MultipleChoiceElement])

	/// question with entering user oun answer with associated value of placeholder for empty ui
	case textFilling(placeHolder: String?)
}

/// Multiple choice element type
enum MultipleChoiceElement: Codable {

	/// Variant for choosing
	case plain(_ text: String)

	/// Variant where user has to put his oun answer
	case textFilling(text: String, placeHolder: String?)
}

/// Question basic model
final class Question: Codable {

	/// Flag, is question mandatory need to be answered
	let isRequired: Bool

	/// Type of question
	let questionType: QuestionType

	/// question text
	var questionText: String

	private(set) var uuid: UUID

	/// Initializer
	/// - Parameters:
	///   - type: type
	///   - question: question text
	///   - isRequired: flag, if question is required
	init(type: QuestionType, question: String, isRequired: Bool, uuid: UUID? = nil) {
		self.uuid = uuid ?? UUID()
		self.isRequired = isRequired
		questionType = type
		questionText = question
	}
}

