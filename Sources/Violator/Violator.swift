import UIKit


class Violator {
	static let shared = Violator()

	private var trackedWindows = [UIWindow: (touches: TouchCatcher, layer: CAShapeLayer)]()
	private var trackedLayers = [TouchCatcher: CAShapeLayer]()
	private var	trackedCatchers = [TouchCatcher: UIWindow]()

	private init() {}

	func trackTouches(on window: UIWindow) {
		guard trackedWindows[window] == nil else { return }
		let catcher = TouchCatcher(target: self, action: #selector(touchesUpdated(_:)))

		window.addGestureRecognizer(catcher)

		let shapeLayer = CAShapeLayer()
		shapeLayer.fillColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
		shapeLayer.strokeColor = UIColor.darkGray.withAlphaComponent(0.8).cgColor
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
			let radius: CGFloat = 25
			let tl = CGPoint(x: $1.x - radius, y: $1.y - radius)
			$0.move(to: tl)
			let rect = CGRect(origin: tl, size: CGSize(width: radius * 2, height: radius * 2))
			$0.addEllipse(in: rect)
		}

		trackedLayers[sender]?.path = path
	}
}
