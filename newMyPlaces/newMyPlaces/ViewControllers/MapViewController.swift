//
//  MapViewController.swift
//  newMyPlaces
//
//  Created by admin on 13.04.2021.
//

import UIKit
import MapKit
import CoreLocation // для определения местоположения пользователя

protocol MapViewControllerDelegate {
	func getAddress(_ address: String?)
}

class MapViewController: UIViewController {
	
	let mapManager = MapManager()
	var mapViewControllerDelegate: MapViewControllerDelegate?
	var place = Place()
	let annotationIdentifier = "annotationIdentifier"
	var incomeSegueIdentifier = ""
	
	
	var previousLocation: CLLocation? {
		didSet {
			mapManager.startTrackingUserLocation(
				for: mapView,
				and: previousLocation) { (currentLocation) in
				self.previousLocation = currentLocation
				DispatchQueue.main.asyncAfter(deadline: .now() + 10 ) {
					self.mapManager.showUserLocation(mapView: self.mapView)
				}
			}
		}
	}
	
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var mapPinImage: UIImageView!
	@IBOutlet weak var addressLabel: UILabel!
	@IBOutlet weak var doneButton: UIButton!
	@IBOutlet weak var goRouteButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		mapView.delegate = self
		setupMapView()
	}
	
	@IBAction func doneButPressed() {
		mapViewControllerDelegate?.getAddress(addressLabel.text)
		dismiss(animated: true)
	}
	@IBAction func goRouteButtonPressed() {
		mapManager.getDirections(for: mapView) { (location) in
			self.previousLocation = location
		}
	}
	
	@IBAction func centerViewUserLocation() {
		mapManager.showUserLocation(mapView: mapView)
	}
	@IBAction func closeMap() {
		dismiss(animated: true)
	}
	
	private func setupMapView() {
		goRouteButton.isHidden = true
		
		mapManager.checkLocationgServices(mapView: mapView, segueIdentifier: incomeSegueIdentifier) {
			mapManager.locationManageer.delegate = self
		}
		
		if incomeSegueIdentifier == "showPlace" {
			mapManager.setupPlacemark(place: place, mapView: mapView)
			mapPinImage.isHidden = true
			doneButton.isHidden = true
			addressLabel.isHidden = true
			addressLabel.text = ""
			goRouteButton.isHidden = false
		}
	}
}

extension MapViewController: MKMapViewDelegate {
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		// если маркером на карте является текущее местоположение пользователя, то не создавать никакой аннотации
		guard !(annotation is MKUserLocation) else { return nil }
		var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView // приводим к типу MKPinAnnotationView, чтобы появился маркер под баннером
		if annotationView == nil {
			annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
			// отображение аннотации в виде баннера
			annotationView?.canShowCallout = true
		}
		
		if let imageData = place.imageData {
			let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
			imageView.layer.cornerRadius = 10
			imageView.clipsToBounds = true
			imageView.image = UIImage(data: imageData)
			annotationView?.rightCalloutAccessoryView = imageView // помещаем в баннер с правой стороны
		}
		return annotationView
	}
	
	func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
		let center = mapManager.getCenterLocation(for: mapView)
		let geocoder = CLGeocoder()
		
		if incomeSegueIdentifier == "showPlace" && previousLocation != nil {
			DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
				self.mapManager.showUserLocation(mapView: mapView)
			}
		}
		
		geocoder.cancelGeocode()
		
		geocoder.reverseGeocodeLocation(center) { (placemarks, error) in
			if let error = error {
				print(error)
				return
			}
			
			guard let placemarks = placemarks else { return }
			let placemark = placemarks.first
			let streetName = placemark?.thoroughfare
			let buildNumber = placemark?.subThoroughfare
			
			DispatchQueue.main.async {
				if streetName != nil && buildNumber != nil {
					self.addressLabel.text = "\(streetName!), \(buildNumber!)"
				} else if streetName != nil {
					self.addressLabel.text = "\(streetName!)"
				} else {
					self.addressLabel.text = ""
				}
			}
		}
	}
	
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
		renderer.strokeColor = .blue
		
		return renderer
	}

} // extension MapViewController: MKMapViewDelegate

// отслеживать в реальном времени изменение статуса  пользователя
extension MapViewController: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		mapManager.checkLocationAuthorization(mapView: mapView, segueIdentifier: incomeSegueIdentifier)
	}
}

