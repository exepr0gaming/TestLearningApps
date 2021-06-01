//
//  ViewController.swift
//  exchangeRates
//
//  Created by admin on 01.06.2020.
//

import UIKit

class MainViewController: UITableViewController {
	
	private var valutes: [Valute] = []
	private var spinnerView: UIActivityIndicatorView?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		spinnerView = showSpinner(in: tableView)
		sendRequest()
		
		title = "Курс ЦБ"
	}
	
	// MARK: - Table view data source
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return valutes.count
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! RatesTableViewCell
		
		cell.rateLabel.text = valutes[indexPath.row].CharCode
		cell.courseLabel.text = String(describing: valutes[indexPath.row].Value!)
		
		if valutes[indexPath.row].Previous! == valutes[indexPath.row].Value! {
			cell.differenceLable.text = "0.00"
		} else if valutes[indexPath.row].Previous! < valutes[indexPath.row].Value! {
			cell.differenceLable.text = "+" + String(describing: Double(round(100*(valutes[indexPath.row].Value! - valutes[indexPath.row].Previous!))/100))
			cell.differenceLable.textColor = #colorLiteral(red: 0.1137254902, green: 0.7294117647, blue: 0.1490196078, alpha: 1)
			cell.differenceImage.image = #imageLiteral(resourceName: "sort-app")
		} else {
			cell.differenceLable.text = String(describing: Double(round(100*(valutes[indexPath.row].Value! - valutes[indexPath.row].Previous!))/100))
			cell.differenceLable.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
			cell.differenceImage.image = #imageLiteral(resourceName: "sort-down")
		}
		return cell
	}
	
	@IBAction func rerfashButton(_ sender: UIBarButtonItem) {
		sendRequest()
		spinnerView?.startAnimating()
	}
	
	private func sendRequest() {
		NetworkManager.shared.fetchData { currencyRates, valutes in
			let cRDate = currencyRates.Date
			DispatchQueue.main.async {
				self.spinnerView?.stopAnimating()
				self.valutes = valutes
				self.tableView.reloadData()
				self.title = "Курс ЦБ на " + cRDate[String.Index(utf16Offset: 0, in: cRDate) ..< String.Index(utf16Offset: 10, in: cRDate)]
			}
		}
	}
	
	private func showSpinner(in view: UIView) -> UIActivityIndicatorView {
		let activityIndicator = UIActivityIndicatorView.init(style: .large)
		activityIndicator.color = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
		activityIndicator.startAnimating()
		activityIndicator.center = view.center
		activityIndicator.hidesWhenStopped = true
		
		view.addSubview(activityIndicator)
		
		return activityIndicator
	}
}
