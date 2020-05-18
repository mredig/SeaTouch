import UIKit
import XCTest
@testable import TouchDoll

final class TouchDollTests: XCTestCase {
	func testWindowExtension() {
		let window = UIWindow()

		window.gestureRecognizers?.forEach {
			let theType = type(of: $0)
			XCTAssertFalse(TouchCatcher.self == theType)
		}

		XCTAssertEqual(window.layer.sublayers, nil)

		window.showTouches()

		let hasCatcher = window.gestureRecognizers?.contains(where: { TouchCatcher.self == type(of: $0) })
		XCTAssertTrue(hasCatcher == true)

		let hasShapeLayer = window.layer.sublayers?.contains(where: { CAShapeLayer.self == type(of: $0) })
		XCTAssertTrue(hasShapeLayer == true)
		XCTAssertEqual(window.layer.sublayers?.count, 1)

		window.hideTouches()

		window.gestureRecognizers?.forEach {
			let theType = type(of: $0)
			XCTAssertFalse(TouchCatcher.self == theType)
		}

		XCTAssertEqual(window.layer.sublayers, nil)
	}

	static var allTests = [
		("testWindowExtension", testWindowExtension),
	]
}
