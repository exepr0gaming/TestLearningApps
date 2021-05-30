import UIKit

extension ViewController {
	func presentSearchAlertController(withTitle title: String?, message: String?, style: UIAlertController.Style, completion: @escaping (String) -> Void) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: style)
        ac.addTextField { tf in
            let cities = ["San Francisco", "Moscow", "New York", "Stambul", "Viena"]
            tf.placeholder = cities.randomElement()
        }
        let search = UIAlertAction(title: "Search", style: .default) { action in
            let textField = ac.textFields?.first
            guard let cityName = textField?.text else { return }
            if cityName != "" {
							//self.networkManager.fetchData(fromCity: cityName)
							let city = cityName.split(separator: " ").joined(separator: "%20") // если город состоит из 2 и более слов, разделяем его в массив и соединяем веб символом пробела, New%20York
							completion(city)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        ac.addAction(search)
        ac.addAction(cancel)
        present(ac, animated: true, completion: nil)
    }
}
