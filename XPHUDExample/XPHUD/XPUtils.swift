//
//  XPUtils.swift
//  XPToastExample
//
//  Created by xp on 2018/5/25.
//  Copyright © 2018年 worldunion. All rights reserved.
//


import UIKit

protocol XPDisposable: class {
    
    var disposed: Bool { get }
    
    func dispose()
}

private class XPInnerDisposable: XPDisposable {
    
    var disposed: Bool = false
    
    func dispose() {
        disposed = true
    }
}

@discardableResult
func delayerOnMain(delay: TimeInterval, action: @escaping () -> Void) -> XPDisposable {
    return delayer(delay: delay, queue: DispatchQueue.main, action: action)
}

@discardableResult
func delayer(delay: TimeInterval, queue: DispatchQueue, action: @escaping () -> Void) -> XPDisposable {
    precondition(delay >= 0)
    
    let disposable = XPInnerDisposable()
    
    queue.asyncAfter(wallDeadline: wallTimeWithDate(date: NSDate().addingTimeInterval(delay))) {
        if !disposable.disposed {
            action()
        }
    }
    return disposable
}

private func wallTimeWithDate(date: NSDate) -> DispatchWallTime {
    
    let (seconds, frac) = modf(date.timeIntervalSince1970)
    
    let nsec: Double = frac * Double(NSEC_PER_SEC)
    let walltime = timespec(tv_sec: Int(seconds), tv_nsec: Int(nsec))
    return DispatchWallTime.init(timespec: walltime)
}

