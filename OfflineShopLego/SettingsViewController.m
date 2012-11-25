//
//  SettingsViewController.m
//  OfflineShopLego
//
//  Created by Wendell on 11/25/12.
//  Copyright (c) 2012 Wendell. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController () {
    @private
    NSString *settingsFilePath;
}
- (void)configureView;
@end

@implementation SettingsViewController

- (void)configureView
{
    // get the currency values
    // from stackoverflow.com/questions/6496454/read-write-file-in-documents-directory-problem
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    settingsFilePath = [libraryDirectory stringByAppendingPathComponent:@"currencies.plist"];
    currencies = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsFilePath];
    if(currencies == nil) {
        // initialize new values to the dictionary
        currencies = [[NSMutableDictionary alloc] init];
        [currencies setValue:[NSNumber numberWithDouble:0.0] forKey:@"HKD"];
        [currencies setValue:[NSNumber numberWithDouble:0.0] forKey:@"PHP"];
    }
    // load the values in the text fields
    self.hkdValue.text = [NSString stringWithFormat:@"%.2f", [[currencies valueForKey:@"HKD"] doubleValue]];
    self.phpValue.text = [NSString stringWithFormat:@"%.2f", [[currencies valueForKey:@"PHP"] doubleValue]];
}


#pragma View Stuff

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self configureView];
}

- (void)viewDidDisappear:(BOOL)animated {
    // save the settings in the plist file
    // save the currency values
    NSNumberFormatter *currency = [[NSNumberFormatter alloc] init];
    [currency setNumberStyle:NSNumberFormatterDecimalStyle];
    [currencies setValue:[currency numberFromString:self.hkdValue.text] forKey:@"HKD"];
    [currencies setValue:[currency numberFromString:self.phpValue.text] forKey:@"PHP"];
    if(![currencies writeToFile:settingsFilePath atomically:NO])
	{
		NSLog(@".plist writing was unsucessfull");
	}
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
