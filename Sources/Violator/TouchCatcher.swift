//
//  File.swift
//  
//
//  Created by Michael Redig on 5/17/20.
//
import UIKit

final class TouchCatcher: UIGestureRecognizer {

	private(set) var allTouches: Set<UITouch> = []

	var touchesUpdated: ((Set<UITouch>) -> Void)?

	override init(target: Any?, action: Selector?) {
		super.init(target: target, action: action)
		commonInit()
	}

	private func commonInit() {
		cancelsTouchesInView = false
		requiresExclusiveTouchType = false
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
		super.touchesBegan(touches, with: event)
		allTouches = allTouches.union(touches)
		touchesUpdated?(allTouches)
		//		state = .began
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
		super.touchesMoved(touches, with: event)
		touchesUpdated?(allTouches)
		//		state = .changed
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
		super.touchesEnded(touches, with: event)
		allTouches = allTouches.subtracting(touches)
		touchesUpdated?(allTouches)
		//		state = .ended
	}
	
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
		super.touchesCancelled(touches, with: event)
		allTouches = allTouches.subtracting(touches)
		touchesUpdated?(allTouches)
		//		state = .cancelled
	}

	override func canBePrevented(by preventingGestureRecognizer: UIGestureRecognizer) -> Bool {
		false
	}
}
