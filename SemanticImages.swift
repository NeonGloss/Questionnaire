//
//  SemanticImages.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 07.08.2022.
//

import UIKit

/// UIImage provider
final class SemanticImages {

	static var bulletPointActive: UIImage {
		let config = UIImage.SymbolConfiguration(paletteColors: [.blue, .green])
		return UIImage(systemName: "record.circle")?.applyingSymbolConfiguration(config) ?? UIImage()
	}

	static var bulletPointPassive: UIImage {
		let config = UIImage.SymbolConfiguration(paletteColors: [.blue, .green])
		return UIImage(systemName: "circle")?.applyingSymbolConfiguration(config) ?? UIImage()
	}
}
