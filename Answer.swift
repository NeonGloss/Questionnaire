//
//  Answer.swift
//  Questionnaire
//
//  Created by Roman on 26/05/2023.
//

import Foundation

/// Struct for answer received from user
final class Answer: Codable {

	/// question UUID
	let questionUUID: UUID

	/// answer text
	var answer: String

	/// Initializer
	/// - Parameters:
	///   - questionUUID: uuid
	///   - answer: answer text
	init(questionUUID: UUID, answer: String) {
		self.questionUUID = questionUUID
		self.answer = answer
	}
}
