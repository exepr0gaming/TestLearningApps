//
//  NewPlaceTableViewController.swift
//  newMyPlaces
//
//  Created by admin on 27.03.2021.
//

import RealmSwift
import Cosmos

class NewPlaceTableViewController: UITableViewController {
	var imageIsChanged = false
	var currentPlace: Place! // можно извлечь? так как все свойста у редиактируемого объекта уже инициализированы или nil
	var currentRating = 0.0
	
	@IBOutlet weak var saveButton: UIBarButtonItem!
	@IBOutlet weak var placeImage: UIImageView!
	@IBOutlet weak var placeName: UITextField!
	@IBOutlet weak var placeLocation: UITextField!
	@IBOutlet weak var placeType: UITextField!
	@IBOutlet weak var cosmosView: CosmosView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.tableFooterView = UIView()
		saveButton.isEnabled = false
		placeName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
		editPlace()
		editBarButtons()
		
		//settings for CosmosStars
		cosmosView.settings.fillMode = .half //precise - точная настройка звезды до сотых
		cosmosView.didTouchCosmos = { rating in // отслеживаем нажатие на звезду
			self.currentRating = rating
		}
	}
	
	// MARK: - Table view delegate
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row == 0 {
			let cameraIcon = #imageLiteral(resourceName: "camera")
			let photoIcon = #imageLiteral(resourceName: "photo")
			let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
			let camera = UIAlertAction(title: "Camera", style: .default) { _ in
				self.chooseImagePicker(source: .camera)
			}
			camera.setValue(cameraIcon, forKey: "image")
			camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
			
			let photo = UIAlertAction(title: "Photo", style: .default) { _ in
				self.chooseImagePicker(source: .photoLibrary)
			}
			photo.setValue(photoIcon, forKey: "image")
			photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
			
			let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
				
			}
			actionSheet.addAction(camera)
			actionSheet.addAction(photo)
			actionSheet.addAction(cancel)
			present(actionSheet, animated: true)
			
		} else {
			tableView.endEditing(true) // скрывает при тапе по экрану везде кроме первой ячейки
		}
	}
	
	// MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		guard let identifier = segue.identifier, let mapVC = segue.destination as? MapViewController else { return }
		mapVC.incomeSegueIdentifier = identifier
		mapVC.mapViewControllerDelegate = self
		
		if identifier == "showPlace" {
			// чтобы работала карта при создании объекта, нужно передать не сам объект полностью, а значения полей
			mapVC.place.name = placeName.text!
			mapVC.place.location = placeLocation.text
			mapVC.place.type = placeType.text
			mapVC.place.imageData = placeImage.image?.pngData()
		}
		
		
	}
	
	func savePlace(){
		let image = imageIsChanged ? placeImage.image : #imageLiteral(resourceName: "imagePlaceholder")
		let imageData = image?.pngData()
		let newPlace = Place(name: placeName.text!,
												 location: placeLocation.text,
												 type: placeType.text,
												 imageData: imageData,
												 rating: currentRating)
		
		if currentPlace != nil {
			try! realm.write {
				currentPlace?.name = newPlace.name
				currentPlace?.location = newPlace.location
				currentPlace?.type = newPlace.type
				currentPlace?.imageData = newPlace.imageData
				currentPlace?.rating = newPlace.rating
			}} else {
				StorageManager.saveObject(newPlace)
			}

	}
	
	private func editPlace() {
		if currentPlace != nil {
			
			editBarButtons()
			imageIsChanged = true
			
			guard let imageData = currentPlace!.imageData, let image = UIImage(data: imageData) else { return }
			placeImage.image = image
			placeImage.contentMode = .scaleAspectFill
			placeName.text = currentPlace?.name
			placeLocation.text = currentPlace?.location
			placeType.text = currentPlace?.type
			cosmosView.rating = currentPlace.rating
			currentRating = currentPlace.rating
			
			title = currentPlace?.name
			let fontAttribute = [NSAttributedString.Key.font: UIFont(name: "Apple SD Gothic Neo Regular", size: 24)!]
			navigationController?.navigationBar.titleTextAttributes = fontAttribute
		}
	}
	
	private func editBarButtons() {
		guard let topItem = navigationController?.navigationBar.topItem else { return }
		topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
		navigationItem.leftBarButtonItem = nil // убрать cancel, чтобы вернуть back
		
		saveButton.isEnabled = true
	}
	
	@IBAction func cancelAction(_ sender: Any) {
		dismiss(animated: true)
	}
	
	
}
// MARK: - Work with Text
extension NewPlaceTableViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder() //  скрывает клаву после Done
		return true
	}
	
	@objc private func textFieldChanged(){
		if placeName.text?.isEmpty == false {
			saveButton.isEnabled = true
		} else {
			saveButton.isEnabled = false
		}
	}
	
	
	
}

// MARK: - Photo Choose
extension NewPlaceTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func chooseImagePicker(source: UIImagePickerController.SourceType){
		if UIImagePickerController.isSourceTypeAvailable(source) {
			let imagePicker = UIImagePickerController()
			imagePicker.delegate = self
			imagePicker.allowsEditing = true // позволит редактировать изображение, масштабировать
			imagePicker.sourceType = source // тип источника для выбранного изображения
			present(imagePicker, animated: true)
		}
	}
	
	//тут нужно присвоить изображение, выбранное пользователем
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		placeImage.image = info[.editedImage] as? UIImage
		placeImage.contentMode = .scaleAspectFill
		placeImage.clipsToBounds = true
		imageIsChanged = true
		dismiss(animated: true)
		
	
	}
	
}

extension NewPlaceTableViewController: MapViewControllerDelegate {
	func getAddress(_ address: String?) {
		placeLocation.text = address
	}
	
	
}
