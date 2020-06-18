import UIKit


class TouchDoll {
	static let shared = TouchDoll()

	private var trackedWindows = [UIWindow: (touches: TouchCatcher, layer: RippleShapeLayer)]()
	private var trackedLayers = [TouchCatcher: RippleShapeLayer]()
	private var trackedCatchers = [TouchCatcher: UIWindow]()

	let radius: CGFloat = 25
	private var circleSize: CGSize {
		CGSize(width: radius * 2, height: radius * 2)
	}

	private init() {}

	/// Initiates touch tracking on a given window, also caching important references to speed up future execution.
	func trackTouches(on window: UIWindow) {
		guard trackedWindows[window] == nil else { return }
		let catcher = TouchCatcher(target: self, action: #selector(touchesUpdated(_:)))

		window.addGestureRecognizer(catcher)

		let shapeLayer = RippleShapeLayer()
		shapeLayer.fillColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
		shapeLayer.strokeColor = UIColor.darkGray.withAlphaComponent(0.8).cgColor
		// would use .greatestFiniteMagnitude, but CoreAnimation complains. Probably not using Double internally?
		shapeLayer.zPosition = CGFloat(Float.greatestFiniteMagnitude)

		window.layer.addSublayer(shapeLayer)

		trackedWindows[window] = (catcher, shapeLayer)
		trackedLayers[catcher] = shapeLayer
		trackedCatchers[catcher] = window
	}

	/// Ceases touch tracking on a given window, releasing previously cached references.
	func stopTrackingTouches(on window: UIWindow) {
		guard let (catcher, shapeLayer) = trackedWindows[window] else { return }

		window.removeGestureRecognizer(catcher)
		shapeLayer.removeFromSuperlayer()

		trackedWindows[window] = nil
		trackedLayers[catcher] = nil
		trackedCatchers[catcher] = nil
	}

	/// This is called by the gesture recognizer when a touch event occurrs. This should not be called directly.
	@objc func touchesUpdated(_ sender: TouchCatcher) {
		let allTouches = sender.allTouches

		guard let window = trackedCatchers[sender] else { return }
		let locations = allTouches.map { $0.location(in: window) }

		let path = locations.reduce(into: CGMutablePath()) {
			let tl = CGPoint(x: $1.x - radius, y: $1.y - radius)
			$0.move(to: tl)
			let rect = CGRect(origin: tl, size: circleSize)
			$0.addEllipse(in: rect)
		}

		for touch in sender.newTouches {
			guard let animLayer = trackedLayers[sender]?.dequeueRippleSublayer() else { continue }

			let path = CGMutablePath()
			let tl = CGPoint(x: 0 - radius, y: 0 - radius)
			path.move(to: tl)
			let rect = CGRect(origin: tl, size: circleSize)
			path.addEllipse(in: rect)
			animLayer.path = path

			let location = touch.location(in: window)
			let locationTransform = CATransform3DMakeTranslation(location.x, location.y, 0)
			let scaleTransform = CATransform3DMakeScale(3, 3, 1)
			let destinationTransform = CATransform3DConcat(scaleTransform, locationTransform)

			animLayer.transform = locationTransform

			let scaleAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
			scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
			scaleAnimation.fromValue = locationTransform
			scaleAnimation.toValue = destinationTransform

			animLayer.opacity = 0
			let fadeAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
			fadeAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
			fadeAnimation.fromValue = 1
			fadeAnimation.toValue = 0
			fadeAnimation.isCumulative = true

			let animations = CAAnimationGroup()
			animations.animations = [scaleAnimation, fadeAnimation]
			animations.duration = 0.6

			animations.delegate = trackedLayers[sender]
			animLayer.add(animations, forKey: "fadeAndScale")
		}


		trackedLayers[sender]?.path = path
	}
}
