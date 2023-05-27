//
//  TopCornerRoundedUIView.swift
//  Questionnaire
//
//  Created by Roman on 27/05/2023.
//

import UIKit

/// UILabel with top corners rounded
final class TopCornerRoundedUIView: UILabel {

	/// Radius for tor corners
	var radius: Int = 0

	override func draw(_ rect: CGRect) {
		let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: radius, height: radius))

		let maskLayer = CAShapeLayer()
		maskLayer.frame = self.bounds
		maskLayer.path = path.cgPath
		self.layer.mask = maskLayer

		self.backgroundColor?.setFill()
		path.fill()
		path.stroke()
	}
}
