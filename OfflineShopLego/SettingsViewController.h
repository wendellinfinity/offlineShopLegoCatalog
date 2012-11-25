//
//  SettingsViewController.h
//  OfflineShopLego
//
//  Created by Wendell on 11/25/12.
//  Copyright (c) 2012 Wendell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController {
    @private
    NSDictionary *currencies;
}

@property (weak, nonatomic) IBOutlet UITextField *hkdValue;
@property (weak, nonatomic) IBOutlet UITextField *phpValue;

@end
