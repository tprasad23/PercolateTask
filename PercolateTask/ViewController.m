//
//  ViewController.m
//  PercolateTask
//
//  Created by Teju Prasad on 5/19/15.
//  Copyright (c) 2015 Four Rooms. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UITableView *theTableView;
@property (nonatomic, strong) NSArray *coffeeObjectArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self requestDataFromServer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupNavBar];
}

- (void)loadView
{
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    frame.origin.x = 0.0f;
    frame.origin.y = 0.0f;
    
    // account for nav bar + status bar.
    frame.size.height = frame.size.height - 64;
    
    UIView *mainView = [[UIView alloc] initWithFrame:frame];
    mainView.backgroundColor = [UIColor whiteColor];

    self.theTableView = [[UITableView alloc] initWithFrame:frame];
    [self.theTableView setSeparatorInset:UIEdgeInsetsZero];
    self.theTableView.delegate = self;
    self.theTableView.dataSource = self;
    self.theTableView.backgroundColor = [UIColor clearColor];
    [self.theTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [mainView addSubview:self.theTableView];
    
    self.view = mainView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark request data from server
- (void)requestDataFromServer
{
    DataSynchronizer *dataSynchronizer = [DataSynchronizer new];
    dataSynchronizer.delegate = self;
    [dataSynchronizer requestCoffeeData];
}

#pragma mark Data Synch delegate
- (void)allImagesDownloaded:(DataSynchronizer *)dataSynchronizer
{
    self.coffeeObjectArray = dataSynchronizer.coffeeObjectArray;
    
    [self.theTableView reloadData];
}


#pragma mark reachability
- (BOOL)isConnected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}


#pragma mark table data source & delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.coffeeObjectArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // get coffee object
    MainCoffeeObject *coffeeObject = [self.coffeeObjectArray objectAtIndex:indexPath.row];
    
    
    static NSString *cellIdentifier = @"CellID";
    CoffeeObjectTableViewCell *cell = (CoffeeObjectTableViewCell *)[self.theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if ( cell == nil )
    {
        cell = [[CoffeeObjectTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier coffeeObject:coffeeObject];
    }
    
    [cell updateUI:coffeeObject];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainCoffeeObject *coffeeObject = [self.coffeeObjectArray objectAtIndex:indexPath.row];
    
    if ( [coffeeObject hasImageURL] )
    {
        return kHeightWithImage;
    }
    else
    {
        return kHeightWithoutImage;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailVC = [DetailViewController new];
    detailVC.coffeeObject = (MainCoffeeObject *) [self.coffeeObjectArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark setup nav bar
- (void)setupNavBar
{
    [self.navigationController.navigationBar  setTranslucent:NO];
    [self.navigationController.navigationBar setBarTintColor:kOrange];
    
    UIImage *image = [UIImage imageNamed:@"drip-white-small.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 34, 40)];
    imageView.image = image;
    [self.navigationController.navigationBar.topItem setTitleView:imageView];
}



@end
