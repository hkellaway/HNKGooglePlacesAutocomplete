//
//  HNKGooglePlacesAutocompletePlace.m
//  HNKGooglePlacesAutocomplete
//
// Copyright (c) 2015 Harlan Kellaway
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "HNKGooglePlacesAutocompletePlace.h"
#import "HNKGooglePlacesAutocompletePlaceSubstring.h"
#import "HNKGooglePlacesAutocompletePlaceTerm.h"

#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"

@implementation HNKGooglePlacesAutocompletePlace

- (BOOL)isPlaceType:(HNKGooglePlaceType)placeType
{
    NSArray *allTypes = self.types;

    for (NSNumber *type in allTypes) {
        if (type.integerValue == placeType) {
            return YES;
        }
    }

    return NO;
}

#pragma mark - Protocol conformance

#pragma mark <MTLJSONSerializing>

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
        @"name" : @"description",
        @"substrings" : @"matched_substrings",
        @"placeId" : @"place_id",
        @"terms" : @"terms",
        @"types" : @"types"
    };
}

+ (NSValueTransformer *)substringsJSONTransformer
{
    return
        [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[HNKGooglePlacesAutocompletePlaceSubstring class]];
}

+ (NSValueTransformer *)termsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[HNKGooglePlacesAutocompletePlaceTerm class]];
}

+ (NSValueTransformer *)typesJSONTransformer
{
    NSDictionary *typesDictionary = @{
        @"unknown" : @(HNKGooglePlaceTypeUnknown),
        @"accounting" : @(HNKGooglePlaceTypeAccounting),
        @"administrative_area_level_1" : @(HNKGooglePlaceTypeAdministrativeAreaLevel1),
        @"administrative_area_level_2" : @(HNKGooglePlaceTypeAdministrativeAreaLevel2),
        @"administrative_area_level_3" : @(HNKGooglePlaceTypeAdministrativeAreaLevel3),
        @"administrative_area_level_4" : @(HNKGooglePlaceTypeAdministrativeAreaLevel4),
        @"administrative_area_level_5" : @(HNKGooglePlaceTypeAdministrativeAreaLevel5),
        @"airport" : @(HNKGooglePlaceTypeAirport),
        @"amusement_park" : @(HNKGooglePlaceTypeAmusementPark),
        @"aquarium" : @(HNKGooglePlaceTypeAquarium),
        @"art_gallery" : @(HNKGooglePlaceTypeArtGallery),
        @"atm" : @(HNKGooglePlaceTypeATM),
        @"bakery" : @(HNKGooglePlaceTypeBakery),
        @"bank" : @(HNKGooglePlaceTypeBank),
        @"bar" : @(HNKGooglePlaceTypeBar),
        @"beauty_salon" : @(HNKGooglePlaceTypeBeautySalon),
        @"bicycle_store" : @(HNKGooglePlaceTypeBicycleStore),
        @"book_store" : @(HNKGooglePlaceTypeBookStore),
        @"bowling_alley" : @(HNKGooglePlaceTypeBowlingAlley),
        @"bus_station" : @(HNKGooglePlaceTypeBusStation),
        @"cafe" : @(HNKGooglePlaceTypeCafe),
        @"campground" : @(HNKGooglePlaceTypeCampground),
        @"car_dealer" : @(HNKGooglePlaceTypeCarDealer),
        @"car_rental" : @(HNKGooglePlaceTypeCarRental),
        @"car_repair" : @(HNKGooglePlaceTypeCarRepair),
        @"car_wash" : @(HNKGooglePlaceTypeCarWash),
        @"casino" : @(HNKGooglePlaceTypeCasino),
        @"cemetery" : @(HNKGooglePlaceTypeCemetery),
        @"church" : @(HNKGooglePlaceTypeChurch),
        @"city_hall" : @(HNKGooglePlaceTypeCityHall),
        @"clothing_store" : @(HNKGooglePlaceTypeClothingStore),
        @"colloquial_area" : @(HNKGooglePlaceTypeColloquialArea),
        @"convenience_store" : @(HNKGooglePlaceTypeConvenienceStore),
        @"country" : @(HNKGooglePlaceTypeCountry),
        @"courthouse" : @(HNKGooglePlaceTypeCourthouse),
        @"dentist" : @(HNKGooglePlaceTypeDentist),
        @"department_store" : @(HNKGooglePlaceTypeDepartmentStore),
        @"doctor" : @(HNKGooglePlaceTypeDoctor),
        @"electrician" : @(HNKGooglePlaceTypeElectrician),
        @"electronics_store" : @(HNKGooglePlaceTypeElectronicsStore),
        @"embassy" : @(HNKGooglePlaceTypeEmbassy),
        @"establishment" : @(HNKGooglePlaceTypeEstablishment),
        @"finance" : @(HNKGooglePlaceTypeFinance),
        @"fire_station" : @(HNKGooglePlaceTypeFireStation),
        @"floor" : @(HNKGooglePlaceTypeFloor),
        @"florist" : @(HNKGooglePlaceTypeFlorist),
        @"food" : @(HNKGooglePlaceTypeFood),
        @"funeral_home" : @(HNKGooglePlaceTypeFuneralHome),
        @"furniture_store" : @(HNKGooglePlaceTypeFurnitureStore),
        @"gas_station" : @(HNKGooglePlaceTypeGasStation),
        @"general_contractor" : @(HNKGooglePlaceTypeGeneralContractor),
        @"geocode" : @(HNKGooglePlaceTypeGeocode),
        @"grocery_or_supermarket" : @(HNKGooglePlaceTypeGroceryOrSupermarket),
        @"gym" : @(HNKGooglePlaceTypeGym),
        @"intersection" : @(HNKGooglePlaceTypeIntersection),
        @"hair_care" : @(HNKGooglePlaceTypeHairCare),
        @"hardware_store" : @(HNKGooglePlaceTypeHardwareStore),
        @"health" : @(HNKGooglePlaceTypeHealth),
        @"hindu_temple" : @(HNKGooglePlaceTypeHinduTemple),
        @"home_goods_store" : @(HNKGooglePlaceTypeHomeGoodsStore),
        @"hospital" : @(HNKGooglePlaceTypeHospital),
        @"insurance_agency" : @(HNKGooglePlaceTypeInsuranceAgency),
        @"jewelry_store" : @(HNKGooglePlaceTypeJewelryStore),
        @"laundry" : @(HNKGooglePlaceTypeLaundry),
        @"lawyer" : @(HNKGooglePlaceTypeLawyer),
        @"library" : @(HNKGooglePlaceTypeLibrary),
        @"liquor_store" : @(HNKGooglePlaceTypeLiquorStore),
        @"local_government_office" : @(HNKGooglePlaceTypeLocalGovernmentOffice),
        @"locality" : @(HNKGooglePlaceTypeLocality),
        @"locksmith" : @(HNKGooglePlaceTypeLocksmith),
        @"lodging" : @(HNKGooglePlaceTypeLodging),
        @"meal_delivery" : @(HNKGooglePlaceTypeMealDelivery),
        @"meal_takeaway" : @(HNKGooglePlaceTypeMealTakeaway),
        @"mosque" : @(HNKGooglePlaceTypeMosque),
        @"movie_rental" : @(HNKGooglePlaceTypeMovieRental),
        @"movie_theater" : @(HNKGooglePlaceTypeMovieTheater),
        @"moving_company" : @(HNKGooglePlaceTypeMovingCompany),
        @"museum" : @(HNKGooglePlaceTypeMuseum),
        @"natural_feature" : @(HNKGooglePlaceTypeNaturalFeature),
        @"neighborhood" : @(HNKGooglePlaceTypeNeighborhood),
        @"night_club" : @(HNKGooglePlaceTypeNightClub),
        @"painter" : @(HNKGooglePlaceTypePainter),
        @"park" : @(HNKGooglePlaceTypePark),
        @"parking" : @(HNKGooglePlaceTypeParking),
        @"pet_store" : @(HNKGooglePlaceTypePetStore),
        @"pharmacy" : @(HNKGooglePlaceTypePharmacy),
        @"physiotherapist" : @(HNKGooglePlaceTypePhysiotherapist),
        @"place_of_worship" : @(HNKGooglePlaceTypePlaceOfWorship),
        @"plumber" : @(HNKGooglePlaceTypePlumber),
        @"political" : @(HNKGooglePlaceTypePolitical),
        @"point_of_interest" : @(HNKGooglePlaceTypePointOfInterest),
        @"police" : @(HNKGooglePlaceTypePolice),
        @"post_box" : @(HNKGooglePlaceTypePostBox),
        @"postal_code" : @(HNKGooglePlaceTypePostalCode),
        @"postal_code_prefix" : @(HNKGooglePlaceTypePostalCodePrefix),
        @"postal_code_suffix" : @(HNKGooglePlaceTypePostalCodeSuffix),
        @"postal_town" : @(HNKGooglePlaceTypePostalTown),
        @"premise" : @(HNKGooglePlaceTypePremise),
        @"post_office" : @(HNKGooglePlaceTypePostOffice),
        @"real_estate_agency" : @(HNKGooglePlaceTypeRealEstateAgency),
        @"restaurant" : @(HNKGooglePlaceTypeRestaurant),
        @"roofing_contractor" : @(HNKGooglePlaceTypeRoofingContractor),
        @"room" : @(HNKGooglePlaceTypeRoom),
        @"route" : @(HNKGooglePlaceTypeRoute),
        @"rv_park" : @(HNKGooglePlaceTypeRVPark),
        @"school" : @(HNKGooglePlaceTypeSchool),
        @"shoe_store" : @(HNKGooglePlaceTypeShoeStore),
        @"shopping_mall" : @(HNKGooglePlaceTypeShoppingMall),
        @"spa" : @(HNKGooglePlaceTypeSpa),
        @"stadium" : @(HNKGooglePlaceTypeStadium),
        @"storage" : @(HNKGooglePlaceTypeStorage),
        @"store" : @(HNKGooglePlaceTypeStore),
        @"street_address" : @(HNKGooglePlaceTypeStreetAddress),
        @"street_number" : @(HNKGooglePlaceTypeStreetNumber),
        @"sublocality" : @(HNKGooglePlaceTypeSublocality),
        @"sublocality_level_1" : @(HNKGooglePlaceTypeSublocalityLevel1),
        @"sublocality_level_2" : @(HNKGooglePlaceTypeSublocalityLevel2),
        @"sublocality_level_3" : @(HNKGooglePlaceTypeSublocalityLevel3),
        @"sublocality_level_4" : @(HNKGooglePlaceTypeSublocalityLevel4),
        @"sublocality_level_5" : @(HNKGooglePlaceTypeSublocalityLevel5),
        @"subpremise" : @(HNKGooglePlaceTypeSubpremise),
        @"subway_station" : @(HNKGooglePlaceTypeSubwayStation),
        @"synagogue" : @(HNKGooglePlaceTypeSynagogue),
        @"taxi_stand" : @(HNKGooglePlaceTypeTaxiStand),
        @"train_station" : @(HNKGooglePlaceTypeTrainStation),
        @"transit_station" : @(HNKGooglePlaceTypeTransitStation),
        @"travel_agency" : @(HNKGooglePlaceTypeTravelAgency),
        @"university" : @(HNKGooglePlaceTypeUniversity),
        @"veterinary_care" : @(HNKGooglePlaceTypeVeterinaryCare),
        @"zoo" : @(HNKGooglePlaceTypeZoo)
    };

    return [MTLValueTransformer transformerWithBlock:^(NSArray *types) {
        NSMutableArray *typesToReturn = [NSMutableArray arrayWithCapacity:[types count]];
        for (NSString *type in types) {
            if ([typesDictionary objectForKey:type]) {
                [typesToReturn addObject:typesDictionary[type]];
            } else {
                [typesToReturn addObject:typesDictionary[@"unknown"]];
            }
        }
        return [typesToReturn copy];
    }];
}

@end
