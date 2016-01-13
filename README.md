![](https://www.dropbox.com/s/27fjg3vjugd30fw/kugel_logo.png?raw=1)

**Kugel** - A glorious Swift wrapper around [NSNotificationCenter](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSNotificationCenter_Class/).

Install
-------

```
pod 'Kugel'
```

Usage
-----

### Publish

```swift
Kugel.publish("NotificationName")
Kugel.publish("NotificationName", object: anObject)
Kugel.publish("NotificationName", userInfo: ["foo": "bar"])
Kugel.publish("NotificationName", object: anObject, userInfo: ["foo": "bar"])
Kugel.publish(NSNotification(name: "NotificationName"))
```

### Subscribe

```swift
let token = Kugel.subscribe("NotificationName") { notification in }

Kugel.subscribe(self, name: "NotificationName", selector: "onNotificationReceived:")

Kugel.subscribe(self, name: "NotificationName", selector: "onNotificationReceived:", object: object)

Kugel.subscribe(self, [
    "NotificationName1": "onNotification1Received:",
    "NotificationName2": "onNotification2Received:",
])

Kugel.subscribe(self, [
    "NotificationName1": "onNotification1Received:",
    "NotificationName2": "onNotification2Received:",
], object: object)
```

### Unsubscribe

```swift
Kugel.unsubscribe(token)

Kugel.unsubscribe(self, name: "NotificationName")

Kugel.unsubscribe(self, name: "NotificationName", object: object)

Kugel.unsubscribe(self, [
	"NotificationName1",
	"NotificationName2"
])

Kugel.unsubscribe(self, [
	"NotificationName1",
	"NotificationName2"
], object: object)

Kugel.unsubscribe(self)
```

License
-------

This project is copyrighted under the MIT license. Complete license can be found here: <https://github.com/TakeScoop/Kugel/blob/master/LICENSE>

Bone icon made by [Freepik](http://www.flaticon.com/authors/freepik) from <http://www.flaticon.com> 
