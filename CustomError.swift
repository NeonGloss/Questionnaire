//
//  CustomError.swift
//  Questionnaire
//
//  Created by Roman on 26/05/2023.

import Foundation

/// Custom error wrap over Error
enum CustomError: Error {

	/// custom error with assosiated error text
	case customError(String)
}

extension CustomError: LocalizedError {

	var errorDescription: String? {
		switch self {
		case .customError(let localizedDescription):
			return NSLocalizedString(localizedDescription, comment: "CusomError")
		}
	}
}
