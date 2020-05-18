import UIKit


class TouchTracker {
	static let shared = TouchTracker()

	private var trackedWindows = [UIWindow: (touches: TouchCatcher, layer: CAShapeLayer)]()
	private var trackedLayers = [TouchCatcher: CAShapeLayer]()
	private var	trackedCatchers = [TouchCatcher: UIWindow]()

	private init() {}

	func trackTouches(on window: UIWindow) {
		guard trackedWindows[window] == nil else { return }
		let catcher = TouchCatcher(target: self, action: #selector(touchesUpdated(_:)))

		window.addGestureRecognizer(catcher)

		let shapeLayer = CAShapeLayer()
		shapeLayer.fillColor = UIColor.lightGray.cgColor
		shapeLayer.strokeColor = UIColor.darkGray.cgColor
		shapeLayer.zPosition = .greatestFiniteMagnitude

		window.layer.addSublayer(shapeLayer)

		trackedWindows[window] = (catcher, shapeLayer)
		trackedLayers[catcher] = shapeLayer
		trackedCatchers[catcher] = window
	}

	func stopTrackingTouches(on window: UIWindow) {
		guard let (catcher, shapeLayer) = trackedWindows[window] else { return }

		window.removeGestureRecognizer(catcher)
		shapeLayer.removeFromSuperlayer()

		trackedWindows[window] = nil
		trackedLayers[catcher] = nil
		trackedCatchers[catcher] = nil
	}

	@objc func touchesUpdated(_ sender: TouchCatcher) {
		let allTouches = sender.allTouches

		guard let window = trackedCatchers[sender] else { return }
		let locations = allTouches.map { $0.location(in: window) }

		let path = locations.reduce(into: CGMutablePath()) {
			$0.addArc(center: $1, radius: 40, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
		}

		trackedLayers[sender]?.path = path
	}

}

extension UIWindow {
	public func showTouches() {
		TouchTracker.shared.trackTouches(on: self)
	}
}
