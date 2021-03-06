//
//  MasterViewController.m
//  OfflineShopLego
//
//  Created by Wendell on 11/19/12.
//  Copyright (c) 2012 Wendell. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

@interface MasterViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation MasterViewController

@synthesize searchBar;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // FROM: gist.github.com/435996
    // Really a UISearchBarTextField, but that header is private.
    UITextField *searchField = nil;
    for (UIView *subview in searchBar.subviews) {
        if ([subview isKindOfClass:[UITextField class]]) {
            searchField = (UITextField *)subview;
            break;
        }
    }    
    if (searchField) {
        searchField.enablesReturnKeyAutomatically = NO;
    }
    
    // place a settings button on top
    // Initialize the UIButton
    // from: eureka.ykyuen.info/2010/06/11/iphone-adding-image-to-uibarbuttonitem/
    // icon from: app-bits.com/free-icons.html
    //UIImage *buttonImage = [UIImage imageNamed:@"settingsButton.png"];
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    //[settingsButton setImage:buttonImage forState:UIControlStateNormal];
    //settingsButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width+5, buttonImage.size.height+5);
    
    // Initialize the UIBarButtonItem
    UIBarButtonItem *settingsBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
    
    // Set the Target and Action for aButton
    [settingsButton addTarget:self action:@selector(launchSettings:) forControlEvents:UIControlEventTouchUpInside];
    
    // Then you can add the aBarButtonItem to the UIToolbar
    self.navigationItem.leftBarButtonItem = settingsBarButtonItem;
    
    // from stackoverflow.com/questions/4882332/uisearchbar-in-place-of-uinavigationcontroller-uinavigationbar
    // show the cancel button in the UISearchBar.
    searchBar.showsCancelButton = YES;
    // add UISearchBar into titleView of the UINavigationBar.
    self.navigationItem.titleView = searchBar;
    searchBar.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)launchSettings:(id)sender
{
    [self performSegueWithIdentifier:@"showSettings" sender:self];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LegoItem" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [NSFetchedResultsController deleteCacheWithName:@"Master"];
    if(searchKey != nil && [searchKey length] > 0) {
        NSPredicate *predicateTemplate = [NSPredicate predicateWithFormat:
                                          @"(code contains[cd] %@) OR \
                                          (title contains[cd] %@)", searchKey, searchKey];
        [fetchRequest setPredicate:predicateTemplate];
    }
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    //[fetchRequest setFetchLimit:80];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[object valueForKey:@"title"] description];
    cell.detailTextLabel.text = [[object valueForKey:@"code"] description];
}

#pragma UISearchBarDelegate
// from stackoverflow.com/questions/6203472/designing-ios-searchbar

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBarSource {
    [self handleSearch:searchBarSource];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBarSource {
    [self handleSearch:searchBarSource];
}

- (void)handleSearch:(UISearchBar *)searchBarSource {
    searchKey = self.searchBar.text;

    NSFetchRequest *fetchRequest = [self.fetchedResultsController fetchRequest];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LegoItem" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [NSFetchedResultsController deleteCacheWithName:@"Master"];
    if(searchKey != nil && [searchKey length] > 0) {
        NSPredicate *predicateTemplate = [NSPredicate predicateWithFormat:
                                          @"(code contains[cd] %@) OR \
                                          (title contains[cd] %@)", searchKey, searchKey];
        [fetchRequest setPredicate:predicateTemplate];
    } else {
        [fetchRequest setPredicate:nil];
    }
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    //[fetchRequest setFetchLimit:80];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
        
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}

    
    [searchBar resignFirstResponder]; // if you want the keyboard to go away
    // reload the table view
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBarSource {
    searchKey = nil;
    [searchBarSource resignFirstResponder]; // if you want the keyboard to go away
}

@end
