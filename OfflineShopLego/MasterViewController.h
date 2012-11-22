//
//  MasterViewController.h
//  OfflineShopLego
//
//  Created by Wendell on 11/19/12.
//  Copyright (c) 2012 Wendell. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate, UISearchBarDelegate> {
    @private
        NSString *searchKey;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end
