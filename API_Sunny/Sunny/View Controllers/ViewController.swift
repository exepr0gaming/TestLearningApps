import UIKit
import CoreLocation

class ViewController: UIViewController {
	
	@IBOutlet weak var weatherIconImageView: UIImageView!
	@IBOutlet weak var cityLabel: UILabel!
	@IBOutlet weak var temperatureLabel: UILabel!
	@IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
	
	var networkManager = NetworkManager()
	lazy var locationManager: CLLocationManager = {
		let lm = CLLocationManager()
		lm.delegate = self
		lm.desiredAccuracy = kCLLocationAccuracyKilometer
		lm.requestWhenInUseAuthorization()
		return lm
	}()
	
	@IBAction func searchPressed(_ sender: UIButton) {
		self.presentSearchAlertController(withTitle: "Enter city name", message: nil, style: .alert) { [unowned self] city in // [unowned self] гарантирует, что на момент завершения работы кложера - self будет существовать
			self.networkManager.fetchCurrentWeather(fromRequestType: .cityName(city: city))
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		networkManager.onCompletion = { [weak self] currentWeather in
			guard let self = self else { return }
			self.updateWeatherUI(withWeather: currentWeather)
		}
		if CLLocationManager.locationServicesEnabled() { // если включена геопозиция, то
			locationManager.requestLocation()
			// startUpdatingLocation() метод для отслеживания перемещения пользователя и stopUpd...
			// если геопозиция выключена - нужен alert и показываем, как включить
		}
		
	}

	func updateWeatherUI(withWeather currentWeather: CurrentWeather) {
		DispatchQueue.main.async {
			self.weatherIconImageView.image = UIImage(named: currentWeather.weatherImageName)
			self.cityLabel.text = currentWeather.name
			self.temperatureLabel.text = currentWeather.temperature
			self.feelsLikeTemperatureLabel.text = currentWeather.feelsLikeTemperature
		}
	}
}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.last else { return }
		let latitude = location.coordinate.latitude
		let longitude = location.coordinate.longitude
		
		networkManager.fetchCurrentWeather(fromRequestType: .coordinate(latitude: latitude, longitude: longitude))
	}
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error.localizedDescription)
	}
}

