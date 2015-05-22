//
//  ViewController.h
//  PercolateTask
//
//  Created by Teju Prasad on 5/19/15.
//  Copyright (c) 2015 Four Rooms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "Reachability.h"
#import "DataSynchronizer.h"
#import "CoffeeObjectTableViewCell.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, DataSynchronizerDelegate>


@end

