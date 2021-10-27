//
//  Capital.swift
//  project_16
//
//  Created by Jacob Rozell on 10/22/21.
//

import UIKit
import MapKit

struct WorldCapital: Codable {
    let city: String
    let latitude: String
    let longitude: String
    let state: String
}

class CapitalPin: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: WorldCapital

    init(worldCapital: WorldCapital, coordinate: CLLocationCoordinate2D) {
        self.title = worldCapital.city
        self.coordinate = coordinate
        self.info = worldCapital
    }
}
