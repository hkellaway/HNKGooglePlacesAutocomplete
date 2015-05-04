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

@interface HNKDemoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) MKPointAnnotation *currentlySelectedPlaceAnnotation;
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

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HNKQueryResponsePrediction *place = [self placeAtIndexPath:indexPath];
    [CLPlacemark
        hnk_placemarkFromGooglePlace:place
                              apiKey:self.searchQuery.apiKey
                          completion:^(CLPlacemark *placemark, NSString *addressString, NSError *error)

                                     {
                                         if (error) {
                                             UIAlertView *alert =
                                                 [[UIAlertView alloc] initWithTitle:@"Could not map selected Place"
                                                                            message:error.localizedDescription
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil, nil];
                                             [alert show];
                                         } else if (placemark) {
                                             [self addPlacemarkAnnotationToMap:placemark addressString:addressString];
                                             [self recenterMapToPlacemark:placemark];
                                             // ref: https://github.com/chenyuan/SPGooglePlacesAutocomplete/issues/10
                                             [self.searchDisplayController setActive:NO];
                                             [self.searchDisplayController.searchResultsTableView
                                                 deselectRowAtIndexPath:indexPath
                                                               animated:NO];
                                         }
                                     }];
}

#pragma mark - Helpers

- (HNKQueryResponsePrediction *)placeAtIndexPath:(NSIndexPath *)indexPath
{
    return self.searchResults[indexPath.row];
}

#pragma mark Map Helpers

- (void)addPlacemarkAnnotationToMap:(CLPlacemark *)placemark addressString:(NSString *)address
{
    [self.mapView removeAnnotation:self.currentlySelectedPlaceAnnotation];

    self.currentlySelectedPlaceAnnotation = [[MKPointAnnotation alloc] init];
    self.currentlySelectedPlaceAnnotation.coordinate = placemark.location.coordinate;
    self.currentlySelectedPlaceAnnotation.title = address;

    [self.mapView addAnnotation:self.currentlySelectedPlaceAnnotation];
}

- (void)recenterMapToPlacemark:(CLPlacemark *)placemark
{
    MKCoordinateRegion region;
    MKCoordinateSpan span;

    span.latitudeDelta = 0.02;
    span.longitudeDelta = 0.02;

    region.span = span;
    region.center = placemark.location.coordinate;

    [self.mapView setRegion:region];
}

#pragma mark Search Helpers

- (void)handleSearchError:(NSError *)error
{
    NSLog(@"ERROR = %@", error);
}

@end
