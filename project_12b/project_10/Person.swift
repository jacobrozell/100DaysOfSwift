//
//  Person.swift
//  project_10
//
//  Created by Jacob Rozell on 10/19/21.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String

    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
