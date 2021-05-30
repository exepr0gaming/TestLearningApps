//
//  RatingControl.swift
//  newMyPlaces
//
//  Created by admin on 10.04.2021.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
	
	private var ratingButtons = [UIButton]()
	@IBInspectable var starSize: CGSize = CGSize(width: 44, height: 44) {
		didSet {
			setupButtons()
		}
	}
	@IBInspectable var starCount: Int = 5 {
		didSet {
			setupButtons()
		}
	}
	var rating = 0.0 {
		didSet {
			updateButtonSelectionState()
		}
	}
// обычно представление создаются программно или со сторибордом
	// необходимо инициализировать оба инициализатора
	// MARK: - Initialisation
	override init(frame: CGRect){
		super.init(frame: frame)
		setupButtons()
	}
	
	required init(coder: NSCoder) {
		super.init(coder: coder)
		setupButtons()
	}
	
	// MARK: - Button Actions
	@objc func ratingButtonTapped(button: UIButton) {
		guard let index = ratingButtons.firstIndex(of: button) else { return }
		//calculate rating of selected but
		let selectedRating = index + 1
//		if selectedRating == Int(rating) {
//			rating == 0.0
//		} else {
			rating = Double(selectedRating)
		//}
	}
	
	private func setupButtons(){
		for button in ratingButtons {
			removeArrangedSubview(button)
			button.removeFromSuperview()
		}
		ratingButtons.removeAll()
		
		//load buttonImage, вместо дефолтного image, чтобы отображалось в сториборде
		let bundle = Bundle(for: type(of: self))
		let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
		let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
		let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
		
		for _ in 0..<starCount {
			let button = UIButton()
			//button.backgroundColor = .red
			button.setImage(emptyStar, for: .normal)
			button.setImage(filledStar, for: .selected)
			button.setImage(highlightedStar, for: .highlighted)
			button.setImage(highlightedStar, for: [.highlighted, .selected])
			
			button.translatesAutoresizingMaskIntoConstraints = false // откл автомат сгенерированные констрейнты для кнопки
			button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
			button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
			//setup button action
			button.addTarget(self, action: #selector(ratingButtonTapped(button:)), for: .touchUpInside)
			//помещяем кнопку в stackView
			addArrangedSubview(button)
			
			ratingButtons.append(button)
		}
		updateButtonSelectionState()
	}
	
	private func updateButtonSelectionState(){
		for (index, button) in ratingButtons.enumerated() { // enum возвращает индекс и объект
			button.isSelected = index < Int(rating)
		}
	}

}
