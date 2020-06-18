//
//  CARippleShapeLayer.swift
//  DemoApp
//
//  Created by Michael Redig on 6/17/20.
//  Copyright © 2020 Red_Egg Productions. All rights reserved.
//

import UIKit

class RippleShapeLayer: CAShapeLayer {

	private var animatingSublayers: Set<CAShapeLayer> = []
	private var	availableSublayers: Set<CAShapeLayer> = []

	func dequeueRippleSublayer() -> CAShapeLayer {
		let layer: CAShapeLayer
		if let available = availableSublayers.first {
			layer = available
		} else {
			layer = CAShapeLayer()
			layer.fillColor = UIColor.clear.cgColor
			layer.strokeColor = UIColor.darkGray.withAlphaComponent(0.8).cgColor
			layer.lineWidth = 8
		}

		addSublayer(layer)
		availableSublayers.remove(layer)
		animatingSublayers.insert(layer)

		return layer
	}
}

extension RippleShapeLayer: CAAnimationDelegate {
	func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
		for layer in animatingSublayers {
			if (layer.animationKeys() ?? []).isEmpty {
				layer.removeFromSuperlayer()
				availableSublayers.insert(layer)
				animatingSublayers.remove(layer)
			}
		}
	}
}
