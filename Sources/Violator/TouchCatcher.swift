//
//  File.swift
//  
//
//  Created by Michael Redig on 5/17/20.
//
import UIKit


/// This recognizer is configured to detect and forward *every* touch, but also passes through to any following recognizers/touch input.
final class TouchCatcher: UIGestureRecognizer {

	private(set) var allTouches: Set<UITouch> = []

	override init(target: Any?, action: Selector?) {
		super.init(target: target, action: action)
		commonInit()
	}

	private func commonInit() {
		cancelsTouchesInView = false
		requiresExclusiveTouchType = false
		delegate = self
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
		super.touchesBegan(touches, with: event)
		allTouches = allTouches.union(touches)
		state = .began
	}

	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
		super.touchesMoved(touches, with: event)
		state = .changed
	}

	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
		super.touchesEnded(touches, with: event)
		allTouches = allTouches.subtracting(touches)
		state = .ended
	}

	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
		super.touchesCancelled(touches, with: event)
		allTouches = allTouches.subtracting(touches)
		state = .cancelled
	}

	override func canBePrevented(by preventingGestureRecognizer: UIGestureRecognizer) -> Bool {
		false
	}
}

extension TouchCatcher: UIGestureRecognizerDelegate {
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		true
	}
}
