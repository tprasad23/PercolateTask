//
//  StorageManager.h
//  PercolateTask
//
//  Created by Teju Prasad on 5/20/15.
//  Copyright (c) 2015 Four Rooms. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"
#import <UIKit/UIKit.h>



@interface StorageManager : NSObject


@property (nonatomic, strong) NSDictionary *detailedInfoDictionary;

- (void)saveImageToDisk:(UIImage *)image imgFileName:(NSString *)imgFileName;
- (UIImage *)extractImageForCoffeeId:(NSString *)itemId;





@end
