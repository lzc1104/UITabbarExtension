//
//  Swizzling+TabBar.swift
//  NavigationBar
//
//  Created by Alex on 3/2/16.
//  Copyright © 2016 Alex. All rights reserved.
//

import UIKit

extension UITabBar {
    private  struct SytemBadge {
        static let SystemBadgeRect = CGRect(x: 69, y: 2, width: 20, height: 20)
    }
    private struct Once {
        static var once_token : dispatch_once_t = 0
    }
    
    
    public override class func initialize() {
        debugPrint(__FUNCTION__)
        dispatch_once(&Once.once_token) { () -> Void in
            let oldMethod = class_getInstanceMethod(self, Selector("layoutSubviews"))
            let swizzlingMethod = class_getInstanceMethod(self, Selector("my_layoutSubviews"))
            
            let swizzlImp = class_getMethodImplementation(self, Selector("my_layoutSubviews"))
            let oldImp = class_getMethodImplementation(self, Selector("layoutSubviews"))
            
            let add_success = class_addMethod(self, Selector("layoutSubviews"), swizzlImp, method_getTypeEncoding(oldMethod))
            
            if add_success {
                class_replaceMethod(self, Selector("my_layoutSubviews"), oldImp, method_getTypeEncoding(swizzlingMethod))
            } else {
                method_exchangeImplementations(oldMethod, swizzlingMethod)
            }
        }
        
       
        
    }
    
    func my_layoutSubviews() {
        my_layoutSubviews()
        for (index ,tabBarButton) in subviews.filter({
            String($0.dynamicType) == "UITabBarButton"
        }).enumerate() {
            let item = items![index]
            
            if let _ = tabBarButton.tabBarBtn_hasAdd  {
                
            } else {
                let imageview = UIImageView(frame: SytemBadge.SystemBadgeRect)
                imageview.layer.cornerRadius = SytemBadge.SystemBadgeRect.width / 2
                imageview.clipsToBounds = true
                
                tabBarButton.badgeImageView = imageview
                tabBarButton.addSubview(tabBarButton.badgeImageView!)
                
                let aboveRect = tabBarButton.badgeImageView!.convertRect(tabBarButton.badgeImageView!.bounds, toView: self)
                print(aboveRect)
                tabBarButton.badgeImageView?.removeFromSuperview()
                tabBarButton.badgeImageView!.frame = aboveRect
                
                self.addSubview(tabBarButton.badgeImageView!)
                tabBarButton.tabBarBtn_hasAdd = true
            }
            
            if let image = item.my_badgeImage  where item.my_badgeImageHidden == false {
                tabBarButton.badgeImageView!.image = image
                tabBarButton.badgeImageView?.hidden = item.my_badgeImageHidden!
                     
            } else {
                
                tabBarButton.badgeImageView?.hidden = true
            }
            
            
            
        }

    }
}


extension UITabBarItem {
    
    private struct Struct {
        static var customHeight = "customHeight"
        static var customBool = "customBool"
    }
    
    dynamic var my_badgeImage : UIImage? {
        get{
            
            return objc_getAssociatedObject(self, &Struct.customHeight) as? UIImage
        }
        set{
            if let value = newValue {
                objc_setAssociatedObject(self, &Struct.customHeight, value as UIImage, .OBJC_ASSOCIATION_RETAIN)
            }
        }
    }
    
    var my_badgeImageHidden : Bool? {
        get{
            
            return objc_getAssociatedObject(self, &Struct.customBool) as? Bool
        }
        set{
            if let value = newValue {
                
                objc_setAssociatedObject(self, &Struct.customBool, value as Bool, .OBJC_ASSOCIATION_RETAIN)
            }
            
        }
    }
    
}

extension UIView {
    
    private struct Struct {
        static var badgeImageView = "badgeImageView"
        static var tabBarBtn_Bool = "tabBarBtn_Bool"
    }
    
    var tabBarBtn_hasAdd : Bool? {
        get{
            
            return objc_getAssociatedObject(self, &Struct.tabBarBtn_Bool) as? Bool
        }
        set{
            if let value = newValue {
                objc_setAssociatedObject(self, &Struct.tabBarBtn_Bool, value as Bool, .OBJC_ASSOCIATION_RETAIN)
            }
            
        }
    }
    
    var badgeImageView : UIImageView? {
        get{
            
            return objc_getAssociatedObject(self, &Struct.badgeImageView) as? UIImageView
        }
        set{
            
            if let value = newValue {
                objc_setAssociatedObject(self, &Struct.badgeImageView, value as UIImageView, .OBJC_ASSOCIATION_RETAIN)
            }
        }
    }
    
}

