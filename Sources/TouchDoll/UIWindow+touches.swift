//
//  File.swift
//  
//
//  Created by Michael Redig on 5/17/20.
//

import UIKit

extension UIWindow {
	public func showTouches() {
		TouchDoll.shared.trackTouches(on: self)
	}

	public func hideTouches() {
		TouchDoll.shared.stopTrackingTouches(on: self)
	}
}
