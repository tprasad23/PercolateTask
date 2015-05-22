//
//  MainCoffeeObject.m
//  PercolateTask
//
//  Created by Teju Prasad on 5/21/15.
//  Copyright (c) 2015 Four Rooms. All rights reserved.
//

#import "MainCoffeeObject.h"

@implementation MainCoffeeObject

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.desc            = [decoder decodeObjectForKey:@"desc"];
    self.itemID          = [decoder decodeObjectForKey:@"id"];
    self.itemName        = [decoder decodeObjectForKey:@"name"];
    self.imageURLString  = [decoder decodeObjectForKey:@"image_url"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    
    [coder encodeObject:self.desc           forKey:@"desc"];
    [coder encodeObject:self.itemID         forKey:@"id"];
    [coder encodeObject:self.itemName       forKey:@"name"];
    [coder encodeObject:self.imageURLString forKey:@"image_url"];
}

+ (MainCoffeeObject *)coffeeObjectWithDictionary:(NSDictionary *)dictionary
{
    MainCoffeeObject *coffeeObject = [MainCoffeeObject new];
    
    coffeeObject.desc = [dictionary objectForKey:@"desc"];
    coffeeObject.itemID = [dictionary objectForKey:@"id"];
    coffeeObject.itemName = [dictionary objectForKey:@"name"];
    coffeeObject.imageURLString = [dictionary objectForKey:@"image_url"];
    
    return coffeeObject;
}

- (BOOL)hasImageURL
{
    if ( [self.imageURLString isEqualToString:@""] )
    {
        return NO;
    }
    
    return YES;
}

@end
