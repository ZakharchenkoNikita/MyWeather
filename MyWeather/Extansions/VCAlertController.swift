//
//  VCAlertController.swift
//  MyWeather
//
//  Created by Nikita on 16.05.21.
//

import UIKit

extension ViewController {
    func presentSearchAlertController(withTitle title: String?,
                                      message: String?,
                                      style: UIAlertController.Style,
                                      completionHandler: @escaping (String) -> Void) {
        
        let ac = UIAlertController(title: title,
                                   message: message,
                                   preferredStyle: style)
        ac.addTextField { textField in
            let cities = ["San Francisco", "Moscow", "New York", "Stambul", "Viena"]
            textField.placeholder = cities.randomElement()
        }
        
        let searchAction = UIAlertAction(title: "Search", style: .default) { action in
            let textField = ac.textFields?.first
            guard let cityName = textField?.text else { return }
            if cityName != "" {
//                self.networkWeatherManager.fetchCurrentWeather(forCity: cityName) // один из вариантов использования
                let city = cityName.split(separator: " ").joined(separator: "%20")
                completionHandler(city)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        ac.addAction(searchAction)
        ac.addAction(cancelAction)
        
        present(ac, animated: true, completion: nil)
    }
}
