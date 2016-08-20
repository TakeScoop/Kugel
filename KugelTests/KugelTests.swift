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
    
    private let TestTimeout: TimeInterval = 1
    
    private let NotificationName     = Notification.Name(rawValue: "TestNotification")
    private let NotificationObject   = NSObject()
    private let NotificationUserInfo = [NSObject: AnyObject]()
    private var testNotification: Notification!
    
    private let NotificationName1 = Notification.Name(rawValue: "NotificationName1")
    private let NotificationName2 = Notification.Name(rawValue: "NotificationName2")
    
    override func setUp() {
        testNotification = Notification(name: NotificationName, object: NotificationObject)
    }
    
    override func tearDown() {
        Kugel.unsubscribe(self)
        if let token = token {
            Kugel.unsubscribe(token)
        }
    }
    
    // MARK: - Publish

    func testPublishNotification() {
        expectation = self.expectation(description: "NotificationExceptation")
        Kugel.subscribe(self, name: NotificationName, selector: #selector(onTestNotificationReceived))
        Kugel.publish(testNotification)
        waitForExpectations(timeout: TestTimeout) { _ in }
    }
    
    func testPublishName() {
        expectation = self.expectation(description: "NotificationExceptation")
        Kugel.subscribe(self, name: NotificationName, selector: #selector(onNameReceived))
        Kugel.publish(NotificationName)
        waitForExpectations(timeout: TestTimeout) { _ in }
    }
    
    func testPublishNameObject() {
        expectation = self.expectation(description: "NotificationExceptation")
        Kugel.subscribe(self, name: NotificationName, selector: #selector(onNameObjectReceived))
        Kugel.publish(NotificationName, object: NotificationObject)
        waitForExpectations(timeout: TestTimeout) { _ in }
    }
    
    func testPublishNameUserInfoObject() {
        expectation = self.expectation(description: "NotificationExceptation")
        Kugel.subscribe(self, name: NotificationName, selector: #selector(onNameObjectUserInfoReceived))
        Kugel.publish(NotificationName, object: NotificationObject, userInfo: NotificationUserInfo)
        waitForExpectations(timeout: TestTimeout) { _ in }
    }
    
    func testPublishNameUserInfo() {
        expectation = self.expectation(description: "NotificationExceptation")
        Kugel.subscribe(self, name: NotificationName, selector: #selector(onNameUserInfoReceived))
        Kugel.publish(NotificationName, userInfo: NotificationUserInfo)
        waitForExpectations(timeout: TestTimeout) { _ in }
    }
    
    // MARK: - Subscribe
    
    func testSubscribeNameBlock() {
        expectation = self.expectation(description: "NotificationExceptation")
        token = Kugel.subscribe(NotificationName) { notification in
            XCTAssert(notification.name == self.NotificationName)
            self.expectation.fulfill()
        }
        Kugel.publish(NotificationName)
        waitForExpectations(timeout: TestTimeout) { _ in }
    }
    
    func testSubscribeNameSelector() {
        expectation = self.expectation(description: "NotificationExceptation")
        Kugel.subscribe(self, name: NotificationName, selector: #selector(onNameReceived))
        Kugel.publish(NotificationName)
        waitForExpectations(timeout: TestTimeout) { _ in }
    }
    
    func testSubscribeNameObjectSelector() {
        expectation = self.expectation(description: "NotificationExceptation")
        Kugel.subscribe(self, name: NotificationName, selector: #selector(onNameObjectReceived))
        Kugel.publish(NotificationName, object: NotificationObject)
        waitForExpectations(timeout: TestTimeout) { _ in }
    }
    
    func testSubscribeNotifications() {
        expectation1 = self.expectation(description: "NotificationExceptation1")
        expectation2 = self.expectation(description: "NotificationExceptation2")
        Kugel.subscribe(self, [
            NotificationName1: #selector(onName1Received),
            NotificationName2: #selector(onName2Received)
        ])
        Kugel.publish(NotificationName1)
        Kugel.publish(NotificationName2)
        waitForExpectations(timeout: TestTimeout) { _ in }
    }
    
    func testSubscribeObjectNotifications() {
        expectation1 = self.expectation(description: "NotificationExceptation1")
        expectation2 = self.expectation(description: "NotificationExceptation2")
        Kugel.subscribe(self, [
            NotificationName1: #selector(onNameObject1Received),
            NotificationName2: #selector(onNameObject2Received)
        ], object: NotificationObject)
        Kugel.publish(NotificationName1, object: NotificationObject)
        Kugel.publish(NotificationName2, object: NotificationObject)
        waitForExpectations(timeout: TestTimeout) { _ in }
    }
    
    // MARK: - Unsubscribe
    
    func testUnsubscribeToken() {
        expectation = self.expectation(description: "NotificationExceptation")
        token = Kugel.subscribe(NotificationName) { notification in
            XCTAssert(false)
        }
        Kugel.unsubscribe(token)
        Kugel.publish(NotificationName)
        expectation.fulfill()
        waitForExpectations(timeout: TestTimeout) { _ in }
    }
    
    func testUnsubscribeName() {
        expectation = self.expectation(description: "NotificationExceptation")
        Kugel.subscribe(self, name: NotificationName, selector: #selector(onUnexpectedNotificationReceived))
        Kugel.unsubscribe(self, name: NotificationName)
        Kugel.publish(NotificationName)
        expectation.fulfill()
        waitForExpectations(timeout: TestTimeout) { _ in }
    }
    
    func testUnsubscribeNames() {
        expectation = self.expectation(description: "NotificationExceptation")
        Kugel.subscribe(self, [
            NotificationName1: #selector(onUnexpectedNotificationReceived),
            NotificationName2: #selector(onUnexpectedNotificationReceived)
        ])
        Kugel.unsubscribe(self, [
            NotificationName1,
            NotificationName2
        ])
        Kugel.publish(NotificationName1)
        Kugel.publish(NotificationName2)
        expectation.fulfill()
        waitForExpectations(timeout: TestTimeout) { _ in }
    }
    
    func testUnsubscribeAll() {
        expectation = self.expectation(description: "NotificationExceptation")
        Kugel.subscribe(self, [
            NotificationName1: #selector(onUnexpectedNotificationReceived),
            NotificationName2: #selector(onUnexpectedNotificationReceived)
        ])
        Kugel.unsubscribe(self)
        Kugel.publish(NotificationName1)
        Kugel.publish(NotificationName2)
        expectation.fulfill()
        waitForExpectations(timeout: TestTimeout) { _ in }
    }
    
    func testUnsubscribeObjectAll() {
        expectation = self.expectation(description: "NotificationExceptation")
        Kugel.subscribe(self, [
            NotificationName1: #selector(onUnexpectedNotificationReceived),
            NotificationName2: #selector(onUnexpectedNotificationReceived)
        ], object: NotificationObject)
        Kugel.unsubscribe(self)
        Kugel.publish(NotificationName1, object: NotificationObject)
        Kugel.publish(NotificationName2, object: NotificationObject)
        expectation.fulfill()
        waitForExpectations(timeout: TestTimeout) { _ in }
    }
    
    // MARK: - Listeners
    
    @objc
    private func onTestNotificationReceived(_ notification: Notification) {
        XCTAssert(notification == testNotification)
        expectation.fulfill()
    }
    
    @objc
    private func onNameReceived(_ notification: Notification) {
        XCTAssertEqual(notification.name, NotificationName)
        expectation.fulfill()
    }
            
    @objc
    private func onName1Received(_ notification: Notification) {
    	XCTAssertEqual(notification.name, NotificationName1)
    	expectation1.fulfill()
    }
            
    @objc
    private func onName2Received(_ notification: Notification) {
    	XCTAssertEqual(notification.name, NotificationName2)
    	expectation2.fulfill()
    }
    
    @objc
    private func onNameObjectReceived(_ notification: Notification) {
        XCTAssertEqual(notification.name, NotificationName)
        XCTAssertEqual(notification.object as? NSObject, NotificationObject)
        XCTAssertNil((notification as NSNotification).userInfo)
        expectation.fulfill()
    }
    
    @objc
    private func onNameObject1Received(_ notification: Notification) {
        XCTAssertEqual(notification.name, NotificationName1)
        XCTAssertEqual(notification.object as? NSObject, NotificationObject)
        expectation1.fulfill()
    }
    
    @objc
    private func onNameObject2Received(_ notification: Notification) {
        XCTAssertEqual(notification.name, NotificationName2)
        XCTAssertEqual(notification.object as? NSObject, NotificationObject)
        expectation2.fulfill()
    }
    
    @objc
    private func onNameObjectUserInfoReceived(_ notification: Notification) {
        XCTAssertEqual(notification.name, NotificationName)
        XCTAssertEqual(notification.object as? NSObject, NotificationObject)
        
        let isUserInfoEqual = NSDictionary(dictionary: (notification as NSNotification).userInfo!).isEqual(to: NotificationUserInfo)
        XCTAssertTrue(isUserInfoEqual)
        
        expectation.fulfill()
    }
    
    @objc
    private func onNameUserInfoReceived(_ notification: Notification) {
        XCTAssertEqual(notification.name, NotificationName)
        XCTAssertNil(notification.object)
        
        let isUserInfoEqual = NSDictionary(dictionary: (notification as NSNotification).userInfo!).isEqual(to: NotificationUserInfo)
        XCTAssertTrue(isUserInfoEqual)
        
        expectation.fulfill()
    }
    
    @objc func onUnexpectedNotificationReceived(_ notification: Notification) {
        XCTAssert(false)
    }
}
