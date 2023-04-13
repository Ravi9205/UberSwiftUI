//
//  LocationSearchViewModel.swift
//  UberSwiftUI
//
//  Created by Ravi Dwivedi on 05/01/23.
//

import Foundation
import MapKit

class LocationSearchViewModel:NSObject, ObservableObject{
    
    @Published  var results = [MKLocalSearchCompletion]()
    @Published var selectedUberLocation:UberLocation?
   
    @Published var pickUpTime:String?
    @Published var dropOffTime:String?
    
    
    private let searchCompleter = MKLocalSearchCompleter()
    var queryFragment:String = "" {
        
        didSet
        {
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    var userLocation:CLLocationCoordinate2D?
    
    
    override init(){
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    
    
    func seletLocation(_ localSearch:MKLocalSearchCompletion){
        locationSearch(forLocalSearchCompletion: localSearch) { response, error in
            
            if let error = error {
                print("failed to get the selected location error:\(error.localizedDescription)")
                return
            }
            guard let items = response?.mapItems.first else {
                return
            }
            let coordinate = items.placemark.coordinate
            self.selectedUberLocation = UberLocation(title: localSearch.title, coordinate: coordinate)
            //print("coordinates = \(coordinate)")
            self.selectedUberLocation?.coordinate = coordinate
        }
    }
    
    func locationSearch(forLocalSearchCompletion localSearch:MKLocalSearchCompletion,completion:@escaping MKLocalSearch.CompletionHandler){
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: completion)
    }
    
    func computeRidePrice(forType type:RideType) -> Double{
        
        guard let destination = self.selectedUberLocation?.coordinate else{ return 0.0}
        guard let sourcelocation = userLocation else {
            return 0.0
        }
        
        let userLocation = CLLocation(latitude: sourcelocation.latitude,
                                      longitude: sourcelocation.longitude)
        
        let destinationLocation = CLLocation(latitude: destination.latitude,
                                             longitude: destination.longitude)
        
        let tripDistanceInMeters = userLocation.distance(from: destinationLocation)
        return type.computePrice(for: tripDistanceInMeters)
    }
    
    //MARK:- Func to generate destination Routes
    func getDestinationRoute(from userLocation:CLLocationCoordinate2D,to destination: CLLocationCoordinate2D,completion: @escaping (MKRoute) -> Void){
        
        let userPlaceMark = MKPlacemark(coordinate: userLocation)
        let destinationPlaceMark = MKPlacemark(coordinate: destination)
        let request = MKDirections.Request()
        
        request.source = MKMapItem(placemark: userPlaceMark)
        request.destination = MKMapItem(placemark: destinationPlaceMark)
        let direction = MKDirections(request: request)
        
        direction.calculate { response, error in
            
            if let error = error {
                print("faild to get directions \(error.localizedDescription)")
                return
            }
            guard let route = response?.routes.first else { return }
            self.configurePickUpAndDroppOffTime(with: route.expectedTravelTime)
            completion(route)
            
        }
        
        
    }
    
    func configurePickUpAndDroppOffTime(with expectedTravelTime:Double){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        pickUpTime = dateFormatter.string(from: Date())
        dropOffTime = dateFormatter.string(from: Date() + expectedTravelTime)
    }
    
}


//MARK:- MKLocalSearchCompleterDelegate

extension LocationSearchViewModel:MKLocalSearchCompleterDelegate{
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
