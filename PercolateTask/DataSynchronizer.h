//
//  DataSynchronizer.h
//  PercolateTask
//
//  Created by Teju Prasad on 5/20/15.
//  Copyright (c) 2015 Four Rooms. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"
#import "AFNetworking.h"
#import "StorageManager.h"
#import "MainCoffeeObject.h"
#import "Reachability.h"

@class DataSynchronizer;

@protocol DataSynchronizerDelegate <NSObject>

@optional
- (void)allImagesDownloaded:(DataSynchronizer *)dataSynchronizer;
- (void)singleItemDownloaded:(NSDictionary *)singleItemDictionary;

@end

@interface DataSynchronizer : NSObject

@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSArray *coffeeObjectArray;

- (void)requestCoffeeData;
- (void)requestSingleItemData:(MainCoffeeObject *)coffeeObject;

@end
