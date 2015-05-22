//
//  MainCoffeeObject.h
//  PercolateTask
//
//  Created by Teju Prasad on 5/21/15.
//  Copyright (c) 2015 Four Rooms. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainCoffeeObject : NSObject

@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *itemID;
@property (nonatomic, strong) NSString *imageURLString;
@property (nonatomic, strong) NSString *itemName;

+ (MainCoffeeObject *)coffeeObjectWithDictionary:(NSDictionary *)dictionary;
- (BOOL)hasImageURL;

@end
