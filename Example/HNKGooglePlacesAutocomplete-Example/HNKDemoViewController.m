//
//  HNKDemoViewController.m
//  HNKGooglePlacesAutocomplete-Example
//
//  Created by Harlan Kellaway on 4/26/15.
//  Copyright (c) 2015 Harlan Kellaway. All rights reserved.
//

#import "HNKDemoViewController.h"

#import <CoreLocation/CLPlacemark.h>
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocomplete.h>
#import <MapKit/MapKit.h>

#import "CLPlacemark+HNKAdditions.h"

static NSString *const kHNKDemoSearchResultsCellIdentifier = @"HNKDemoSearchResultsCellIdentifier";

@interface HNKDemoViewController () <UITableViewDataSource>

@property (nonatomic, strong) NSArray *searchResults;
@property (nonatomic, strong) HNKGooglePlacesAutocompleteQuery *searchQuery;
@property (nonatomic, assign) BOOL shouldBeginEditing;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation HNKDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.searchQuery = [HNKGooglePlacesAutocompleteQuery sharedQuery];
    self.shouldBeginEditing = YES;

    void (^HNKDemoQueryCompletion)(NSArray *, NSError *) = ^(NSArray *places, NSError *error) {

        if (error) {

            [self handleSearchError:error];
            return;
        }

        self.searchResults = places;

        [self.searchDisplayController.searchResultsTableView reloadData];

    };

    [self.searchQuery fetchPlacesForSearchQuery:@"Vict" completion:HNKDemoQueryCompletion];
}

#pragma mark - Protocol Conformance

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHNKDemoSearchResultsCellIdentifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:kHNKDemoSearchResultsCellIdentifier];
    }

    cell.textLabel.font = [UIFont fontWithName:@"GillSans" size:16.0];
    cell.textLabel.text = [self placeAtIndexPath:indexPath].predictionDescription;

    return cell;
}

#pragma mark - Helpers

#pragma mark Search Helpers

- (HNKQueryResponsePrediction *)placeAtIndexPath:(NSIndexPath *)indexPath
{
    return self.searchResults[indexPath.row];
}

- (void)handleSearchError:(NSError *)error
{
    NSLog(@"ERROR = %@", error);
}

@end
