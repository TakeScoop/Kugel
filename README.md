![](https://www.dropbox.com/s/27fjg3vjugd30fw/kugel_logo.png?raw=1)

**Kugel** - A glorious Swift wrapper around [NSNotificationCenter](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSNotificationCenter_Class/).

Publish
-------

```swift
Kugel.publish("NotificationName")
Kugel.publish("NotificationName", object: anObject)
Kugel.publish("NotificationName", object: anObject, userInfo: ["foo": "bar"])
```

Subscribe
---------

```swift
// Block based
Kugel.subscribe("NotificationName") { notification in
    // Something cool
}

// Selector based - Single 
Kugel.subscribe(self, name: "NotificationName", selector: "onNotificationReceived:")

// Selector based - Multiple
Kugel.subscribe(self, [
    "NotificationName1": "onNotification1Received:",
    "NotificationName2": "onNotification2Received:",
]
```

Unsubscribe
-----------

```swift
// Block based
let token = Kugel.subscribe("NotificationName") { _ in }
Kugel.unsubscribeToken(token)

// Selector based - Single
Kugel.unsubscribe(self, name: "NotificationName")

// Selector based - Multiple
Kugel.unsubscribe(self, [
	"NotificationName1",
	"NotificationName2"
])

// All
Kugel.unsubscribeAll(self)
```

Warning: `Kugel.unsubscribeAll` won't unsubscribe block-based notifications. Use `unsubscribe(token: KugelToken)` for that.

NSObject Extension
------------------

From an instance of an `NSObject` (pretty much all classes from AppKit, UIKit, NSFoundation, etc), you can subscribe/unsubscribe without having to pass an observer.

```swift
// Subscribe - Single
subscribe(name: "NotificationName", selector: "onNotificationReceived:")

// Subscribe - Multiple
subscribe([
	"NotificationName1",
	"NotificationName2"
])

// Unsubscribe - Single
unsubscribe(name: "NotificationName")

// Unsubscribe - Multiple
unsubscribe([
	"NotificationName1",
	"NotificationName2"
])

// Unsubscribe all
unsubscribeAll()
```

License
-------

This project is copyrighted under the MIT license. Complete license can be found here: <https://github.com/TakeScoop/Kugel/blob/master/LICENSE>

Bone icon made by [Freepik](http://www.flaticon.com/authors/freepik) from <http://www.flaticon.com> 
