//
//  ViewController.swift
//  GreatBrowser
//
//  Created by admin on 19.03.2021.
//

import UIKit
import WebKit

class ViewController: UIViewController {
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var urlTextField: UITextField!
	@IBOutlet weak var forwardButton: UIButton!
	@IBOutlet weak var webView: WKWebView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setSettings()
	}
	private func setSettings() {
		
		urlTextField.delegate = self
		webView.navigationDelegate = self
		
		let homeUrl = "https://www.apple.com"
		let url = URL(string: homeUrl)
		
		let request = URLRequest(url: url!)
		
		urlTextField.text = homeUrl
		
		webView.load(request)
		webView.allowsBackForwardNavigationGestures = true
	}
	
	
	@IBAction func backbuttonAction(_ sender: UIButton) {
		if webView.canGoBack {
			webView.goBack()
		}
	}
	
	@IBAction func forwardButtonAction(_ sender: Any) {
		if webView.canGoForward {
			webView.goForward()
		}
	}
	
}

extension ViewController: UITextFieldDelegate, WKNavigationDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		
		guard let urlName = textField.text else { return false}
		let url = URL(string: urlName)
		let request = URLRequest(url: url!)
		
		webView.load(request)
		textField.resignFirstResponder() // скрывыает клаву после нажатия return
		return true
	}
	
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		urlTextField.text = webView.url?.absoluteString
		
		backButton.isEnabled = webView.canGoBack
		forwardButton.isEnabled = webView.canGoForward
	}
	
}

