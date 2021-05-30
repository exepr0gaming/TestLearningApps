//
//  MapManager.swift
//  newMyPlaces
//
//  Created by admin on 17.04.2021.
//

import UIKit
import MapKit

class MapManager {
	
	let locationManageer = CLLocationManager() // для управления всеми действиями, связанными с метоположением пользователя
	
	private var placeCoordinate2D: CLLocationCoordinate2D?
	private let regionInMeters = 1_000.00
	private var directionsArray: [MKDirections] = []
	
	func setupPlacemark(place: Place, mapView: MKMapView) { // расширяем 2мя свойствами
		guard let location = place.location else { return }
		let geocoder = CLGeocoder() // метод конвертирует/преобразует адрес в координаты
		// определяет местоположение на карте по адресу переданному в location
		geocoder.geocodeAddressString(location) { (placemarks, error) in
			self.myError(error: error)
			guard let placemarks = placemarks else { return } // извлекаем опционал меток
			let placemark = placemarks.first // получаем метку на карте из первого индекса
			// марк это всего ишь координаты на карте, а чтобы описать точку на кот указывает маркер нужно обратится к MKPointAnnotation
			let annotation = MKPointAnnotation() // создаем объект, чтобы присвоить ему параметры
			annotation.title = place.name
			annotation.subtitle = place.type
			// определяем местоположение маркера
			guard let placemarkLocation = placemark?.location else { return }
			annotation.coordinate = placemarkLocation.coordinate
			self.placeCoordinate2D = placemarkLocation.coordinate
			
			// задаем видимую область карты, чтобы на ней были видны все созданные аннотации
			mapView.showAnnotations([annotation], animated: true)
			// выделяем созд аннотацию
			mapView.selectAnnotation(annotation, animated: true)
		}
	}
	
	// проверка включения служб отслеживания местоположения
	func checkLocationgServices(mapView: MKMapView, segueIdentifier: String, closure: ()->()) {
		if CLLocationManager.locationServicesEnabled() { // если службы гео локации доступны
			locationManageer.desiredAccuracy = kCLLocationAccuracyBest // точность определения геопозиции
			checkLocationAuthorization(mapView: mapView, segueIdentifier: segueIdentifier)
			closure()
		} else {
			// alertController рассказывающий как включить службы
			DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // нужна отсрочка появления алерта или загрузка через viewDidAppear, вместо viewDidLoad
				self.showAlert(title: "Location Services are Disabled",
											 message: "To enable it go: Settings -> Privacy -> Location services and turn ON")
			}
		}
	}
	
	// проверка статуса авторизации на разрешение исп геопозиции
	func checkLocationAuthorization(mapView: MKMapView, segueIdentifier: String) {
		switch locationManageer.authorizationStatus {
			case .authorizedWhenInUse: // Пользователь разрешил приложению запускать службы определения местоположения, пока оно используется
				mapView.showsUserLocation = true
				if segueIdentifier == "getAddress" { showUserLocation(mapView: mapView) }
				break
			case .denied: // Пользователь отказался от использования служб определения местоположения для приложения, или они отключены глобально в настройках.
				DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
					self.showAlert(title: "Your location in not available",
												 message: "To give permission go to: Settings -> MyPlaces -> Location")
				}
				break
			case .notDetermined: // Пользователь не решил, может ли приложение использовать службы определения местоположения.
				locationManageer.requestWhenInUseAuthorization()
			case .restricted: // Приложению не разрешено использовать службы определения местоположения.
				// showAlertController
				break
			case .authorizedAlways: // Пользователь разрешил приложению запускать службы определения местоположения в любое время.
				break
			@unknown default:
				print("New case is available")
		}
	}
	
	// фокус карты на местоположении пользователя
	func showUserLocation(mapView: MKMapView) {
		if let location = locationManageer.location?.coordinate {
			let region = MKCoordinateRegion(center: location,
																			latitudinalMeters: regionInMeters,
																			longitudinalMeters: regionInMeters)
			mapView.setRegion(region, animated: true)
		}
	}
	
	// построение маршрута от пользователя до заведения
	func getDirections(for mapView: MKMapView, previousLocation: (CLLocation)->()) {
		guard let location = locationManageer.location?.coordinate else {
			showAlert(title: "Error", message: "Current location is not found")
			return
		}
		
		locationManageer.startUpdatingLocation()
		previousLocation(CLLocation(latitude: location.latitude,
																longitude: location.longitude))
		
		guard let request = createDirectionsRequest(from: location) else {
			showAlert(title: "Error", message: "destination is not found")
			return
		}
		let directions = MKDirections(request: request)
		resetMapView(withNew: directions, mapView: mapView)
		
		directions.calculate { (response, error) in
			self.myError(error: error)
			
			guard let response = response else {
				self.showAlert(title: "Error", message: "Directions is not available")
				return
			}
			
			for route in response.routes {
				mapView.addOverlay(route.polyline)
				mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
				
				let distance = String(format: "%.1f", route.distance / 1000)
				let timeInterval = route.expectedTravelTime
				
				print("Расстояние до места: \(distance) km")
				print("Time in road: \(timeInterval) sec")
			}
		}
	}
	
	// настройка запроса для расчета маршрута
	func createDirectionsRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request? {
		guard let destinationCoordinate = placeCoordinate2D else { return nil }
		let startLocation = MKPlacemark(coordinate: coordinate)
		let destination = MKPlacemark(coordinate: destinationCoordinate)
		
		let request = MKDirections.Request()
		request.source = MKMapItem(placemark: startLocation)
		request.destination = MKMapItem(placemark: destination)
		request.transportType = .automobile
		request.requestsAlternateRoutes = true
		
		return request
	}
	
	// Меняем отображаемую зону области карты в соответствии с перемещением пользователя
	func startTrackingUserLocation(for mapView: MKMapView, and previousLocation: CLLocation?, closure: (_ currentLocation: CLLocation)->()) {
		guard let previousLocation = previousLocation else { return }
		let center = getCenterLocation(for: mapView)
		guard center.distance(from: previousLocation) > 50 else { return }
		
		closure(center)
	}
	
	// сброс всех ранее построенных маршрутов перед построением нового
	func resetMapView(withNew directions: MKDirections, mapView: MKMapView) {
		mapView.removeOverlays(mapView.overlays)
		directionsArray.append(directions)
		let _ = directionsArray.map { $0.cancel() }
		directionsArray.removeAll()
	}
	
	// Определение центра отображаемой области карты
	func getCenterLocation(for mapView:  MKMapView) -> CLLocation {
		let latitude = mapView.centerCoordinate.latitude // широта
		let longitude = mapView.centerCoordinate.longitude
		
		return CLLocation(latitude: latitude, longitude: longitude)
	}
	
	private func showAlert(title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .default)
		alert.addAction(okAction)
		// present не доступен без VC, поэтому нужно создать объект UiWindow и инициализировать его свойства
		let alertWindow = UIWindow(frame: UIScreen.main.bounds) // инициализируем его главным экраном устройства
		alertWindow.rootViewController = UIViewController()
		alertWindow.windowLevel = UIWindow.Level.alert + 1 // опред его поверх остальных окон
		alertWindow.makeKeyAndVisible() // делаем его ключевым и видимым
		alertWindow.rootViewController?.present(alert, animated: true)
		//present(alert, animated: true)
	}
	
	func myError(error: Error?) {
		if let error = error {
			print(error)
			return
		}
	}
	
}
