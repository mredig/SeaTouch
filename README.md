# TouchDoll

Shows you where on the screen it's being touched.


### Installation:

1. Add the following to your swift packages in Xcode:
	* `https://github.com/mredig/TouchDoll.git`
1. In your AppDelegate:
	```swift
	//...
	import TouchDoll
	
	//...
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		window?.showTouches()
		return true
	}
	```
1. Magic!
