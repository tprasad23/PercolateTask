//
//  DetailViewController.m
//  PercolateTask
//
//  Created by Teju Prasad on 5/20/15.
//  Copyright (c) 2015 Four Rooms. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *lastUpdatedLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) NSString *fullDescriptionString;
@property (nonatomic, strong) NSString *lastUpdatedString;
@property (nonatomic, strong) UIImageView *coffeeImageView;

@property (nonatomic, strong) DataSynchronizer *dataSynchronizer;
@property (nonatomic) NSInteger xPadding;

@end

@implementation DetailViewController

- (id)init
{
   if ( self = [super init] )
   {
       self.dataSynchronizer = [DataSynchronizer new];
       self.dataSynchronizer.delegate = self;
       
       self.storageManager = [StorageManager new];
   }
    
   return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // request data.
    
    [self.dataSynchronizer requestSingleItemData:self.coffeeObject];
    
    // Setup Nav Bar
    
    [self setupNavBar];
    [self setupBackButtonLeft];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    frame.origin.x = 0.0f;
    frame.origin.y = 0.0f;
    
    // account for nav bar + status bar.
    frame.size.height = frame.size.height - 64;
    
    // Instantiate UI
    UIView *mainView = [[UIView alloc] initWithFrame:frame];
    mainView.backgroundColor = [UIColor whiteColor];

    self.xPadding = 7;
    NSInteger yPadding = 15;
    
    self.nameLabel = [UILabel new];
    self.nameLabel.frame = CGRectMake(self.xPadding, yPadding, 320-self.xPadding, 25);
    self.nameLabel.font = [UIFont fontWithName:kHelveticalReg size:18.0f];
    self.nameLabel.text = self.coffeeObject.itemName;
    self.nameLabel.textColor = kDarkGray;
    
    self.lineView = [UIView new];
    self.lineView.frame = CGRectMake(self.xPadding, yPadding + 35, 320-self.xPadding, 1);
    self.lineView.backgroundColor = kLightGray;
    
    self.descLabel = [UILabel new];
    self.descLabel.frame = CGRectMake(self.xPadding, yPadding + 60, 320-(2*self.xPadding), 50);
    self.descLabel.font = [UIFont fontWithName:kHelveticalReg size:14.0f];
    self.descLabel.numberOfLines = 0;
    self.descLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.descLabel.textColor = kLightGray;
    
    self.coffeeImageView = [UIImageView new];
    self.coffeeImageView.frame = CGRectMake(self.xPadding, yPadding + 100, 320 - (2 * self.xPadding), 50);
    
    self.lastUpdatedLabel = [UILabel new];
    self.lastUpdatedLabel.frame = CGRectMake(self.xPadding, yPadding + 150, 320 - (2 * self.xPadding), 20);
    self.lastUpdatedLabel.font = [UIFont fontWithName:kHelveticaLightItalic size:12.0f];
    self.lastUpdatedLabel.textColor = kLightGray;
    
    [mainView addSubview:self.nameLabel];
    [mainView addSubview:self.lineView];
    [mainView addSubview:self.descLabel];
    [mainView addSubview:self.coffeeImageView];
    [mainView addSubview:self.lastUpdatedLabel];
    
    self.view = mainView;
}

#pragma mark UIUpdates
- (void)setupNavBar
{
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarTintColor:kOrange];
    
    UIImage *image = [UIImage imageNamed:@"drip-white-small.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 34, 40)];
    imageView.image = image;
    [self.navigationController.navigationBar.topItem setTitleView:imageView];
}

- (void)setupBackButtonLeft
{
    UIImage *backImg = [UIImage imageNamed:@"backArrow.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:backImg forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 25, 30);
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)updateUI:(NSString *)descriptionString lastUpdated:(NSString *)lastUpdatedString
{
    // Update the description Label
    
    CGRect tempFrame;
    
    self.descLabel.text = descriptionString;
    tempFrame = self.descLabel.frame;
    
    CGSize descLabelSize = [self calculateLabelSize:self.descLabel width:self.descLabel.frame.size.width];
    
    tempFrame.size.width = descLabelSize.width;
    tempFrame.size.height = descLabelSize.height;
    
    self.descLabel.frame = tempFrame;

    // Update the Image View frame and position
    
    CGFloat maxImageWidth = 320 - (2 * self.xPadding);
    CGFloat updatedWidth;
    CGFloat updatedHeight;
    
    UIImage *coffeeImage = [self.storageManager extractImageForCoffeeId:self.coffeeObject.itemID];
    
    if ( coffeeImage.size.width > maxImageWidth )
    {
        updatedWidth = maxImageWidth;
        updatedHeight = (maxImageWidth * coffeeImage.size.height) / coffeeImage.size.width;
    }
    else
    {
        updatedWidth = coffeeImage.size.width;
        updatedHeight = coffeeImage.size.height;
    }
    
    self.coffeeImageView.frame = CGRectMake(self.xPadding, self.descLabel.frame.origin.y + self.descLabel.frame.size.height + 10, updatedWidth, updatedHeight);
    self.coffeeImageView.image = coffeeImage;
    
    // update last "updated" label.
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.AAAAAA"];
    NSDate *lastUpdatedDate = [formatter dateFromString:lastUpdatedString];
    NSDate *dateNow = [NSDate date];
    
    NSLog(@"laste updated date is %@",lastUpdatedDate);
    
    NSTimeInterval timeInterval = [dateNow timeIntervalSinceDate:lastUpdatedDate];
    double secondsInAnDay = 24 * 3600;
    double secondsInAWeek = 7 * secondsInAnDay;
    
    NSInteger num;
    NSString *timeSinceString;
    if ( timeInterval > secondsInAWeek )
    {
        num = round(timeInterval/secondsInAWeek);
        timeSinceString = [NSString stringWithFormat:@"Last Updated %ld weeks ago",(long)num];
    }
    else if ( timeInterval > secondsInAnDay && timeInterval < secondsInAWeek)
    {
        num = round(timeInterval/secondsInAnDay);
        timeSinceString = [NSString stringWithFormat:@"Last Updated %ld days ago",(long)num];
    }
    
    self.lastUpdatedLabel.text = timeSinceString;
    self.lastUpdatedLabel.frame = CGRectMake(self.xPadding, self.coffeeImageView.frame.origin.y + self.coffeeImageView.frame.size.height + 5, 320-self.xPadding, 10);
}

- (CGSize)calculateLabelSize:(UILabel *)label width:(NSInteger)width
{
    CGSize available = CGSizeMake(width, INFINITY);
    CGSize newSize = [label sizeThatFits:available];
    
    return newSize;
}

- (void)backButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark Data Synchronizer Delegate
- (void)singleItemDownloaded:(NSDictionary *)singleItemDictionary
{
    // Set returned dictionary to NSuserDefaults.
    
    NSMutableDictionary *tempDictionary;

    if ( [self.storageManager detailedInfoDictionary] )
    {
        tempDictionary = [NSMutableDictionary dictionaryWithDictionary:self.storageManager.detailedInfoDictionary];
    }
    else
    {
        tempDictionary = [[NSMutableDictionary alloc] init];
    }
    
    if ( singleItemDictionary )
    {
        [tempDictionary setObject:singleItemDictionary forKey:self.coffeeObject.itemID];
    
        // update detail dictionary
        
        self.storageManager.detailedInfoDictionary = tempDictionary;
        
        // update UI
        
        [self updateUI:[singleItemDictionary objectForKey:@"desc"]
           lastUpdated:[singleItemDictionary objectForKey:@"last_updated_at"]];
    }
}


@end
