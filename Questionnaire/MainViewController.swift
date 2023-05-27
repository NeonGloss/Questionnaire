//
//  MainViewController.swift
//  Questionnaire
//
//  Created by Roman on 25/05/2023.
//

import UIKit

/// Main view controller Protocol
protocol MainViewControllerProtocol {

	/// Set UI data model
	/// - Parameter items: items
	func setUIData(_ items: [RKTableViewCellProtocol])

	/// Display an alert with text
	/// - Parameter text: text
	func displayAlertWith(text: String)
}

/// Main view controller
final class MainViewController: UIViewController, MainViewControllerProtocol {

	private let viewModel: MainViewModelProtocol

	private lazy var submitButton: UIButton = {
		let button = UIButton()
		button.backgroundColor = Constants.Design.Colors.nuance0
		button.setTitle(SemanticStrings.submit, for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.layer.cornerRadius = 5
		button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
		return button
	}()

	private lazy var table = {
		RKTableView(settings: RKTableViewSettings())
	}()

	private enum Sizes {
		static let topToTableIndent: CGFloat = 0
		static let submitButtonWidth: CGFloat = 100
		static let submitButtonHeight: CGFloat = 30
	}

	/// Initializer
	/// - Parameter viewModel: view model
	init(viewModel: MainViewModelProtocol) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		setupUI()
		setupConstraints()
		viewModel.viewDidLoad()
    }

	// MARK: - MainViewControllerProtocol
    
	func setUIData(_ items: [RKTableViewCellProtocol]) {
		table.items = items
		table.reloadData()
	}

	func displayAlertWith(text: String) {
		let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default))
		self.present(alert, animated: true, completion: nil)
	}

	// MARK: - Private

	private func setupUI() {
		view.backgroundColor = Constants.Design.Colors.background
		table.separatorStyle = .none
	}

	private func setupConstraints() {
		view.addSubview(table)
		view.addSubview(submitButton)
		view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

		NSLayoutConstraint.activate([
			table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Sizes.topToTableIndent),
			table.bottomAnchor.constraint(equalTo: submitButton.topAnchor, constant: -Constants.Design.Sizes.verticalSmallIndent),

			submitButton.widthAnchor.constraint(equalToConstant: Sizes.submitButtonWidth),
			submitButton.heightAnchor.constraint(equalToConstant: Sizes.submitButtonHeight),
			submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Design.Sizes.verticalBigIndent),
			submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.Design.Sizes.verticalSmallIndent),
		])
	}

	@objc private func submitButtonTapped() {
		viewModel.submitButtonTapped()
	}
}
