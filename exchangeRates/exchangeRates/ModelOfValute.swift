//
//  ModelOfValute.swift
//  exchangeRates
//
//  Created by admin on 01.06.2020.
//

import Foundation

import Foundation

struct CurrencyRates: Decodable {
		let Date: String
		var Valute: [String: Valute]
}

struct Valute: Decodable {
		let NumCode: String?
		let CharCode: String?
		let Nominal: Int?
		let Name: String?
		let Value: Double?
		let Previous: Double?
}
