//
//  Kugel.swift
//  Kugel
//
//  Created by Loïs Di Qual on 7/9/15.
//  Copyright (c) 2015 Scoop, Inc. All rights reserved.
//

import Foundation

public class Kugel {
    
    private static let notificationCenter = NSNotificationCenter.defaultCenter()
    
    // Publish
    
    public class func publish(notification: NSNotification) {
        notificationCenter.postNotification(notification)
    }
    
    public class func publish(name: String, object: AnyObject? = nil, userInfo: [NSObject: AnyObject]? = nil) {
        notificationCenter.postNotificationName(name, object: object, userInfo: userInfo)
    }
    
    // Subscribe
    
    public class func subscribe(name: String, block: (NSNotification -> Void)) -> NSObjectProtocol {
        return notificationCenter.addObserverForName(name, object: nil, queue: nil) { notification in
            block(notification)
        }
    }
    
    public class func subscribe(observer: AnyObject, name: String, selector: Selector, object: AnyObject? = nil) {
        return notificationCenter.addObserver(observer, selector: selector, name: name, object: object)
    }
    
    public class func subscribe(observer: AnyObject, _ notifications: [String: Selector], object: AnyObject? = nil) {
        for (name, selector) in notifications {
            subscribe(observer, name: name, selector: selector, object: object)
        }
    }
    
    // Unsubscribe
    
    public class func unsubscribe(observer: AnyObject, name: String? = nil, object: AnyObject? = nil) {
        return notificationCenter.removeObserver(observer, name: name, object: nil)
    }
    
    public class func unsubscribe(observer: AnyObject, _ names: [String], object: AnyObject? = nil) {
        for name in names {
            unsubscribe(observer, name: name, object: object)
        }
    }
}

