//
//  ViewController.swift
//  project_15
//
//  Created by Jacob Rozell on 10/22/21.
//

import UIKit

class ViewController: UIViewController {
    var imageView: UIImageView!
    var currentAnimation = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView = UIImageView(image: UIImage(named: "penguin"))
        imageView.center = CGPoint(x: 512, y: 384)
        view.addSubview(imageView)
    }

    // MARK: - IBActions
    @IBAction func tap(_ sender: UIButton) {
        // hide button while animation is going
        sender.isHidden = true
        sender.layer.zPosition = .greatestFiniteMagnitude

        // Animation
//        UIView.animate(withDuration: 1, delay: 0, options: []) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            switch self.currentAnimation {
            case 0:
                self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
            case 1:
                self.imageView.transform = .identity
            case 2:
                self.imageView.transform = CGAffineTransform(translationX: -256, y: -220)
            case 3:
                self.imageView.transform = CGAffineTransform(translationX: 256, y: 220)
            case 4:
                self.imageView.transform = CGAffineTransform(rotationAngle: .pi)
            case 5:
                self.imageView.transform = CGAffineTransform(translationX: 130, y: 300)
            case 6:
                self.imageView.transform = .identity
                self.imageView.alpha = 0.1
            case 7:
                self.imageView.alpha = 1
                self.imageView.transform = CGAffineTransform(scaleX: 9, y: 9)
            case 8:
                self.imageView.transform = .identity
            default:
                break
            }
        }, completion: { finished in
            sender.isHidden = false
        })

        // Increase animation
        currentAnimation += 1

        if currentAnimation > 8 {
            currentAnimation = 0
        }
    }
}
