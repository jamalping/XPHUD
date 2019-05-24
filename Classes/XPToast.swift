//
//  XPToast.swift
//  XPToastExample
//
//  Created by xp on 2018/5/25.
//  Copyright © 2018年 worldunion. All rights reserved.
//

import UIKit

/// 提示框，一般用于提醒，显示几秒就消失
final public class XPToast {
    /// 单例对象
    static let shareInstance = XPToast()
    private init(){}
    
    /// 提示的label
    let messageLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    var window: UIWindow?
    /// 显示的时间
    var showTime: TimeInterval = 2
    /// 动画时间
    var animaDuration: TimeInterval = 0.25
    
    /// 资源释放类
    private var disposable: XPDisposable? {
        didSet {
            oldValue?.dispose()
        }
    }
    
    public class func show(_ message: String) {
        let label = self.shareInstance.messageLabel
        
        label.text = message
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        
        let uiScreenSize = UIScreen.main.bounds.size
        let screenWidth = uiScreenSize.width
        let screenHeight = uiScreenSize.height
        
        let rect = (message as NSString).boundingRect(with: CGSize.init(width: screenWidth * 0.7, height: screenHeight * 0.4), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: label.font], context: nil)
        
        let lableY: CGFloat = 10
        let lableX = min(rect.height / 2, 20) + lableY
        label.frame = CGRect.init(x: lableX, y: lableY, width: rect.width, height: rect.height)
        
        let width = rect.width + lableX * 2
        let height = rect.height + lableY * 2
        let x = (screenWidth  - width) / 2
        let y = (screenHeight - height) * 0.8
        
        let window = UIWindow()
        self.shareInstance.window = window
        window.frame = CGRect.init(x: x, y: y, width: width, height: height)
        window.layer.cornerRadius = 8
        window.backgroundColor = UIColor(white: 0, alpha: 0.7)
        window.windowLevel = UIWindow.Level.alert
        window.isHidden = false
        window.addSubview(label)
        
        self.shareInstance.statusShowBefore()
        UIView.animate(withDuration: self.shareInstance.animaDuration, animations: {
            self.shareInstance.statusShowing()
        }, completion: nil)
        
        self.shareInstance.disposable = delayerOnMain(delay: self.shareInstance.showTime) {
            self.dismiss()
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+self.shareInstance.showTime) {
            self.dismiss()
        }
    }
    
    class func dismiss() {
        
        UIView.animate(withDuration: self.shareInstance.animaDuration, animations: {
            self.shareInstance.statusHideAfter()
        }) { (_) in
            self.hide()
        }
    }
    
    private class func hide(){
        self.shareInstance.disposable = nil
        self.shareInstance.messageLabel.removeFromSuperview()
        if let window = self.shareInstance.window {
            window.isHidden = true
            window.resignKey()
        }
        self.shareInstance.window = nil
    }
    
    /// 显示之前
    private func statusShowBefore() {
        self.window?.alpha = 0.1
        let scareTransform = CGAffineTransform(scaleX: 1.0, y: 0.7)
        let translateTransform = scareTransform.translatedBy(x: 0, y: -(self.messageLabel.frame.height + self.messageLabel.frame.origin.y ))
        
        window?.transform = translateTransform
    }
    
    /// 显示时的动画
    private func statusShowing(){
        window?.alpha = 1.0
        let scareTransform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        let translateTransform = scareTransform.translatedBy(x: 0, y: 0)
        window?.transform = translateTransform
    }
    
    /// 隐藏时的动画
    private func statusHideAfter(){
        window?.alpha = 0.1
        let scareTransform = CGAffineTransform(scaleX: 1.0, y: 0.7)
        
        let translateTransform = scareTransform.translatedBy(x: 0, y: self.messageLabel.frame.height + self.messageLabel.frame.origin.y)
        window?.transform = translateTransform
    }
    
    deinit {
        print("XPToast is deinit ")
    }
}
