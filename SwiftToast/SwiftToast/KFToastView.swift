//
//  KFToastView.swift
//  SwiftToast
//
//  Created by hsm on 2017/10/26.
//  Copyright © 2017年 SM. All rights reserved.
//

import UIKit
private struct KFToastViewValue {
    static var FontSize:CGFloat{
        get{
            if  UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
            {
                return 12.0
            }else{
                return 16.0
            }
        }
    }
    static var PortraitOffsetY:CGFloat{
        get{
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone{
                return 30.0
            }else{
                return 60.0
            }
        }
    }
    static var LandscapeOffsetY:CGFloat{
        get{
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone{
                return 20.0
            }else{
                return 40.0
            }
        }
    }
}


private let kfToastView = KFToastView()
class KFToastView: UIView {
    
    var _backgroundView:UIView? = nil
    
    var _textLabel:UILabel! = nil
    var _textInsets: UIEdgeInsets? = nil
    var _isToastAnimating = false
    var _animationOption:UIViewAnimationOptions? = nil
    
    
    
    var text:String {
        get{
            return (_textLabel?.text)!
        }
        set(text){
            _textLabel?.text = text
        }
    }
    
    func setTextLabelColor(color:UIColor) -> Void {
        _textLabel?.textColor = color
    }
    
    func setToastViewBackgroundColor(color:UIColor) -> Void {
        _backgroundView?.backgroundColor = color
    }
    
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        _backgroundView = UIView(frame: CGRect.zero)
        _backgroundView!.backgroundColor = UIColor(white:0,alpha:0.7)
        _backgroundView!.clipsToBounds = true
        _backgroundView!.layer.cornerRadius = 5
        self.addSubview(_backgroundView!)
        
        _textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        _textLabel!.textColor = UIColor.white
        _textLabel!.backgroundColor = UIColor.clear
        _textLabel!.font = UIFont.systemFont(ofSize: 15.0)
        _textLabel!.numberOfLines = 0
        self.addSubview(_textLabel!)
        
        _textInsets = UIEdgeInsetsMake(6, 10, 6, 10)
    }
    
    class var sharedInstance:KFToastView{
         NotificationCenter.default.addObserver(kfToastView, selector: #selector(deviceOrientationDidChange(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        return kfToastView
    }
    
   @objc func deviceOrientationDidChange(_ sender: AnyObject?) {
        self.updateViewSize()
    }
    
    func showToast(text:String,duration:TimeInterval ,delay:TimeInterval) ->Void {
        self.showToast(text: text, duration: duration, delay: delay, option: UIViewAnimationOptions.beginFromCurrentState)
    }
    
    func showToast(text:String,duration:TimeInterval ,delay:TimeInterval,option:UIViewAnimationOptions) ->Void {
        if _isToastAnimating {
            return
        }
        _textLabel?.text = text;
        self.updateViewSize()
        _animationOption = option
        self.showToastWithDuration(duration: duration, delay: delay)
    }
    
    private func showToastWithDuration(duration:TimeInterval ,delay:TimeInterval) -> Void {
        _isToastAnimating = true
        self.alpha = 0
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.5,
                       delay: delay,
                       options: _animationOption!,
                       animations: { self.alpha = 1 },
                       completion: { (completed: Bool) -> Void in
                        UIView.animate(withDuration: duration,
                                       animations: { self.alpha = 1.0001 },
                                       completion: { (completed: Bool) -> Void in
                                        UIView.animate(withDuration: 0.5, animations: {self.alpha = 0
                                             self._isToastAnimating = false
                                            self.removeFromSuperview()
                                        })
                        })
        })
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   private  func updateViewSize(){
        let devWidth = UIApplication.shared.keyWindow?.screen.bounds.size.width
        let devHeight = UIApplication.shared.keyWindow?.screen.bounds.size.height
        
        let contensSzie = CGSize(width:devWidth!*(280.0/320.0),height:CGFloat(MAXFLOAT))
        let textLabelSize = self._textLabel!.sizeThatFits(contensSzie)
        self._textLabel?.frame = CGRect(x: (self._textInsets?.left)!, y: (self._textInsets?.top)!, width: textLabelSize.width, height: textLabelSize.height)
        self._backgroundView?.frame = CGRect(x: 0, y: 0, width: self._textLabel!.frame.size.width + self._textInsets!.left * 2, height: self._textLabel!.frame.size.height + self._textInsets!.top + self._textInsets!.bottom
        )
        
        var x:CGFloat
        var y:CGFloat
        var width:CGFloat
        var height:CGFloat
        
        
        switch UIApplication.shared.statusBarOrientation {
        case UIInterfaceOrientation.portraitUpsideDown:
            width = self._backgroundView!.frame.size.width
            height = self._backgroundView!.frame.size.height
            x = (devWidth! - width) / 2
            y = KFToastViewValue.PortraitOffsetY
            
        case UIInterfaceOrientation.landscapeRight:
            width = self._backgroundView!.frame.size.height
            height = self._backgroundView!.frame.size.width
            x = (devWidth! - height) / 2;
            y = devHeight! - width - KFToastViewValue.LandscapeOffsetY
            
        case UIInterfaceOrientation.landscapeLeft:
            width = self._backgroundView!.frame.size.height
            height = self._backgroundView!.frame.size.width
            x = (devWidth! - height) / 2;
            y = devHeight! - width - KFToastViewValue.LandscapeOffsetY
            
        default:
            width = self._backgroundView!.frame.size.width
            height = self._backgroundView!.frame.size.height
            x = (devWidth! - width) / 2
            y = devHeight! - height - KFToastViewValue.PortraitOffsetY
        }
        
        self.frame = CGRect(x: x, y: y, width: width, height: height)
        
    }
    
    
    override func hitTest(_ point: CGPoint, with event: UIEvent!) -> UIView? {
        return nil
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
