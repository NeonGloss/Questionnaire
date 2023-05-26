//
//  Answer.swift
//  Questionnaire
//
//  Created by Roman on 26/05/2023.
//

import Foundation

/// Struct for answer received from user
struct Answer: Codable {

	/// question UUID
	let questionUUID: UUID

	/// answer text
	var answer: String
}
