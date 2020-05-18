# TouchDoll

Shows you where on the screen it's being touched.

![preview](demo.apng)


### Installation:

1. Add the following to your swift packages in Xcode:
	* `https://github.com/mredig/TouchDoll.git`
1. Early in your app lifecycle (eg, `AppDelegate`,  `SceneDelegate`, or even just the first `UIViewController` on screen):
	```swift
	//...
	import TouchDoll
	
	//...
	func someEarlyCalledMethod() {
		//...

		#if DEBUG
		window?.showTouches()
		#endif
	}
	```
1. Magic!
