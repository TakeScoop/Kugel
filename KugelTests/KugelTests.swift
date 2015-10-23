//
//  KugelTests.swift
//  KugelTests
//
//  Created by Loïs Di Qual on 7/9/15.
//  Copyright (c) 2015 Scoop, Inc. All rights reserved.
//

import UIKit
import XCTest

class KugelTests: XCTestCase {
    
    private var expectation:  XCTestExpectation!
    private var expectation1: XCTestExpectation!
    private var expectation2: XCTestExpectation!
    private var token: KugelToken!
    
    private let TestTimeout: NSTimeInterval = 1
    
    private let NotificationName     = "TestNotifification"
    private let NotificationObject   = NSObject()
    private let NotificationUserInfo = [NSObject: AnyObject]()
    private var testNotification: NSNotification!
    
    private let NotificationName1 = "NotificationName1"
    private let NotificationName2 = "NotificationName2"
    
    override func setUp() {
        testNotification = NSNotification(name: NotificationName, object: NotificationObject)
    }
    
    override func tearDown() {
        Kugel.unsubscribeAll(self)
        if let token = token {
            Kugel.unsubscribeToken(token)
        }
    }
    
    // MARK: - Publish

    func testPublishNotification() {
        expectation = expectationWithDescription("NotificationExceptation")
        Kugel.subscribe(self, name: NotificationName, selector: "onTestNotificationReceived:")
        Kugel.publish(testNotification)
        waitForExpectationsWithTimeout(TestTimeout) { _ in }
    }
    
    func testPublishName() {
        expectation = expectationWithDescription("NotificationExceptation")
        Kugel.subscribe(self, name: NotificationName, selector: "onNameReceived:")
        Kugel.publish(NotificationName)
        waitForExpectationsWithTimeout(TestTimeout) { _ in }
    }
    
    func testPublishNameObject() {
        expectation = expectationWithDescription("NotificationExceptation")
        Kugel.subscribe(self, name: NotificationName, selector: "onNameObjectReceived:")
        Kugel.publish(NotificationName, object: NotificationObject)
        waitForExpectationsWithTimeout(TestTimeout) { _ in }
    }
    
    func testPublishNameUserInfoObject() {
        expectation = expectationWithDescription("NotificationExceptation")
        Kugel.subscribe(self, name: NotificationName, selector: "onNameObjectUserInfoReceived:")
        Kugel.publish(NotificationName, object: NotificationObject, userInfo: NotificationUserInfo as [NSObject : AnyObject])
        waitForExpectationsWithTimeout(TestTimeout) { _ in }
    }
    
    // MARK: - Subscribe
    
    func testSubscribeNameBlock() {
        expectation = expectationWithDescription("NotificationExceptation")
        token = Kugel.subscribe(NotificationName) { notification in
            XCTAssert(notification.name == self.NotificationName)
            self.expectation.fulfill()
        }
        Kugel.publish(NotificationName)
        waitForExpectationsWithTimeout(TestTimeout) { _ in }
    }
    
    func testSubscribeNameSelector() {
        expectation = expectationWithDescription("NotificationExceptation")
        Kugel.subscribe(self, name: NotificationName, selector: "onNameReceived:")
        Kugel.publish(NotificationName)
        waitForExpectationsWithTimeout(TestTimeout) { _ in }
    }
    
    func testSubscribeNotifications() {
        expectation1 = expectationWithDescription("NotificationExceptation1")
        expectation2 = expectationWithDescription("NotificationExceptation2")
        Kugel.subscribe(self, [
            NotificationName1: "onName1Received:",
            NotificationName2: "onName2Received:"
        ])
        Kugel.publish(NotificationName1)
        Kugel.publish(NotificationName2)
        waitForExpectationsWithTimeout(TestTimeout) { _ in }
    }
    
    // MARK: - Unsubscribe
    
    func testUnsubscribeToken() {
        expectation = expectationWithDescription("NotificationExceptation")
        token = Kugel.subscribe(NotificationName) { notification in
            XCTAssert(false)
        }
        Kugel.unsubscribeToken(token)
        Kugel.publish(NotificationName)
        expectation.fulfill()
        waitForExpectationsWithTimeout(TestTimeout) { _ in }
    }
    
    func testUnsubscribeName() {
        expectation = expectationWithDescription("NotificationExceptation")
        Kugel.subscribe(self, name: NotificationName, selector: "onUnexpectedNotificationReceived:")
        Kugel.unsubscribe(self, name: NotificationName)
        Kugel.publish(NotificationName)
        expectation.fulfill()
        waitForExpectationsWithTimeout(TestTimeout) { _ in }
    }
    
    func testUnsubscribeNames() {
        expectation = expectationWithDescription("NotificationExceptation")
        Kugel.subscribe(self, [
            NotificationName1: "onUnexpectedNotificationReceived:",
            NotificationName2: "onUnexpectedNotificationReceived:"
        ])
        Kugel.unsubscribe(self, [
            NotificationName1,
            NotificationName2
        ])
        Kugel.publish(NotificationName1)
        Kugel.publish(NotificationName2)
        expectation.fulfill()
        waitForExpectationsWithTimeout(TestTimeout) { _ in }
    }
    
    func testUnsubscribeAll() {
        expectation = expectationWithDescription("NotificationExceptation")
        Kugel.subscribe(self, [
            NotificationName1: "onUnexpectedNotificationReceived:",
            NotificationName2: "onUnexpectedNotificationReceived:"
        ])
        Kugel.unsubscribeAll(self)
        Kugel.publish(NotificationName1)
        Kugel.publish(NotificationName2)
        expectation.fulfill()
        waitForExpectationsWithTimeout(TestTimeout) { _ in }
    }
    
    // MARK: - Listeners
    
    @objc
    private func onTestNotificationReceived(notification: NSNotification) {
        XCTAssert(notification == testNotification)
        expectation.fulfill()
    }
    
    @objc
    private func onNameReceived(notification: NSNotification) {
        XCTAssert(notification.name == NotificationName)
        expectation.fulfill()
    }
            
    @objc
    private func onName1Received(notification: NSNotification) {
    	XCTAssert(notification.name == NotificationName1)
    	expectation1.fulfill()
    }
            
    @objc
    private func onName2Received(notification: NSNotification) {
    	XCTAssert(notification.name == NotificationName2)
    	expectation2.fulfill()
    }
    
    @objc
    private func onNameObjectReceived(notification: NSNotification) {
        XCTAssert(notification.name   == NotificationName)
        XCTAssert(notification.object as! NSObject == NotificationObject)
        expectation.fulfill()
    }
    
    @objc
    private func onNameObjectUserInfoReceived(notification: NSNotification) {
        XCTAssert(notification.name   == NotificationName)
        XCTAssert(notification.object as! NSObject === NotificationObject)
        expectation.fulfill()
    }
    
    @objc func onUnexpectedNotificationReceived(notification: NSNotification) {
        XCTAssert(false)
    }
}
