# UITabbarExtension

### Introduction

The UITabbarExtension was built to against the the restriction of the UITabarItem.


UITabbarExtension allows you to have a own customed image in same place where the origin
tabBarItem.badgeValue label located,without overriding the class of your TabBar or tabBarItem.And you 
can also control the hidden of the badimage through the my_badgeImageHidden property which is 
associated with badimage

### How to Use
Drag Swizzling+UITabBar.swift into you source project,the UITabbarExtension will work when the UITabBar Class was loaded.
By adding image to the tabbarItem,just need to setting the value of the my_badgeImage which is governed by the each childViewController of TabBarController,and make visiable by setting the flag my_badgeImageHidden to false.   
when finished setting the custom badge image of tabBarItem,don't forget to send setNeedsLayout message to you tabbar which responsiable for the tabBarItem you set.

### Example
```Swift
self.navigationController?.tabBarItem.my_badgeImage = pureColorImage(UIColor.greenColor())
self.navigationController?.tabBarItem.my_badgeImageHidden = false
rootVc.tabBar.setNeedsLayout()

```