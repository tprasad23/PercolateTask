//
//  AppDelegate.h
//  PercolateTask
//
//  Created by Teju Prasad on 5/19/15.
//  Copyright (c) 2015 Four Rooms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "Constant.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) ViewController *viewController;
@property (nonatomic, strong) UINavigationController *navCtr;

@end

