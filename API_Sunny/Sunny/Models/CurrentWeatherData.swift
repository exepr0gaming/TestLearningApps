import Foundation

struct CurrentWeatherData: Codable {
	let name: String
	let weather: [Weather]
	let main: Main
}

struct Weather: Codable {
	let id: Int
	let description: String
}

struct Main: Codable {
	let temp: Double
	let feelsLike: Double // через enum меняем приходящий ключ
	
	enum CodingKeys: String, CodingKey {
		case temp
		case feelsLike = "feels_like"
	}
}
