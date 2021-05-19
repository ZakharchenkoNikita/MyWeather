//
//  ViewController.swift
//  MyWeather
//
//  Created by Nikita on 16.05.21.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperatureLalebel: UILabel!
    @IBOutlet weak var fielsLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var networkWeatherManager = NetworkWeatherManager()
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self // указали наш класс в качестве делегата
        lm.desiredAccuracy = kCLLocationAccuracyKilometer// указываем точность с которой хотим получать информацию
        lm.requestWhenInUseAuthorization() // запрашиваем доступ к геопозиции
        
        return lm
    }()
    
    @IBAction func searchPressed(_ sender: UIButton) {
        self.presentSearchAlertController(withTitle: "Enter your city", message: nil, style: .alert) { [unowned self] city in
            self.networkWeatherManager.fetchCurrentWeather(forRequestType: .cityName(city: city))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkWeatherManager.onCompletion = { [weak self] currentWeather in
            guard let self = self else { return }
            self.updateInterfaceWith(weather: currentWeather)
        }
        
        if CLLocationManager.locationServicesEnabled() { // если настройки геопозиции включено
            locationManager.requestLocation()
        }
    }
    
    func updateInterfaceWith(weather: CurrentWeather) {
        
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.temperatureLalebel.text = weather.temperatureString
            self.fielsLabel.text = weather.feelsLikeTemperatureString
            self.weatherImage.image = UIImage(systemName: weather.systemIconNameString)
        }
    }
}

// MARK: CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        networkWeatherManager.fetchCurrentWeather(forRequestType: .coordinate(latitude: latitude, longitude: longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
