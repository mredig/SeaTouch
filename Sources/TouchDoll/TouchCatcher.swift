//
//  File.swift
//  
//
//  Created by Michael Redig on 5/17/20.
//
import UIKit


/// This recognizer is configured to detect and forward *every* touch, but also passes through to any following recognizers/touch input.
final class TouchCatcher: UIGestureRecognizer {

	/// Keeps track of all touches throughout their lifetime
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
		if allTouches.isEmpty {
			state = .ended
		} else {
			state = .changed
		}
	}

	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
		super.touchesCancelled(touches, with: event)
		allTouches = allTouches.subtracting(touches)
		if allTouches.isEmpty {
			state = .cancelled
		} else {
			state = .changed
		}
	}

	/// Nothing should prevent this gesture recognizer from activating for as long as it's enabled.
	override func canBePrevented(by preventingGestureRecognizer: UIGestureRecognizer) -> Bool {
		false
	}
}

extension TouchCatcher: UIGestureRecognizerDelegate {
	/// No touch events should be consumed by this gesture recognizer alone.
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		true
	}
}
