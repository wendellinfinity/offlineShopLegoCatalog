//
//  DetailViewController.m
//  OfflineShopLego
//
//  Created by Wendell on 11/19/12.
//  Copyright (c) 2012 Wendell. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    @autoreleasepool {
        // get the currencies
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *libraryDirectory = [paths objectAtIndex:0];
        NSString *settingsFilePath = [libraryDirectory stringByAppendingPathComponent:@"currencies.plist"];
        currencies = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsFilePath];
        if(currencies == nil) {
            // initialize new values to the dictionary
            currencies = [[NSMutableDictionary alloc] init];
            [currencies setValue:[NSNumber numberWithDouble:0.0] forKey:@"HKD"];
            [currencies setValue:[NSNumber numberWithDouble:0.0] forKey:@"PHP"];
        }
    }
    
    // Update the user interface for the detail item.
    if (self.detailItem) {
        double price;
        price = [[self.detailItem valueForKey:@"price"] doubleValue];
        self.itemTitle.text = [[self.detailItem valueForKey:@"title"] description];
        self.code.text = [[self.detailItem valueForKey:@"code"] description];
        self.priceUSD.text = [@"USD " stringByAppendingFormat:@"%.2f",price];

        // compute the conversions
        double hkdConversion, phpConversion;
        hkdConversion = [[currencies valueForKey:@"HKD"] doubleValue] * price;
        phpConversion = [[currencies valueForKey:@"PHP"] doubleValue] * price;
        // put conversions on text fields
        self.priceHKD.text = [NSString stringWithFormat:@"HKD %.2f",hkdConversion];
        self.pricePHP.text = [NSString stringWithFormat:@"PHP %.2f",phpConversion];
    
        // get the image
        @autoreleasepool {
            NSString *imagepath = [[NSBundle mainBundle] pathForResource:self.code.text ofType:@"jpg"];
            UIImage *previewImage = [[UIImage alloc] initWithContentsOfFile:imagepath];
            [self.preview setImage:previewImage];
            // center the image
            [self.preview setFrame:CGRectMake(self.view.center.x - (previewImage.size.width/2), self.preview.frame.origin.y + 20, previewImage.size.width, previewImage.size.height)];

        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //[self.itemTitle sizeToFit];
    [self.itemTitle setAdjustsFontSizeToFitWidth:YES];
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
