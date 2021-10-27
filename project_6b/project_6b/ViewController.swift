import UIKit

class ViewController: UIViewController {
    var stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(stackView)

        setupStackView()
        makeConstraints()
    }

    // MARK: - StackView Util
    func setupStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        stackView.alignment = .top

        stackView.addArrangedSubviews([
            makeLabel(text: "THESE", color: .red),
            makeLabel(text: "ARE", color: .cyan),
            makeLabel(text: "SOME", color: .yellow),
            makeLabel(text: "AWESOME", color: .green),
            makeLabel(text: "LABEL", color: .orange),
            makeLabel(text: "1", color: .brown),
            makeLabel(text: "2", color: .purple),
            makeLabel(text: "3", color: .darkGray)
        ])
    }

    func makeConstraints() {
        stackView.arrangedSubviews.forEach { label in
            label.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor).isActive = true
        }

        stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    // MARK: - Util Methods
    func makeLabel(text: String, color: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.backgroundColor = color
        return label
    }
}

// MARK: - Extensions
extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { view in
            self.addArrangedSubview(view)
        }
    }
}

