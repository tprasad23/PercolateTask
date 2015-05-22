//
//  StorageManager.m
//  PercolateTask
//
//  Created by Teju Prasad on 5/20/15.
//  Copyright (c) 2015 Four Rooms. All rights reserved.
//

#import "StorageManager.h"
#import <CoreGraphics/CoreGraphics.h>

@interface StorageManager ()

@property (nonatomic, strong) NSFileManager *fileManager;

@end

@implementation StorageManager

@synthesize detailedInfoDictionary = _detailedInfoDictionary;

#pragma mark public methods
- (void)saveImageToDisk:(UIImage *)image imgFileName:(NSString *)imgFileName
{
    NSString *fullImagePath = [NSString stringWithFormat:@"%@/%@",[self imageDirectoryPath],imgFileName];
    
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
    [imageData writeToFile:fullImagePath atomically:YES];
}

#pragma mark private methods

-(NSString *)imageDirectoryPath
{
    NSString *suffix = @"images";
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    
    if ( [self createDirectoryWithName:suffix atPathName:documentsDirectoryPath] )
    {
        NSString *returnString = [documentsDirectoryPath stringByAppendingString:[NSString stringWithFormat:@"/%@",suffix]];
        
        return returnString;
    }
    
    // diretory was not created properly, return nil.
    
    return Nil;
}

- (BOOL)createDirectoryWithName:(NSString *)dirName atPathName:(NSString *)pathName
{
    self.fileManager = [[NSFileManager alloc] init];
    NSError *error;
    
    NSString *pathWithDirectoryName = [pathName stringByAppendingPathComponent:dirName];
    
    BOOL isDir;
    BOOL directoryExists = [self.fileManager fileExistsAtPath:pathWithDirectoryName isDirectory:&isDir];
    
    if ( !directoryExists )
    {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:pathWithDirectoryName
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error])
        {
            NSLog(@"Create directory error: %@", error);
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else
    {
        return YES;
    }
}

- (UIImage *)extractImageForCoffeeId:(NSString *)itemId
{
    NSString *imgPath = [NSString stringWithFormat:@"%@/%@.png",[self imageDirectoryPath],itemId];
    UIImage *image;
    
    if ( [self.fileManager fileExistsAtPath:imgPath] )
    {
        NSData *data = [NSData dataWithContentsOfFile:imgPath];
        image = [UIImage imageWithData:data];
    }
    
    return image;
}

#pragma mark detailedInfoDictionary getter/setter

- (NSDictionary *)detailedInfoDictionary
{
    if ( [[NSUserDefaults standardUserDefaults] objectForKey:kDetailDictionarykey] )
    {
        _detailedInfoDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:kDetailDictionarykey];
        return _detailedInfoDictionary;
    }
    
    return nil;
}

- (void)setDetailedInfoDictionary:(NSDictionary *)detailedInfoDictionary
{
    [[NSUserDefaults standardUserDefaults] setObject:detailedInfoDictionary forKey:kDetailDictionarykey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



@end
