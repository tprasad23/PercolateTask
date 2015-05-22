//
//  DataSynchronizer.m
//  PercolateTask
//
//  Created by Teju Prasad on 5/20/15.
//  Copyright (c) 2015 Four Rooms. All rights reserved.
//

#import "DataSynchronizer.h"

@interface DataSynchronizer ()

@property (nonatomic, strong) StorageManager *storageManager;

// for downloading images associated with the "main content dictionary"
@property (nonatomic) NSInteger *downloadsExpected;
@property (nonatomic) NSInteger *downloadsCompleted;
@end


@implementation DataSynchronizer


#pragma mark public methods

// init

- (id)init
{
    if ( self = [super init] )
    {
        self.storageManager = [StorageManager new];
        self.downloadsCompleted = 0;
    }
    
    return self;
}

// Method to request initial coffee data
- (void)requestCoffeeData
{
    if ( [self isConnected] )
    {
        // If connected make network request.
        
        NSString *urlString = [NSString stringWithFormat:@"https://coffeeapi.percolate.com/api/coffee/?api_key=%@",kAPIkey];
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            // Received Main Data dictionary
            
            NSArray *responseArray = (NSArray *) responseObject;
            self.coffeeObjectArray = [self getArrayOfMainCoffeeObjects:responseArray];
            
            // Save Main Array of Dictionaries To Disk
            [[NSUserDefaults standardUserDefaults] setObject:responseArray forKey:kMainObjectArrayKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // Download all necessary images
            [self downloadImagesForCoffee:self.coffeeObjectArray];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
        // Kick off request.
        [operation start];
    }
    else
    {
        // if not connected retrieve from disk (if available)
        
        if ( [[NSUserDefaults standardUserDefaults] objectForKey:kMainObjectArrayKey] )
        {
            NSArray *mainObjectArray = [[NSUserDefaults standardUserDefaults] objectForKey:kMainObjectArrayKey];
            
            self.coffeeObjectArray = [self getArrayOfMainCoffeeObjects:mainObjectArray];
            
            // call delegate
            [self.delegate allImagesDownloaded:self];
        }
    }
}

- (void)requestSingleItemData:(MainCoffeeObject *)coffeeObject
{
    
    if ( [self isConnected] )
    {
    
        NSString *urlString = [NSString stringWithFormat:@"https://coffeeapi.percolate.com/api/coffee/%@/?api_key=%@",coffeeObject.itemID,kAPIkey];
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            // Received Main Data dictionary
            
            NSDictionary *responseDictionary = (NSDictionary *) responseObject;
            
            [self.delegate singleItemDownloaded:responseDictionary];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
        // initiate request
        
        [operation start];
        
    }
    else
    {
        NSDictionary *responseDictionary   = self.storageManager.detailedInfoDictionary;
        NSDictionary *singleItemDictionary = [responseDictionary objectForKey:coffeeObject.itemID];
        
        
        [self.delegate singleItemDownloaded:singleItemDictionary];
    }
    
}


- (void)downloadImagesForCoffee:(NSArray *)coffeeObjectArray
{
    // coffee object Array is an array of our model objects.
    
    for (MainCoffeeObject *coffeeObject in coffeeObjectArray)
    {
        if ( ![coffeeObject.imageURLString isEqualToString:@""] )
        {
            // this particular item has an associated image, download and save it to
            // disk.
            
            NSString *imgFileName = [NSString stringWithFormat:@"%@.png",coffeeObject.itemID];
            
            NSURL *url = [NSURL URLWithString:coffeeObject.imageURLString];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            operation.responseSerializer = [AFImageResponseSerializer serializer];
            
            
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                    // save image.
                
                    UIImage *image = (UIImage *) responseObject;
                    [self.storageManager saveImageToDisk:image imgFileName:imgFileName];
                
                    self.downloadsCompleted++;
                
                    if ( self.downloadsCompleted == self.downloadsExpected )
                    {
                        // All images have been downloaded & saved
                        
                        [self.delegate allImagesDownloaded:self];
                    }
        
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"Image could not be downloaded, error is %@",error.localizedDescription);
                
            }];
            
            // Kick off request
            
            [operation start];
        
        }
    }
}

- (NSArray *)getArrayOfMainCoffeeObjects:(NSArray *)arrayOfDictionary
{
    NSMutableArray *returnArray = [NSMutableArray new];
    
    // This method will downlaod all the images if necessary that are associated
    // and instantiate
    
    for ( NSDictionary *itemDictionary in arrayOfDictionary )
    {
        MainCoffeeObject *mainCoffeeObject = [MainCoffeeObject coffeeObjectWithDictionary:itemDictionary];
        
        // If mainCoffeeObject has image url present, increase the number of expected images
        if ( ![mainCoffeeObject.imageURLString isEqualToString:@""] )
        {
            self.downloadsExpected++;
        }
        
        [returnArray addObject:mainCoffeeObject];
    }
    
    return returnArray;
}

- (BOOL)isConnected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}



@end
