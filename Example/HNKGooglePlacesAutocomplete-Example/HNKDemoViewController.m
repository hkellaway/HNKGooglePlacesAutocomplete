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

static NSString *const kHNKDemoMapAnnotationIdentifier = @"HNKDemoMapAnnotationIdentifier";
static NSString *const kHNKDemoSearchResultsCellIdentifier = @"HNKDemoSearchResultsCellIdentifier";

@interface HNKDemoViewController () <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) MKPointAnnotation *selectedPlaceAnnotation;
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

    // TODO: Center to users's location on launch

    // TODO: Provide button to recenter to user's location
}

#pragma mark - Protocol Conformance

#pragma mark MKMapView Delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapViewIn viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (mapViewIn != self.mapView || [annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }

    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)
        [self.mapView dequeueReusableAnnotationViewWithIdentifier:kHNKDemoMapAnnotationIdentifier];

    if (!annotationView) {
        annotationView =
            [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kHNKDemoMapAnnotationIdentifier];
    }

    annotationView.animatesDrop = YES;
    annotationView.canShowCallout = YES;

    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [detailButton addTarget:self
                     action:@selector(annotationDetailButtonPressed:)
           forControlEvents:UIControlEventTouchUpInside];
    annotationView.rightCalloutAccessoryView = detailButton;

    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    // Whenever we've dropped a pin on the map, immediately select it to present
    // its callout bubble.
    [self.mapView selectAnnotation:self.selectedPlaceAnnotation animated:YES];
}

- (void)annotationDetailButtonPressed:(id)sender
{
    NSLog(@"Pin tapped");
}

#pragma mark UISearchDisplayDelegate

- (void)handleSearchForSearchString:(NSString *)searchString
{
    if (![searchString isEqualToString:@""]) {

        // TODO: Add user location to search query
        // self.searchQuery.location = self.mapView.userLocation.coordinate;

        [self.searchQuery fetchPlacesForSearchQuery:searchString
                                         completion:^(NSArray *places, NSError *error) {
                                             if (error) {
                                                 UIAlertView *alert =
                                                     [[UIAlertView alloc] initWithTitle:@"Could not fetch Places"
                                                                                message:error.localizedDescription
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles:nil, nil];
                                                 [alert show];
                                             } else {
                                                 self.searchResults = places;
                                                 [self.searchDisplayController.searchResultsTableView reloadData];
                                             }
                                         }];
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
    shouldReloadTableForSearchString:(NSString *)searchString
{
    [self handleSearchForSearchString:searchString];

    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark -
#pragma mark UISearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (![searchBar isFirstResponder]) {
        // User tapped the 'clear' button.
        self.shouldBeginEditing = NO;
        [self.searchDisplayController setActive:NO];
        [self.mapView removeAnnotation:self.selectedPlaceAnnotation];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if (self.shouldBeginEditing) {

        // Animate in the table view.
        NSTimeInterval animationDuration = 0.3;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        self.searchDisplayController.searchResultsTableView.alpha = 0.75;
        [UIView commitAnimations];

        [self.searchDisplayController.searchBar setShowsCancelButton:YES animated:YES];
    }

    BOOL boolToReturn = self.shouldBeginEditing;
    self.shouldBeginEditing = YES;
    return boolToReturn;
}

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
    cell.textLabel.text = [self placeAtIndexPath:indexPath].name;

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
                                             // ref:
                                             // https://github.com/chenyuan/SPGooglePlacesAutocomplete/issues/10
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
    [self.mapView removeAnnotation:self.selectedPlaceAnnotation];

    self.selectedPlaceAnnotation = [[MKPointAnnotation alloc] init];
    self.selectedPlaceAnnotation.coordinate = placemark.location.coordinate;
    self.selectedPlaceAnnotation.title = address;

    [self.mapView addAnnotation:self.selectedPlaceAnnotation];
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
