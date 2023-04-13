//
//  UberMapView.swift
//  UberSwiftUI
//
//  Created by Ravi Dwivedi on 05/01/23.
//

import Foundation
import SwiftUI
import MapKit


struct UbserMapView: UIViewRepresentable{
    
    
    let mapView = MKMapView()
    
    let locationManager = LocationManager.shared
    @Binding var mapState:MapViewState
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        return mapView
    }
    
    //MARK:- Updating the Map State
    func updateUIView(_ uiView: UIViewType, context: Context){
        print("Map State = \(mapState)")
        switch mapState {
        case .noInput:
            context.coordinator.clearMapView()
            break
        case .searchingForLocation:
            break
        case .locationSelected:
            if let coordinates = locationViewModel.selectedUberLocation?.coordinate {
                context.coordinator.addAndSelectAnnotation(withCoordinates: coordinates)
                context.coordinator.configurePollylines(withDestinationCoordinates: coordinates)
            }
            break
        case.pollyLineAdded:
            break
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
    
}

extension UbserMapView {
    
    class MapCoordinator: NSObject , MKMapViewDelegate{
        
        //MARK:-  Properties
        let parent:UbserMapView
        
        var userLocationCoordinate:CLLocationCoordinate2D?
        
        var currentRegion:MKCoordinateRegion?
        
        
        //MARK:- Life Cycle
        
        init(parent:UbserMapView) {
            self.parent = parent
            super.init()
        }
        
        //MARK:- MKMapDelegate
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userLocationCoordinate = userLocation.coordinate
            let region = MKCoordinateRegion(center:
                                                CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,
                                                                       longitude: userLocation.coordinate.longitude),
                                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            
            self.currentRegion = region
            parent.mapView.setRegion(region, animated: true)
            
        }
        
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            
            let pollyline = MKPolylineRenderer(overlay: overlay)
            pollyline.strokeColor = .systemBlue
            pollyline.lineWidth = 6
            return pollyline
        }
        
        //MARK:- Helpers functions
        
        //MARK:- Function for adding Annotation Pin using search location coordinates
        func addAndSelectAnnotation(withCoordinates coordinate:CLLocationCoordinate2D){
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            parent.mapView.addAnnotation(annotation)
            parent.mapView.selectAnnotation(annotation, animated: true)
            
        }
        
        
        //MARK:- Generating Polly lines in between source to destinations
        func configurePollylines(withDestinationCoordinates coordinate:CLLocationCoordinate2D){
            
            guard let userLocationCoordinate = self.userLocationCoordinate else {
                return
            }
            
            parent.locationViewModel.getDestinationRoute(from: userLocationCoordinate, to: coordinate) { route in
                self.parent.mapView.addOverlay(route.polyline)
                self.parent.mapState = .pollyLineAdded
                let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect,edgePadding: .init(top: 64, left: 32, bottom: 500, right: 32))
                
                self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
                
            }
        }
        
        // MARK:- function to clear MapView when user decided to deselect source and destination
        
        func clearMapView(){
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)
            
            //MARK:- Recenter user Location into origianl state
            if let currentRegion = currentRegion {
                parent.mapView.setRegion(currentRegion, animated: true)
            }
            
        }
        
    }
}
