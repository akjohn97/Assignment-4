//
//  MapViewController.swift
//  City2City-J22
//
//  Created by mac on 1/30/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var openButton: UIButton!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var temperatureLabel: UILabel!
    //dependency injection - giving an object its dependencies from the outside
    var city: City!
    var desc: String = ""
    var temperature: Double = 0.0
    var feelsLike: Double = 0.0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        getWeather()
    }
    
    private func setupMap() {
        //focus area of map
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude), latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.region = region
        
        //place pin on map
        let annote = MKPointAnnotation()
        annote.coordinate = CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude)
        annote.title = "\(city.name), \(city.state)"
        annote.subtitle = "You Are Here"
        mapView.addAnnotation(annote)
    }
 
    private func getWeather() {
        WeatherManager.shared.getWeather(for: city) { wthr in
            if let weather = wthr {
                self.desc = weather.description
                self.temperature = weather.temp
                self.feelsLike = weather.feelsLike
            }
        }
    }
    @IBAction func openButtonPushed(_ sender: UIButton) {
        popUpView.isHidden = false
        descriptionLabel.text = "\(desc)"
        temperatureLabel.text = "\(temperature)"
        feelsLikeLabel.text = "\(feelsLike)"
        
    }
    @IBAction func closeButtonressed(_ sender: UIButton) {
        popUpView.isHidden = true
    }
    
}
