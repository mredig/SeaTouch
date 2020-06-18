# SeaTouch

Displays where the user is touching on screen with elegant ripples and dots.

![preview](demo.apng)


### Installation:

1. Add the following to your swift packages in Xcode:
	* `https://github.com/mredig/SeaTouch.git`
1. Early in your app lifecycle (eg, `AppDelegate`,  `SceneDelegate`, or even just the first `UIViewController` on screen):
	```swift
	//...
	import SeaTouch
	
	//...
	func someEarlyCalledMethod() {
		//...

		#if DEBUG
		window?.showTouches()
		#endif
	}
	```
1. Magic!
