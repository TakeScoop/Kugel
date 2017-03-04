Kugel
=====

![Tests](https://img.shields.io/circleci/project/TakeScoop/Kugel/master.svg)
![Platforms](https://img.shields.io/badge/platforms-ios%20%7C%20osx%20%20%7C%20tvos-lightgrey.svg)
![Languages](https://img.shields.io/badge/languages-swift%20%7C%20objc-orange.svg)
![CocoaPods](https://img.shields.io/cocoapods/v/Kugel.svg)

A glorious Swift wrapper around [NSNotificationCenter](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSNotificationCenter_Class/).

⚠️ Deprecated ⚠️
----------------

**This library is deprecated and will not be maintained anymore.**

With Swift 3, working with `NotificationCenter` is more concise so we recommend using `NotificationCenter.default` directly.

The only feature that `Kugel` had over using `NotificationCenter` was to subscribe to multiple events at once using a `notification name => selector` map, but this can be easily implemented in your own code using the following extension:

```
extension NotificationCenter {
    func addObserver(_ observer: Any, _ namesAndSelectors: [NSNotification.Name: Selector], object: Any? = nil) {
        for (name, selector) in namesAndSelectors {
            addObserver(observer, selector: selector, name: name, object: object)
        }
    }
    func removeObserver(_ observer: Any, names: [NSNotification.Name], object: Any? = nil) {
        for name in names {
            removeObserver(observer, name: name, object: object)
        }
    }
}
```

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
