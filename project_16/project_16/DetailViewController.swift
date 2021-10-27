//
//  DetailViewController.swift
//  project_16
//
//  Created by Jacob Rozell on 10/22/21.
//

import WebKit
import UIKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var url: URL!

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = url {
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        } else {
            let alert = UIAlertController(title: "Failed to load.", message: "\(String(describing: url))", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive) { _ in
                self.dismiss(animated: true, completion: nil)
            })

            self.present(alert, animated: true)
        }
    }
}

extension DetailViewController: WKNavigationDelegate {}
