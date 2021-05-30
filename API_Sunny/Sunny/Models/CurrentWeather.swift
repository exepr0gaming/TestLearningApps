import Foundation

struct CurrentWeather {
	let name: String
	
	let temperature: String
	let feelsLikeTemperature: String
	
	private let weatherImageId: Int
	var weatherImageName: String {
		switch weatherImageId {
			case 200...232: return "11d"
			case 300...321: return "09d"
			case 500...531: return "10d"
			case 600...622: return "13d"
			case 701...781: return "50d"
			case 800: return "01d" // если день то 01d, если ночь то 01n
			case 801...804: return "02d" // все разные, как и в 500, нужно допиливать https://openweathermap.org/weather-conditions#Icon-list
			default:
				return "01d"
		}
	}
	let description: String
	
	init?(currentWeatherData: CurrentWeatherData) {
		name = currentWeatherData.name
		temperature = String(format: "%.1f", currentWeatherData.main.temp)
		feelsLikeTemperature = String(format: "%.1f", currentWeatherData.main.feelsLike)
		weatherImageId = currentWeatherData.weather.first!.id
		description = currentWeatherData.weather.description
	}
}
