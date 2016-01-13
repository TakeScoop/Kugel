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
    private var token: AnyObject!
    
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
        Kugel.unsubscribe(self)
        if let token = token {
            Kugel.unsubscribe(token)
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
        Kugel.publish(NotificationName, object: NotificationObject, userInfo: NotificationUserInfo)
        waitForExpectationsWithTimeout(TestTimeout) { _ in }
    }
    
    func testPublishNameUserInfo() {
        expectation = expectationWithDescription("NotificationExceptation")
        Kugel.subscribe(self, name: NotificationName, selector: "onNameUserInfoReceived:")
        Kugel.publish(NotificationName, userInfo: NotificationUserInfo)
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
    
    func testSubscribeNameObjectSelector() {
        expectation = expectationWithDescription("NotificationExceptation")
        Kugel.subscribe(self, name: NotificationName, selector: "onNameObjectReceived:")
        Kugel.publish(NotificationName, object: NotificationObject)
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
    
    func testSubscribeObjectNotifications() {
        expectation1 = expectationWithDescription("NotificationExceptation1")
        expectation2 = expectationWithDescription("NotificationExceptation2")
        Kugel.subscribe(self, [
            NotificationName1: "onNameObject1Received:",
            NotificationName2: "onNameObject2Received:"
        ], object: NotificationObject)
        Kugel.publish(NotificationName1, object: NotificationObject)
        Kugel.publish(NotificationName2, object: NotificationObject)
        waitForExpectationsWithTimeout(TestTimeout) { _ in }
    }
    
    // MARK: - Unsubscribe
    
    func testUnsubscribeToken() {
        expectation = expectationWithDescription("NotificationExceptation")
        token = Kugel.subscribe(NotificationName) { notification in
            XCTAssert(false)
        }
        Kugel.unsubscribe(token)
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
        Kugel.unsubscribe(self)
        Kugel.publish(NotificationName1)
        Kugel.publish(NotificationName2)
        expectation.fulfill()
        waitForExpectationsWithTimeout(TestTimeout) { _ in }
    }
    
    func testUnsubscribeObjectAll() {
        expectation = expectationWithDescription("NotificationExceptation")
        Kugel.subscribe(self, [
            NotificationName1: "onUnexpectedNotificationReceived:",
            NotificationName2: "onUnexpectedNotificationReceived:"
        ], object: NotificationObject)
        Kugel.unsubscribe(self)
        Kugel.publish(NotificationName1, object: NotificationObject)
        Kugel.publish(NotificationName2, object: NotificationObject)
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
        XCTAssertEqual(notification.name, NotificationName)
        expectation.fulfill()
    }
            
    @objc
    private func onName1Received(notification: NSNotification) {
    	XCTAssertEqual(notification.name, NotificationName1)
    	expectation1.fulfill()
    }
            
    @objc
    private func onName2Received(notification: NSNotification) {
    	XCTAssertEqual(notification.name, NotificationName2)
    	expectation2.fulfill()
    }
    
    @objc
    private func onNameObjectReceived(notification: NSNotification) {
        XCTAssertEqual(notification.name, NotificationName)
        XCTAssertEqual(notification.object as? NSObject, NotificationObject)
        XCTAssertNil(notification.userInfo)
        expectation.fulfill()
    }
    
    @objc
    private func onNameObject1Received(notification: NSNotification) {
        XCTAssertEqual(notification.name, NotificationName1)
        XCTAssertEqual(notification.object as? NSObject, NotificationObject)
        expectation1.fulfill()
    }
    
    @objc
    private func onNameObject2Received(notification: NSNotification) {
        XCTAssertEqual(notification.name, NotificationName2)
        XCTAssertEqual(notification.object as? NSObject, NotificationObject)
        expectation2.fulfill()
    }
    
    @objc
    private func onNameObjectUserInfoReceived(notification: NSNotification) {
        XCTAssertEqual(notification.name, NotificationName)
        XCTAssertEqual(notification.object as? NSObject, NotificationObject)
        
        let isUserInfoEqual = NSDictionary(dictionary: notification.userInfo!).isEqualToDictionary(NotificationUserInfo)
        XCTAssertTrue(isUserInfoEqual)
        
        expectation.fulfill()
    }
    
    @objc
    private func onNameUserInfoReceived(notification: NSNotification) {
        XCTAssertEqual(notification.name, NotificationName)
        XCTAssertNil(notification.object)
        
        let isUserInfoEqual = NSDictionary(dictionary: notification.userInfo!).isEqualToDictionary(NotificationUserInfo)
        XCTAssertTrue(isUserInfoEqual)
        
        expectation.fulfill()
    }
    
    @objc func onUnexpectedNotificationReceived(notification: NSNotification) {
        XCTAssert(false)
    }
}
