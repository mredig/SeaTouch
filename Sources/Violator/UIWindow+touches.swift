//
//  File.swift
//  
//
//  Created by Michael Redig on 5/17/20.
//

import UIKit

extension UIWindow {
	public func showTouches() {
		Violator.shared.trackTouches(on: self)
	}

	public func hideTouches() {
		Violator.shared.stopTrackingTouches(on: self)
	}
}
