//
//  PlaceModel.swift
//  newMyPlaces
//
//  Created by admin on 25.03.2021.
//

import RealmSwift

class Place: Object {
	@objc dynamic var name = ""
	@objc dynamic var location: String?
	@objc dynamic var type: String?
	@objc dynamic var imageData: Data?
	@objc dynamic var date = Date()
	@objc dynamic var rating = 0.0
	
	// convenience предназначен для того, чтобы полностью иниализировать все свойства класса
	convenience init(name: String, location: String?, type: String?, imageData: Data?, rating: Double) {
		self.init() // инициализация всех свойст значениями по умолчанию
		self.name = name
		self.location = location
		self.type = type
		self.imageData = imageData
		self.rating = rating
	}
	
	// !!! временные данные для сохранения в базу !!!
	// static свойств и функции getPlaces нужны? чтобы можно было напрямую к ним обратится
//	let restaurantNames = [
//			"Burger Heroes", "Kitchen", "Bonsai", "Дастархан","Индокитай", "X.O", "Балкан Гриль", "Sherlock Holmes",
//			"Speak Easy", "Morris Pub", "Вкусные истории", "Классик", "Love&Life", "Шок", "Бочка"
//	]
	
	// !!! временные данные для сохранения в базу !!!
	/*
	func savePlaces() {
		
		for place in restaurantNames {
			let image = UIImage(named: place)
			guard let imageData = image?.pngData() else { return } // конвертируем image in data
			let newPlace = Place()
			newPlace.name = place
			newPlace.location = "Подольск"
			newPlace.type = "Restaurant"
			newPlace.imageData = imageData
			
			StorageManager.saveObject(newPlace)
		}
	}*/
}
