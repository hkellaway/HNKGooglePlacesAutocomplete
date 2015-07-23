//
//  HNKGooglePlacesAutocompletePlace.h
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

#import "HNKGooglePlacesAutocompleteModel.h"

/**
 *  Place type groups that can be used to filter autocomplete
 *  search results
 */
typedef NS_ENUM(NSInteger, HNKGooglePlaceTypeAutocompleteFilter) {
    /**
     *  All results
     */
    HNKGooglePlaceTypeAutocompleteFilterAll = 0,
    /**
     *  Only geocoding results with a precise address
     */
    HNKGooglePlaceTypeAutocompleteFilterAddress,
    /**
     *  Results that match Locality or Administrative
     *  Area Level 1
     */
    HNKGooglePlaceTypeAutocompleteFilterCity,
    /**
     *  Only business results
     */
    HNKGooglePlaceTypeAutocompleteFilterEstablishment,
    /**
     *  Only geocoding results, rather than business results
     *
     *  Note: Generally, used to disambiguate results where
     *  the location specified may be indeterminate
     */
    HNKGooglePlaceTypeAutocompleteFilterGeocode,
    /**
     *  Results matching the following types: Locality,
     *  Sub-locality, Postal code, Country, Administrative
     *  Area Level 1, Administrative Area Level 2
     */
    HNKGooglePlaceTypeAutocompleteFilterRegion
};

/**
 *  All possible Place tyles
 */
typedef NS_ENUM(NSInteger, HNKGooglePlaceType){
    /**
     *  Unknown
     */
    HNKGooglePlaceTypeUnknown = 0,
    /**
     *  Accounting
     */
    HNKGooglePlaceTypeAccounting,
    /**
     *  Administrative Area Level 1
     */
    HNKGooglePlaceTypeAdministrativeAreaLevel1,
    /**
     *  Administrative Area Level 2
     */
    HNKGooglePlaceTypeAdministrativeAreaLevel2,
    /**
     *  Administrative Area Level 3
     */
    HNKGooglePlaceTypeAdministrativeAreaLevel3,
    /**
     *  Administrative Area Level 4
     */
    HNKGooglePlaceTypeAdministrativeAreaLevel4,
    /**
     *  Administrative Area Level 5
     */
    HNKGooglePlaceTypeAdministrativeAreaLevel5,
    /**
     *  Airport
     */
    HNKGooglePlaceTypeAirport,
    /**
     *  Amusement Park
     */
    HNKGooglePlaceTypeAmusementPark,
    /**
     *  Aquarium
     */
    HNKGooglePlaceTypeAquarium,
    /**
     *  Art Gallery
     */
    HNKGooglePlaceTypeArtGallery,
    /**
     *  ATM
     */
    HNKGooglePlaceTypeATM,
    /**
     *  Bakery
     */
    HNKGooglePlaceTypeBakery,
    /**
     *  Bank
     */
    HNKGooglePlaceTypeBank,
    /**
     *  Bar
     */
    HNKGooglePlaceTypeBar,
    /**
     *  Beauty Salon
     */
    HNKGooglePlaceTypeBeautySalon,
    /**
     *  Bicycle Store
     */
    HNKGooglePlaceTypeBicycleStore,
    /**
     *  Book Store
     */
    HNKGooglePlaceTypeBookStore,
    /**
     *  Bowling Alley
     */
    HNKGooglePlaceTypeBowlingAlley,
    /**
     *  Bus Station
     */
    HNKGooglePlaceTypeBusStation,
    /**
     *  Cafe
     */
    HNKGooglePlaceTypeCafe,
    /**
     *  Camground
     */
    HNKGooglePlaceTypeCampground,
    /**
     *  Car Dealer
     */
    HNKGooglePlaceTypeCarDealer,
    /**
     *  Car Rental
     */
    HNKGooglePlaceTypeCarRental,
    /**
     *  Car Repair
     */
    HNKGooglePlaceTypeCarRepair,
    /**
     *  Car Wash
     */
    HNKGooglePlaceTypeCarWash,
    /**
     *  Casino
     */
    HNKGooglePlaceTypeCasino,
    /**
     *  Cemetery
     */
    HNKGooglePlaceTypeCemetery,
    /**
     *  Church
     */
    HNKGooglePlaceTypeChurch,
    /**
     *  City Hall
     */
    HNKGooglePlaceTypeCityHall,
    /**
     *  Clothing Store
     */
    HNKGooglePlaceTypeClothingStore,
    /**
     *  Colloquial Area
     */
    HNKGooglePlaceTypeColloquialArea,
    /**
     *  Convenience Store
     */
    HNKGooglePlaceTypeConvenienceStore,
    /**
     *  Country
     */
    HNKGooglePlaceTypeCountry,
    /**
     *  Courthouse
     */
    HNKGooglePlaceTypeCourthouse,
    /**
     *  Dentist
     */
    HNKGooglePlaceTypeDentist,
    /**
     *  Department Store
     */
    HNKGooglePlaceTypeDepartmentStore,
    /**
     *  Doctor
     */
    HNKGooglePlaceTypeDoctor,
    /**
     *  Electrician
     */
    HNKGooglePlaceTypeElectrician,
    /**
     *  Electronics Store
     */
    HNKGooglePlaceTypeElectronicsStore,
    /**
     *  Embassy
     */
    HNKGooglePlaceTypeEmbassy,
    /**
     *  Establishment
     */
    HNKGooglePlaceTypeEstablishment,
    /**
     *  Finance
     */
    HNKGooglePlaceTypeFinance,
    /**
     *  Fire Station
     */
    HNKGooglePlaceTypeFireStation,
    /**
     *  Floor
     */
    HNKGooglePlaceTypeFloor,
    /**
     *  Florist
     */
    HNKGooglePlaceTypeFlorist,
    /**
     *  Food
     */
    HNKGooglePlaceTypeFood,
    /**
     *  Funeral Home
     */
    HNKGooglePlaceTypeFuneralHome,
    /**
     *  Furniture Store
     */
    HNKGooglePlaceTypeFurnitureStore,
    /**
     *  Gas Station
     */
    HNKGooglePlaceTypeGasStation,
    /**
     *  General Contractor
     */
    HNKGooglePlaceTypeGeneralContractor,
    /**
     *  Geocode
     */
    HNKGooglePlaceTypeGeocode,
    /**
     *  Grocery or Supermarket
     */
    HNKGooglePlaceTypeGroceryOrSupermarket,
    /**
     *  Gym
     */
    HNKGooglePlaceTypeGym,
    /**
     *  Hair Care
     */
    HNKGooglePlaceTypeHairCare,
    /**
     *  Hardware Store
     */
    HNKGooglePlaceTypeHardwareStore,
    /**
     *  Health
     */
    HNKGooglePlaceTypeHealth,
    /**
     *  Hindu Temple
     */
    HNKGooglePlaceTypeHinduTemple,
    /**
     *  Goods Store
     */
    HNKGooglePlaceTypeHomeGoodsStore,
    /**
     *  Hospital
     */
    HNKGooglePlaceTypeHospital,
    /**
     *  Insurance Agency
     */
    HNKGooglePlaceTypeInsuranceAgency,
    /**
     *  Intersection
     */
    HNKGooglePlaceTypeIntersection,
    /**
     *  Jewelry Store
     */
    HNKGooglePlaceTypeJewelryStore,
    /**
     *  Laundry
     */
    HNKGooglePlaceTypeLaundry,
    /**
     *  Lawyer
     */
    HNKGooglePlaceTypeLawyer,
    /**
     *  Library
     */
    HNKGooglePlaceTypeLibrary,
    /**
     *  Liquor Store
     */
    HNKGooglePlaceTypeLiquorStore,
    /**
     *  Government Office
     */
    HNKGooglePlaceTypeLocalGovernmentOffice,
    /**
     *  Locality
     */
    HNKGooglePlaceTypeLocality,
    /**
     *  Locksmith
     */
    HNKGooglePlaceTypeLocksmith,
    /**
     *  Lodging
     */
    HNKGooglePlaceTypeLodging,
    /**
     *  Meal Delivery
     */
    HNKGooglePlaceTypeMealDelivery,
    /**
     *  Meal Takeaway
     */
    HNKGooglePlaceTypeMealTakeaway,
    /**
     *  Mosque
     */
    HNKGooglePlaceTypeMosque,
    /**
     *  Movie Rental
     */
    HNKGooglePlaceTypeMovieRental,
    /**
     *  Movie Theatre
     */
    HNKGooglePlaceTypeMovieTheater,
    /**
     *  Moving Company
     */
    HNKGooglePlaceTypeMovingCompany,
    /**
     *  Museum
     */
    HNKGooglePlaceTypeMuseum,
    /**
     *  Natural Feature
     */
    HNKGooglePlaceTypeNaturalFeature,
    /**
     *  Neighborhood
     */
    HNKGooglePlaceTypeNeighborhood,
    /**
     *  Night Club
     */
    HNKGooglePlaceTypeNightClub,
    /**
     *  Painter
     */
    HNKGooglePlaceTypePainter,
    /**
     *  Park
     */
    HNKGooglePlaceTypePark,
    /**
     *  Parking
     */
    HNKGooglePlaceTypeParking,
    /**
     *  Pet Store
     */
    HNKGooglePlaceTypePetStore,
    /**
     *  Pharmacy
     */
    HNKGooglePlaceTypePharmacy,
    /**
     *  Physiotherapist
     */
    HNKGooglePlaceTypePhysiotherapist,
    /**
     *  Place of Wordship
     */
    HNKGooglePlaceTypePlaceOfWorship,
    /**
     *  Plumber
     */
    HNKGooglePlaceTypePlumber,
    /**
     *  Point of Interest
     */
    HNKGooglePlaceTypePointOfInterest,
    /**
     *  Police
     */
    HNKGooglePlaceTypePolice,
    /**
     *  Political
     */
    HNKGooglePlaceTypePolitical,
    /**
     *  Postal Code
     */
    HNKGooglePlaceTypePostalCode,
    /**
     *  Postal Code Prefix
     */
    HNKGooglePlaceTypePostalCodePrefix,
    /**
     *  Postal Code Suffix
     */
    HNKGooglePlaceTypePostalCodeSuffix,
    /**
     *  Postal Town
     */
    HNKGooglePlaceTypePostalTown,
    /**
     *  Post Box
     */
    HNKGooglePlaceTypePostBox,
    /**
     *  Post Office
     */
    HNKGooglePlaceTypePostOffice,
    /**
     *  Premise
     */
    HNKGooglePlaceTypePremise,
    /**
     *  Real Estate Agency
     */
    HNKGooglePlaceTypeRealEstateAgency,
    /**
     *  Restaurant
     */
    HNKGooglePlaceTypeRestaurant,
    /**
     *  Roofing Contractor
     */
    HNKGooglePlaceTypeRoofingContractor,
    /**
     *  Room
     */
    HNKGooglePlaceTypeRoom,
    /**
     *  Route
     */
    HNKGooglePlaceTypeRoute,
    /**
     *  RV Park
     */
    HNKGooglePlaceTypeRVPark,
    /**
     *  School
     */
    HNKGooglePlaceTypeSchool,
    /**
     *  Shoe Store
     */
    HNKGooglePlaceTypeShoeStore,
    /**
     *  Shopping Mall
     */
    HNKGooglePlaceTypeShoppingMall,
    /**
     *  Spa
     */
    HNKGooglePlaceTypeSpa,
    /**
     *  Stadium
     */
    HNKGooglePlaceTypeStadium,
    /**
     *  Storage
     */
    HNKGooglePlaceTypeStorage,
    /**
     *  Store
     */
    HNKGooglePlaceTypeStore,
    /**
     *  Street Address
     */
    HNKGooglePlaceTypeStreetAddress,
    /**
     *  Street Number
     */
    HNKGooglePlaceTypeStreetNumber,
    /**
     *  Sublocality
     */
    HNKGooglePlaceTypeSublocality,
    /**
     *  Sublocality Level 1
     */
    HNKGooglePlaceTypeSublocalityLevel1,
    /**
     *  Sublocality Level 2
     */
    HNKGooglePlaceTypeSublocalityLevel2,
    /**
     *  Sublocality Level 3
     */
    HNKGooglePlaceTypeSublocalityLevel3,
    /**
     *  Sublocality Level 4
     */
    HNKGooglePlaceTypeSublocalityLevel4,
    /**
     *  Sublocality Level 5
     */
    HNKGooglePlaceTypeSublocalityLevel5,
    /**
     *  Subpremise
     */
    HNKGooglePlaceTypeSubpremise,
    /**
     *  Subway Station
     */
    HNKGooglePlaceTypeSubwayStation,
    /**
     *  Synagogue
     */
    HNKGooglePlaceTypeSynagogue,
    /**
     *  Taxi Stand
     */
    HNKGooglePlaceTypeTaxiStand,
    /**
     *  Train Station
     */
    HNKGooglePlaceTypeTrainStation,
    /**
     *  Transit Station
     */
    HNKGooglePlaceTypeTransitStation,
    /**
     *  Travel Agency
     */
    HNKGooglePlaceTypeTravelAgency,
    /**
     *  University
     */
    HNKGooglePlaceTypeUniversity,
    /**
     *  Veterinary Care
     */
    HNKGooglePlaceTypeVeterinaryCare,
    /**
     *  Zoo
     */
    HNKGooglePlaceTypeZoo
};

/**
 *  Place prediction returned from search query
 */
@interface HNKGooglePlacesAutocompletePlace : HNKGooglePlacesAutocompleteModel

/**
 *  Human-readable name for the returned result
 *
 *  Note: For establishment type results, this is usually the business name
 */
@property (nonatomic, copy, readonly) NSString *name;

/**
 *  Collection of Substrings that describe the location of the entered term in
 *  the prediction result text, so that the term can be highlighted if desired
 */
@property (nonatomic, strong, readonly) NSArray *substrings;

/**
 *  A textual identifier that uniquely identifies a place
 */
@property (nonatomic, copy, readonly) NSString *placeId;

/**
 *  A collection of Terms identifying each section of the returned description
 */
@property (nonatomic, strong, readonly) NSArray *terms;

/**
 *  A collection of NSNumbers whose integerValues corresponse to
 *  HNKGooglePlaceTypes
 */
@property (nonatomic, strong, readonly) NSArray *types;

/**
 *  Returns whether the provided placeType is included in this Place's types
 */
- (BOOL)isPlaceType:(HNKGooglePlaceType)placeType;

@end
