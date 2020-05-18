//
//  File.swift
//  
//
//  Created by Michael Redig on 5/17/20.
//

import UIKit

extension UIWindow {
	/// After running this function, the app's UIWindow layer will draw at the areas of touches at the highest possible layer on screen.
	public func showTouches() {
		TouchDoll.shared.trackTouches(on: self)
	}

	/// After running this function, the app's UIWindow layer will cease drawing at the areas of touches.
	public func hideTouches() {
		TouchDoll.shared.stopTrackingTouches(on: self)
	}
}
