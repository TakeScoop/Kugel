Kugel Changelog
===============

## [Unreleased (master)][master]

### Breaking

 * Removed `Kugel.unsubscribeAll()`, `Kugel.unsubscribeToken()`. Use `Kugel.unsubscribe()` instead.
 * Removed `KugelToken` (which was an alias of `NSObjectProtocol`)

### Other changes

 * Added ability to publish a notification with `userInfo` but no `object`.
   [#2](https://github.com/TakeScoop/Kugel/pull/2)
 * Added ability to subscribe to a notification with a specific `object`.
   [#2](https://github.com/TakeScoop/Kugel/pull/2)

## [0.1.0]

Initial public release.

[master]: https://github.com/TakeScoop/scoop-ios/compare/0.1.0...master
[0.1.0]: https://github.com/TakeScoop/Kugel/releases/tag/0.1.0