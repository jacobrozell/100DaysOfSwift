//
//  ViewController.swift
//  project_10
//
//  Created by Jacob Rozell on 10/19/21.
//

import UIKit


class ViewController: UICollectionViewController {

    // MARK: Variables
    var people = [Person]()

    // MARK: LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Namez 2 Faces"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        // Look for cache
        let defaults = UserDefaults.standard
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            let decoder = JSONDecoder()

            do {
                people = try decoder.decode([Person].self, from: savedPeople)
            } catch {
                print("No cache found for People.")
            }
        }
    }

    // MARK: - CollectionView DataSource / Delegate
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCell", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell.")
        }

        let person = people[indexPath.item]
        let path = getDocumentsDirectory().appendingPathComponent(person.image)

        cell.name.text = person.name
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3.0
        cell.layer.cornerRadius = 7.0

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.row]

        let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
        ac.addTextField()

        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let newName = ac.textFields?[0].text else { return }
            person.name = newName
            self?.save()
            self?.collectionView.reloadData()
        })

        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive))

        present(ac, animated: true)
    }

    // MARK: - Caching
    func save() {
        let encoder = JSONEncoder()
        if let savedData = encoder.encode(people) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        } else {
            print("Failed to set people!")
        }
    }

    // MARK: - Objc Methods
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate Extension
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }

        people.append(Person(name: "Unkown", image: imageName))
        save()
        collectionView.reloadData()

        dismiss(animated: true)
    }

    /// Return path to Documents
    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
