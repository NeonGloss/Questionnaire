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
}

/// Main view controller
final class MainViewController: UIViewController, MainViewControllerProtocol {

	private let viewModel: MainViewModelProtocol

	private lazy var submitButton: UIButton = {
		let button = UIButton()
		button.backgroundColor = .white
		button.layer.borderColor = UIColor.black.cgColor
		button.setTitle(SemanticStrings.submit, for: .normal)
		button.setTitleColor(.black, for: .normal)
		button.layer.borderWidth = 1
		button.layer.cornerRadius = 10
		button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
		return button
	}()

	private lazy var table = {
		RKTableView(settings: RKTableViewSettings())
	}()

	private enum Sizes {
		static let topToTableIndent: CGFloat = 30
		static let submitButtonWidth: CGFloat = 100
		static let submitButtonToLeft: CGFloat = 20
		static let submitButtonHeight: CGFloat = 30
		static let tableToSubmitButton: CGFloat = 20
		static let submitButtonToBottom: CGFloat = 40
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

	// MARK: - Private

	private func setupUI() {
		view.backgroundColor = .systemMint
		table.separatorStyle = .singleLine
	}

	private func setupConstraints() {
		view.addSubview(table)
		view.addSubview(submitButton)
		view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

		NSLayoutConstraint.activate([
			table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			table.topAnchor.constraint(equalTo: view.topAnchor, constant: Sizes.topToTableIndent),
			table.bottomAnchor.constraint(equalTo: submitButton.topAnchor, constant: -Sizes.tableToSubmitButton),

			submitButton.widthAnchor.constraint(equalToConstant: Sizes.submitButtonWidth),
			submitButton.heightAnchor.constraint(equalToConstant: Sizes.submitButtonHeight),
			submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Sizes.submitButtonToLeft),
			submitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Sizes.submitButtonToBottom),
		])
	}

	@objc private func submitButtonTapped() {
		viewModel.submitButtonTapped()
	}
}
