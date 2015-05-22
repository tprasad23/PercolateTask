//
//  DetailViewController.h
//  PercolateTask
//
//  Created by Teju Prasad on 5/20/15.
//  Copyright (c) 2015 Four Rooms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "StorageManager.h"
#import "MainCoffeeObject.h"
#import "DataSynchronizer.h"

@interface DetailViewController : UIViewController <DataSynchronizerDelegate>

@property (nonatomic, strong) StorageManager *storageManager;
@property (nonatomic, strong) MainCoffeeObject *coffeeObject;


@end
