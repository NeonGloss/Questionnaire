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
	private lazy var table = {
		RKTableView(settings: RKTableViewSettings())
	}()

	private enum Sizes {
		static let topToTableIndent: CGFloat = 30
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
		view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

		NSLayoutConstraint.activate([
			table.topAnchor.constraint(equalTo: view.topAnchor, constant: Sizes.topToTableIndent),
			table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}
}
