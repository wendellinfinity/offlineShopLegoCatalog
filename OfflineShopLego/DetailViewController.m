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
    // Update the user interface for the detail item.

    if (self.detailItem) {
        double price;
        price = [[self.detailItem valueForKey:@"price"] doubleValue];
        self.itemTitle.text = [[self.detailItem valueForKey:@"title"] description];
        self.code.text = [[self.detailItem valueForKey:@"code"] description];
        self.priceUSD.text = [@"USD " stringByAppendingFormat:@"%.2f",price];
        //self.priceHKD.text = [[self.detailItem valueForKey:@"code"] description];
        //self.pricePHP.text = [[self.detailItem valueForKey:@"code"] description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.itemTitle sizeToFit];
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
