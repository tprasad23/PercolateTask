//
//  CoffeeObjectTableViewCell.h
//  PercolateTask
//
//  Created by Teju Prasad on 5/21/15.
//  Copyright (c) 2015 Four Rooms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainCoffeeObject.h"
#import "Constant.h"
#import "StorageManager.h"

@interface CoffeeObjectTableViewCell : UITableViewCell

- (CoffeeObjectTableViewCell *)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier coffeeObject:(MainCoffeeObject *)coffeeObject;

- (void)updateUI:(MainCoffeeObject *)coffeeObject;

@end
