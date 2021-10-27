//
//  ViewController.swift
//  project_16
//
//  Created by Jacob Rozell on 10/22/21.
//
import AVFoundation
import CodableCSV
import MapKit
import UIKit


class ViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!
    var player: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Capital Cities"

        playSound()

        DispatchQueue.main.async {
            self.getPins()
        }

        mapView.showsCompass = true
    }

    func getPins() {
        let decoder = CSVDecoder()
        decoder.headerStrategy = .firstLine

        do {
            let data = try Data(contentsOf: Bundle.main.url(forResource: "us-state-capitals", withExtension: "csv")!)
            let capitals = try decoder.decode([WorldCapital].self, from: data)
            for entry in capitals {
                guard
                    !entry.latitude.isEmpty,
                    !entry.longitude.isEmpty,
                    let lat = Double(entry.latitude),
                    let long = Double(entry.longitude)
                else { return }

                let coord = CLLocationCoordinate2D(latitude: lat, longitude: long)
                mapView.addAnnotation(CapitalPin(worldCapital: entry, coordinate: coord))
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    // MARK: - Sound
    func playSound() {
        guard let url = Bundle.main.url(forResource: "Capital Cities - Safe And Sound", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
}

// MARK: - MKMapViewDelegate
extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CapitalPin else { return nil }

        let id = "capital"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: id)

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: id)
            annotationView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = button
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let pin = view.annotation as? CapitalPin else { return }

        let detail = DetailViewController()
        detail.title = "\(pin.info.city)"
        detail.url = URL(string: "https://en.wikipedia.org/wiki/\(pin.info.city),_\(pin.info.state.replacingOccurrences(of: " ", with: "_"))")

        self.navigationController?.pushViewController(detail, animated: true)
    }
}
