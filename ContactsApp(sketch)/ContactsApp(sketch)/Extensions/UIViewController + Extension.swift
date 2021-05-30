//
//  UIViewContactsViewController + Extension.swift
//  ContactsApp(sketch)
//
//  Created by admin on 04.05.2021.
//

import UIKit

extension UIViewController {
	// функция принимающая любой объект подписанный под протокол SelfConfiguringCell
	func configureObj<CellObj: SelfConfiguringCell>(collectionView: UICollectionView, cellType: CellObj.Type, with user: ContactsModel.User, for indexPath: IndexPath) -> CellObj {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseId, for: indexPath) as? CellObj
		else { fatalError("Unable to dequeue \(cellType)") }
		cell.configure(with: user)
		return cell
	}
}
