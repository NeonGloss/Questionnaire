//
//  Question.swift
//  Questionnaire
//
//  Created by Roman on 25/05/2023.
//

/// Question basic model
final class Question {

	/// question text
	var question: String

	/// questions correct answer
	var correctAnswer: String

	init(question: String, correctAnswer: String) {
		self.question = question
		self.correctAnswer = correctAnswer
	}
}
