//
//  DetailViewController.h
//  OfflineShopLego
//
//  Created by Wendell on 11/19/12.
//  Copyright (c) 2012 Wendell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController {
    NSString *imagePath;
}

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *itemTitle;

@property (weak, nonatomic) IBOutlet UILabel *code;
@property (weak, nonatomic) IBOutlet UIImageView *preview;
@property (weak, nonatomic) IBOutlet UILabel *priceUSD;
@property (weak, nonatomic) IBOutlet UILabel *pricePHP;
@property (weak, nonatomic) IBOutlet UILabel *priceHKD;


@end
