//
//  ViewController.swift
//  ContactsApp(sketch)
//
//  Created by admin on 03.05.2021.
//

import UIKit



class ContactsViewController: UIViewController {
	
	let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonItemTapped))
	let groupsBarButtonItem = UIBarButtonItem(title: "Groups", style: .plain, target: self, action: #selector(groupsBarButtonItemTapped))
	
	var dataSource: UICollectionViewDiffableDataSource<ContactsModel.UserCollection, ContactsModel.User>! = nil // тип секции и тип item
	var currentSnapshot: NSDiffableDataSourceSnapshot<ContactsModel.UserCollection, ContactsModel.User>! = nil
	var collectionView: UICollectionView!
	let contactsModel = ContactsModel()
	
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupNavigationBar()
		setupCollectionView()
		createDataSource()
		reloadData()
	}
	
	private func setupNavigationBar() {
		let searchController = UISearchController()
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false // searchBar откл при скролинге
		searchController.hidesNavigationBarDuringPresentation = false
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.delegate = self // для срабатывания функции при введении нового символа
		
		navigationItem.leftBarButtonItem = groupsBarButtonItem
		navigationItem.rightBarButtonItem = addBarButtonItem
		
		navigationController?.navigationBar.prefersLargeTitles = true
		title = "Contacts"
	}
	
	// MARK: - Регистрация 3х видов ячеек
	private func setupCollectionView() {
		collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout()) // UICollectionViewFlowLayout() вместо createCompositionalLayout
		view.addSubview(collectionView)
		collectionView.backgroundColor = .systemBackground
		
		collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
		
		collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.reuseId)
		collectionView.register(FavouriteCell.self, forCellWithReuseIdentifier: FavouriteCell.reuseId)
		collectionView.register(ContactCell.self, forCellWithReuseIdentifier: ContactCell.reuseId)
	}
	
	private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
		// генерирует собственный layout для каждой секции
		let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvirment) -> NSCollectionLayoutSection? in
			let type = self.currentSnapshot.sectionIdentifiers[sectionIndex].type
			switch type {
				
				case .profile:
					return self.createProfile()
				case .favourites:
					return self.createFavourites()
				case .contacts:
					return self.createContacts()
			}
		}
		let config = UICollectionViewCompositionalLayoutConfiguration()
		config.interSectionSpacing = 16
		layout.configuration = config
		
		return layout
	}
	
	private func createProfile() -> NSCollectionLayoutSection {
		
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(58)) // .fractionalWidth(1) значит, что ширина будет равняться ширине вышестоящего объекта - т.е. секции, именно секции, не экрана
		let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
		let section = NSCollectionLayoutSection(group: group)
		section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
		
		return section
	}
	
	private func createFavourites() -> NSCollectionLayoutSection {
		
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(110), heightDimension: .absolute(120)) // .fractionalWidth(1) значит, что ширина будет равняться ширине вышестоящего объекта - т.е. секции, именно секции, не экрана
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
		let section = NSCollectionLayoutSection(group: group)
		section.interGroupSpacing = 12 // расстроение между groups
		section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
		section.orthogonalScrollingBehavior = .continuous // чтобы компилятор понимал, как отображать горизонтально, .paging (apple Style)
		return section
	}
	
	private func createContacts() -> NSCollectionLayoutSection {
		
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(55)) // .fractionalWidth(1) значит, что ширина будет равняться ширине вышестоящего объекта - т.е. секции, именно секции, не экрана
		let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
		let section = NSCollectionLayoutSection(group: group)
		section.interGroupSpacing = 2 // расстроение между groups
		section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16)
		
		let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(25))
		let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
		section.boundarySupplementaryItems = [sectionHeader]
		
		return section
	}
	
	// MARK: - загрузка данных в коллекцию
	private func reloadData() {
		currentSnapshot = NSDiffableDataSourceSnapshot<ContactsModel.UserCollection, ContactsModel.User>()
		
		contactsModel.collections.forEach { (collection) in
			currentSnapshot.appendSections([collection])
			currentSnapshot.appendItems(collection.users)
		}
		dataSource.apply(currentSnapshot, animatingDifferences: true)
	}
	
	// MARK: - DataSource, настройка типов ячеек для каждой секции
	func createDataSource() {
		dataSource = UICollectionViewDiffableDataSource<ContactsModel.UserCollection, ContactsModel.User>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, user) -> UICollectionViewCell? in
			let type = self.currentSnapshot.sectionIdentifiers[indexPath.section].type
			let users = self.currentSnapshot.sectionIdentifiers[indexPath.section].users
			var user = user
			
			if type == .contacts {
				if users.count > 1, users.first == user {
					user.direction = .top
				} else if users.count == 1 {
					user.direction = .all
				} else if users.last == user {
					user.direction = .bottom
				} else {
					user.direction = .nope
				}
			}
			
			switch type {
				case .profile:
					return self.configureObj(collectionView: collectionView, cellType: ProfileCell.self, with: user, for: indexPath)
				case .favourites:
					return self.configureObj(collectionView: collectionView, cellType: FavouriteCell.self, with: user, for: indexPath)
				case .contacts:
					return self.configureObj(collectionView: collectionView, cellType: ContactCell.self, with: user, for: indexPath)
			}
		})
		
		dataSource.supplementaryViewProvider = { [weak self](collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
			guard let self = self, let snapshot = self.currentSnapshot else { return nil }
			if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader {
				let collection = snapshot.sectionIdentifiers[indexPath.section]
				sectionHeader.titleLabel.text = collection.header
				return sectionHeader
			} else {
				fatalError("Cannot create new Supplementary")
			}
		}
	}


}

//collectionView.delegate = self
//collectionView.dataSource = self
//extension ContactsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//	func numberOfSections(in collectionView: UICollectionView) -> Int {
//		3
//	}
//	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//		5
//	}
//	
//	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//		let cell ...
//	}
//}


// MARK: - Actions
extension ContactsViewController {
	@objc func groupsBarButtonItemTapped() {
		print(#function)
	}
	@objc func addBarButtonItemTapped() {
		print(#function)
	}
}

// MARK: - UISearchBarDelegate
extension ContactsViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		print(searchText)
	}
}


