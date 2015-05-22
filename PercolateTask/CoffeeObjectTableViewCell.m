//
//  CoffeeObjectTableViewCell.m
//  PercolateTask
//
//  Created by Teju Prasad on 5/21/15.
//  Copyright (c) 2015 Four Rooms. All rights reserved.
//

#import "CoffeeObjectTableViewCell.h"

@interface CoffeeObjectTableViewCell ()

@property (nonatomic, strong) UIImageView *coffeeImageView;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) MainCoffeeObject *coffeeObject;

@end

@implementation CoffeeObjectTableViewCell

static const CGFloat xBuffer = 7;
static const CGFloat yBuffer = 5;
static const CGFloat maxCoffeeImageHeight = 115;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CoffeeObjectTableViewCell *)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier coffeeObject:(MainCoffeeObject *)coffeeObject
{
    self = [self initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        self.coffeeObject = coffeeObject;
        
        self.nameLabel = [UILabel new];
        self.nameLabel.frame = CGRectMake(xBuffer, yBuffer, 320 - xBuffer, 20);
        self.nameLabel.font = [UIFont fontWithName:kHelveticalReg size:14.0f];
        self.nameLabel.textColor = kDarkGray;
        
        self.descLabel = [UILabel new];
        self.descLabel.frame = CGRectMake(xBuffer, yBuffer + 30, 320 - (2*xBuffer), 40);
        self.descLabel.font = [UIFont fontWithName:kHelveticalReg size:12.0f];
        self.descLabel.textColor = kLightGray;
        self.descLabel.numberOfLines = 0;
        self.descLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        self.coffeeImageView = [UIImageView new];
        self.coffeeImageView.frame = CGRectMake(xBuffer, yBuffer + 80, 200, 150);
        
        // add cell separator
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        self.lineView.backgroundColor = kLightGray;
        
        [self addSubview:self.nameLabel];
        [self addSubview:self.descLabel];
        [self addSubview:self.coffeeImageView];
        [self addSubview:self.lineView];
    }
    
    
    return self;
}

- (void)updateUI:(MainCoffeeObject *)coffeeObject
{
    // Set labels & images.
    
    self.nameLabel.text = coffeeObject.itemName;
    self.descLabel.text = coffeeObject.desc;
    
    
    // Based on the image size, set the imageView frame.
    // Each image is capped at a maximum height.

    if ( [coffeeObject hasImageURL] )
    {
        self.coffeeImageView.hidden = NO;
        
        UIImage *image = [self extractImageForCoffeeName:coffeeObject.itemID];
        
        CGFloat imgSizeWidth = image.size.width;
        CGFloat imgSizeHeight = image.size.height;
        
        if (image.size.height > maxCoffeeImageHeight )
        {
            // scale the "maximum height" proportionately.
            imgSizeWidth = (maxCoffeeImageHeight) * (imgSizeWidth/imgSizeHeight);
            imgSizeHeight = maxCoffeeImageHeight;
        }
        
        CGRect frame = self.coffeeImageView.frame;
        frame.size.height = imgSizeHeight;
        frame.size.width = imgSizeWidth;
        
        self.coffeeImageView.frame = frame;
        self.coffeeImageView.image = image;
    }
    else
    {
        self.coffeeImageView.hidden = YES;
    }
    
    // position lineVew
    
    CGFloat yPos = [coffeeObject hasImageURL] ? (kHeightWithImage - 1) : (kHeightWithoutImage - 1);
    
    self.lineView.frame = CGRectMake(xBuffer, yPos, 320-xBuffer, 1);
}

- (UIImage *)extractImageForCoffeeName:(NSString *)itemID;
{
    StorageManager *storageManager = [StorageManager new];
    
    UIImage *image = [storageManager extractImageForCoffeeId:itemID];
    
    return image;
}

@end
