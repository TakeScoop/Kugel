//
//  Kugel.swift
//  Kugel
//
//  Created by Loïs Di Qual on 7/9/15.
//  Copyright (c) 2015 Scoop, Inc. All rights reserved.
//

import Foundation

public class Kugel {
    
    private static let notificationCenter = NotificationCenter.default
    
    // Publish
    
    public class func publish(_ notification: Notification) {
        notificationCenter.post(notification)
    }
    
    public class func publish(_ name: NSNotification.Name, object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        notificationCenter.post(name: name, object: object, userInfo: userInfo)
    }
    
    // Subscribe
    
    public class func subscribe(_ name: NSNotification.Name, block: ((Notification) -> Void)) -> NSObjectProtocol {
        return notificationCenter.addObserver(forName: name, object: nil, queue: nil) { notification in
            block(notification)
        }
    }
    
    public class func subscribe(_ observer: Any, name: NSNotification.Name, selector: Selector, object: Any? = nil) {
        return notificationCenter.addObserver(observer, selector: selector, name: name, object: object)
    }
    
    public class func subscribe(_ observer: Any, _ notifications: [NSNotification.Name: Selector], object: Any? = nil) {
        for (name, selector) in notifications {
            subscribe(observer, name: name, selector: selector, object: object)
        }
    }
    
    // Unsubscribe
    
    public class func unsubscribe(_ observer: Any, name: NSNotification.Name? = nil, object: Any? = nil) {
        return notificationCenter.removeObserver(observer, name: name, object: nil)
    }
    
    public class func unsubscribe(_ observer: Any, _ names: [NSNotification.Name], object: Any? = nil) {
        for name in names {
            unsubscribe(observer, name: name, object: object)
        }
    }
}

