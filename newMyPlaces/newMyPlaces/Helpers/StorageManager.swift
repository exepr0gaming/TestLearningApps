//
//  StorageManager.swift
//  newMyPlaces
//
//  Created by admin on 02.04.2021.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
	//	var places: Place
	//	init(places: Place) {
	//		self.places = places
	//	}
	
	static func saveObject(_ place: Place) {
		try! realm.write {
			realm.add(place)
		}
	}
	static func deleteObjecat(_ place: Place) {
		try! realm.write {
			realm.delete(place)
		}
	}
}
