//
//  XPHUD.swift
//  XPToastExample
//
//  Created by xp on 2018/5/25.
//  Copyright © 2018年 worldunion. All rights reserved.
//

import UIKit

/// 等待对话框。上面一个等待动画，下面一个文本提示
public class HUD: UIView {
    
    /// 动画时间
    private static let animDuration: TimeInterval = 0.3
    
    /// 背景View
    private static let rootViewBg: UIColor = UIColor(white: 0, alpha: 0.5)
    private var _window: UIWindow?
    
    /// 提示语label
    private lazy var msgLable: UILabel = {
        let msgLable = UILabel()
        msgLable.font = UIFont.systemFont(ofSize: 15)
        msgLable.textColor = UIColor.white
        msgLable.numberOfLines = 1
        msgLable.textAlignment = .center
        return msgLable
    }()
    
    /// 菊花
    private lazy var indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        return indicatorView
    }()
    
    /// 提示语
    public var message: String? {
        didSet{
            self.msgLable.text = self.message
        }
    }
    
    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor(white: 0, alpha: 0.5)
        layer.cornerRadius = 10
        addSubview(indicatorView)
        addSubview(msgLable)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        let uiScreenSize = UIScreen.main.bounds.size
        let screenWidth = uiScreenSize.width
        let screenHeight = uiScreenSize.height
        
        let indicatorSize = indicatorView.intrinsicContentSize
        let labelSize = msgLable.intrinsicContentSize
        
        let indicatorY: CGFloat = 20
        let indicatorAndLabelSplit: CGFloat = 10
        let height = indicatorY + indicatorSize.height + indicatorAndLabelSplit + labelSize.height + 15
        let width = max(height * 1.1, indicatorSize.width + indicatorY*2)
        self.frame = CGRect.init(x: (screenWidth - width) / 2, y: (screenHeight - height) / 2, width: width, height: height)
        
        indicatorView.frame = CGRect.init(x: (width - indicatorSize.width) / 2, y: indicatorY, width: indicatorSize.width, height: indicatorSize.height)
        
        msgLable.frame = CGRect.init(x: 10, y: indicatorY + indicatorSize.height + indicatorAndLabelSplit, width: width - 10*2, height: labelSize.height)
    }
    
    /** 显示方法，调用该方法，这个界面将显示 **/
    
    /// 显示方法，调用该方法，这个界面将显示
    func show(){
        let _window = UIWindow()
        self._window = _window
        _window.frame = UIScreen.main.bounds
        _window.backgroundColor = UIColor.clear
        _window.windowLevel = UIWindowLevelAlert
        _window.alpha = 1
        _window.isHidden = false
        _window.addSubview(self)
        
        statusShowBefore()
        UIView.animate(withDuration: HUD.animDuration) {
            self.statusShowing()
        }
    }
    
    /** 消失方法，调用该方法，这个界面将消失 **/
    func dismiss(){
        UIView.animate(withDuration: HUD.animDuration, animations: {
            self.statusDismiss()
        }) { (_) in
            self.remove_windowAction()
        }
    }
    
    private func remove_windowAction(){
        removeFromSuperview()
        if let _window = _window {
            _window.isHidden = true
            _window.resignKey()
        }
        _window = nil
    }
    
    private func statusShowBefore(){
        indicatorView.startAnimating()
        alpha = 0
        transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    
    private func statusShowing() {
        _window?.backgroundColor = HUD.rootViewBg
        alpha = 1
        transform = CGAffineTransform(scaleX: 1, y: 1)
    }
    
    private func statusDismiss(){
        _window?.backgroundColor = UIColor.clear
        alpha = 0
        transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        indicatorView.stopAnimating()
    }
    
    deinit {
        print("HUD:\(hash) is deinit ")
    }
}

// 考虑到可能同时存在多个HUD，引入控制工具提供控制，一个控制工具管理一个HUD对象
public class XPHUDUtils {
    
    static var share: XPHUDUtils = XPHUDUtils()
    private init() {}
    
    private weak var hud: HUD?
    private var disposable: XPDisposable? {
        didSet{
            oldValue?.dispose()
        }
    }
    
    // 延迟显示对话框，延迟时间为单位为：秒，message 为 nil 时显示 "请稍后..."
    public func showHUD(message: String? = nil, delay: TimeInterval? = nil) {
        if let delay = delay, delay > 0 {
            disposable = delayerOnMain(delay: delay){ [weak self] in self?.showHUD(message: message) }
        } else {
            showHUD(message: message)
        }
    }
    
    public func showHUD(message: String?) {
        let message = message ?? "请稍后..."
        if let view = hud {
            if message == view.message{
                return
            }
            view.dismiss()
        }
        let view = HUD()
        self.hud = view
        view.message = message
        view.show()
    }
    
    // 取消对话框
    public func hideHUD() {
        disposable = nil
        hud?.dismiss()
    }
    
}







