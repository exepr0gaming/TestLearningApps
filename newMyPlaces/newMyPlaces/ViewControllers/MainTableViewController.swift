//
//  MainTableViewController.swift
//  newMyPlaces
//
//  Created by admin on 25.03.2021.
//

import UIKit
import RealmSwift

class MainTableViewController: UIViewController, UITableViewDataSource {
	
	private var places: Results<Place>!
	private var accessingSorting = true
	
	private var searchController = UISearchController(searchResultsController: nil) // можно отображать результаты на другом view
	private var filteredPlaces: Results<Place>!
	private var searchBarIsEmpty: Bool {
		guard let text = searchController.searchBar.text else  { return false }
		return text.isEmpty
	}
	private var isFiltering: Bool {
		return searchController.isActive && !searchBarIsEmpty
	}
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var segmentedControl: UISegmentedControl!
	@IBOutlet weak var reverseSortBut: UIBarButtonItem!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		places = realm.objects(Place.self) // self, потому что нам нужен именно тип
		searchSettings()
	}
	
	// MARK: - Table view data source
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if isFiltering {
			return filteredPlaces.count
		}
		return places.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
		let place = isFiltering ? filteredPlaces[indexPath.row] : places[indexPath.row]
		
		cell.nameOfPlaceLabel?.text = place.name
		cell.locationOfPlaceLabel.text = place.location
		cell.typeOfPlaceLabel.text = place.type
		cell.imageOfPlace.image = UIImage(data: place.imageData!)
		cell.cosmosView.rating = place.rating
		
		return cell
	}
	
	// MARK: - Table View delegate
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true) // отменить выделение ячейки
	}
	
	//delete (более крупные методы - leading и trailingSwipeActionsConfigurationForRowAt
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let place = places[indexPath.row]
			StorageManager.deleteObjecat(place)
			tableView.deleteRows(at: [indexPath], with: .automatic)
		}
	}
	
	@IBAction func unwindSegue(_ segue: UIStoryboardSegue){
		guard let newPlaceVC = segue.source as? NewPlaceTableViewController else { return }
		newPlaceVC.savePlace()
		tableView.reloadData()
	}
	
	// MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "detailSegue" {
			guard	let indexPath = tableView.indexPathForSelectedRow else { return }
			let place = isFiltering ? filteredPlaces[indexPath.row] : places[indexPath.row]
			guard let editVC = segue.destination as? NewPlaceTableViewController else { return }
			editVC.currentPlace = place
		}
	}
	@IBAction func sortSelection(_ sender: UISegmentedControl) {
		sorted()
	}
	@IBAction func reverseSorting(_ sender: Any) {
		accessingSorting.toggle()
		if accessingSorting {
			reverseSortBut.image = #imageLiteral(resourceName: "AZ")
		} else {
			reverseSortBut.image = #imageLiteral(resourceName: "ZA")
		}
		sorted()
		
	}
	
	private func sorted(){
		if segmentedControl.selectedSegmentIndex == 0 {
			places = places.sorted(byKeyPath: "date", ascending: accessingSorting)
		} else {
			places = places.sorted(byKeyPath: "name", ascending: accessingSorting)
		}
		tableView.reloadData()
	}
	
}

// по дефолту поиск отображается в другом view
extension MainTableViewController: UISearchResultsUpdating {
	
	func updateSearchResults(for searchController: UISearchController) {
		filterContentForSearchText(searchController.searchBar.text!) //даже пустая строка не будет иметь nil, пока не наведешь
	}
	private func filterContentForSearchText(_ searchText: String) {
		filteredPlaces = places.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@", searchText, searchText) // всё взято с документации realm. - Имя должно содержать что-то из строки [c] отвлючение зависимости регистра
		tableView.reloadData()
	}
	
	func searchSettings(){
		searchController.searchResultsUpdater = self // получатель информации об изменениях текста будет этот класс
		searchController.obscuresBackgroundDuringPresentation = false // по ум. вью с результатами поиска не позволяет взаимодействовать с контентом, если откл, то позволит взаим, как с основным - удалять смотреть и пр.
		searchController.searchBar.placeholder = "Search"
		navigationItem.searchController = searchController // интегрируем SC в navBar
		definesPresentationContext = true // позволяет отпустить строку поиска при переходе на др экран
	}
	
	
	
}
