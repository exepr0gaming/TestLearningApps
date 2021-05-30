//
//  UserModal.swift
//  ContactsApp(sketch)
//
//  Created by admin on 04.05.2021.
//

import UIKit

class ContactsModel {
	
	enum CornerDirections: Int, Codable {
		case top, all, bottom, nope
	}
	
	struct User: Hashable, Decodable {
		var fullname: String
		var imageString: String
		var firstCharacter: String
		var id: Int
		var direction: CornerDirections?
		
		// дефолтная функция Hashable, которая почему то не вызывается
		func hash(into hasher: inout Hasher) {
			hasher.combine(id) // чтобы компилятор поминал, как сравнивать моих юзеров
		}
	}
	
	enum SectionType: Int { // int нужен, чтобы у каждого кейса появилось стандартное значение rawValue - 0,1,2
		case profile
		case favourites
		case contacts
	}
	
	struct UserCollection: Hashable {
		var type: SectionType
		var header: String?
		var users: [User]
		var id = UUID() // генерирует рандомный не повторяющийся ключ
		
		// дефолтная функция Hashable, которая почему то не вызывается
		func hash(into hasher: inout Hasher) {
			hasher.combine(id) // чтобы компилятор поминал, как сравнивать моих юзеров
		}
	}
	
	var collections: [UserCollection] {
		return _collection
	}
	
	fileprivate var _collection = [UserCollection]()
	
	init() {
		generateCollections()
	}
	
}

extension ContactsModel {
	
	func generateCollections() {
		let profile = User(fullname: "Andrew Kurdin", imageString: "human1", firstCharacter: "A", id: 20)
		let favouriteUsers = Bundle.main.decode([User].self, from: "favouriteUsers.json")
		let contactsUsers = Bundle.main.decode([User].self, from: "contactUsers.json")
//		let competitionForUsers = [
//			User(fullname: "Andrew Kurdin", imageString: "human1", firstCharacter: "A", id: 1),
//			User(fullname: "Frafra Kurdin", imageString: "human1", firstCharacter: "F", id: 2),
//			User(fullname: "FraFra Kurdin", imageString: "human1", firstCharacter: "F", id: 3),
//			User(fullname: "Rara Kurdin", imageString: "human1", firstCharacter: "R", id: 4),
//			User(fullname: "Gaga Kurdin", imageString: "human1", firstCharacter: "G", id: 5),
//			User(fullname: "Gaga Kurdin", imageString: "human1", firstCharacter: "G", id: 6),
//			User(fullname: "Andrew Kurdin", imageString: "human1", firstCharacter: "A", id: 7),
//			User(fullname: "Frafra Kurdin", imageString: "human1", firstCharacter: "F", id: 8),
//			User(fullname: "FraFra Kurdin", imageString: "human1", firstCharacter: "F", id: 9),
//			User(fullname: "Rara Kurdin", imageString: "human1", firstCharacter: "R", id: 10),
//			User(fullname: "Gaga Kurdin", imageString: "human1", firstCharacter: "G", id: 11),
//			User(fullname: "Gaga Kurdin", imageString: "human1", firstCharacter: "G", id: 12),
//			User(fullname: "Blabla Balov", imageString: "human1", firstCharacter: "B", id: 13)
//		]
		
		_collection = [
			UserCollection(type: .profile, header: nil, users: [profile]),
			UserCollection(type: .favourites, header: nil, users: favouriteUsers)
		]
		
		var dict: [String: [User]] = [:]
		contactsUsers.forEach { (user) in
			if dict[user.firstCharacter] == nil {
				dict[user.firstCharacter] = [user]
			} else {
				if dict[user.firstCharacter]?.first?.firstCharacter == user.firstCharacter {
					dict[user.firstCharacter]?.append(user)
				}
			}
		}
		
		dict.forEach { (keys, users) in
			_collection.append(UserCollection(type: .contacts, header: keys, users: users))
		}
	}
	
	
}
