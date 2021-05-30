import Foundation
import CoreLocation

class NetworkManager {
	
	enum RequestType {
		case cityName(city: String)
		case coordinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
	}
	private let apiKey = "f3f24fc7167205308432f31c3a115acf"
	var onCompletion: ((CurrentWeather) -> Void)? // (() -> ) no () -> ()
	
	//static let shared = NetworkManager()
	
	func fetchCurrentWeather(fromRequestType requestType: RequestType) {
		var urlString = ""
		switch requestType {
			case .cityName(let city):
				urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
			case .coordinate(let latitude, let longitude):
				urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
		}
		performRequest(withUrlString: urlString)
	}
	
	fileprivate func performRequest(withUrlString urlString: String) {
		guard let url = URL(string: urlString) else { return }
		
		URLSession.shared.dataTask(with: url) { (data, _, error) in
			if let error = error { print(error); return }
			guard let data = data else { return }
			if let currentWeather = self.parseJson(fromData: data) {
				self.onCompletion?(currentWeather)
			}
		}.resume()
	}
	
	fileprivate func parseJson(fromData data: Data) -> CurrentWeather? {
		let decoder = JSONDecoder()
		do {
			let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
			guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else { return nil }
			return currentWeather
		} catch let error as NSError {
			print(error.localizedDescription)
		}
		return nil
	}
	
}
