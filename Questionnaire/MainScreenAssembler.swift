//
//  MainScreenAssembler.swift
//  Questionnaire
//
//  Created by Roman on 25/05/2023.
//

import UIKit

/// Assembler for main scene
final class MainScreenAssembler {

	/// Creates scene
	static func create() -> UIViewController {
		let viewModel = MainViewModel(dataProvider: QuestionnaireDataProvider())
		let viewController = MainViewController(viewModel: viewModel)
		viewModel.viewController = viewController
		return viewController
	}
}
