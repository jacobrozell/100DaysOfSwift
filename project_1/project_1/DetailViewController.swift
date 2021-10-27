//
//  DetailViewController.swift
//  project_1
//
//  Created by Jacob Rozell on 10/5/21.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var selectedImage: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        imageView.contentMode = .scaleAspectFill
        title = selectedImage ?? "Detail"

        if let image = selectedImage {
            imageView.image = UIImage(named: image)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
}
