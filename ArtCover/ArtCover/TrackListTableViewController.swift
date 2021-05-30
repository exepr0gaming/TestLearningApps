//
//  TrackListTableViewController.swift
//  ArtCover
//
//  Created by admin on 17.03.2021.
//

import UIKit

class TrackListTableViewController: UITableViewController {

	let imageNameArray = ["Alberto Ruiz - 7 Elements (Original Mix)",
												"Dave Wincent - Red Eye (Original Mix)",
												"E-Spectro - End Station (Original Mix)",
												"Edna Ann - Phasma (Konstantin Yoodza Remix)",
												"Ilija Djokovic - Delusion (Original Mix)",
												"John Baptiste - Mycelium (Original Mix)",
												"Lane 8 - Fingerprint (Original Mix)",
												"Mac Vaughn - Pink Is My Favorite Color (Alex Stein Remix)",
												"Metodi Hristov, Gallya - Badmash (Original Mix)",
												"Veerus, Maxie Devine - Nightmare (Original Mix)"]
	
    override func viewDidLoad() {
        super.viewDidLoad()

			
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
			return imageNameArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
			
			cell.textLabel?.numberOfLines = 0
			cell.imageView?.image = UIImage(named: imageNameArray[indexPath.row])
			cell.textLabel?.text = imageNameArray[indexPath.row]

        return cell
    }
    
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		60
	}
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
			//guard segue.identifier == "showDetails" else { return }
			guard let detailsVC = segue.destination as? DetailsVC else { return }
			guard let indexPath = tableView.indexPathForSelectedRow else { return }
			//segueDest.imageView.image = UIImage(named: imageNameArray[indexPath])
			detailsVC.trackTitle = imageNameArray[indexPath.row]
    }

}
