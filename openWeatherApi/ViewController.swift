//
//  ViewController.swift
//  openWeatherApi
//
//  Created by Edo Lorenza on 06/08/20.
//  Copyright © 2020 Edo Lorenza. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageWeatherIcon: UIImageView!
    @IBOutlet weak var labelTemp: UILabel!
    @IBOutlet weak var labelWeatherDesc: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchApi()
    }
    
    func fetchApi() {
        guard let weatherUrl = URL(string: "https://samples.openweathermap.org/data/2.5/weather?q=London,uk&appid=439d4b804bc8187953eb36d2a8c26a02") else{return}
        URLSession.shared.dataTask(with: weatherUrl) { (data, respone, error) in
            guard let data = data else {return}
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(CurrentWeather.self, from: data)
                
                let temp = weatherData.main.temp
                let formattedTemp = String(format: "%.0f",(temp - 273.15))
                let weatherDesc = weatherData.weather[0].description
                
                print(weatherDesc)
                DispatchQueue.main.async {
                    self.labelLocation.text = "London"
                    self.labelTemp.text = "\(formattedTemp)°"
                    self.labelWeatherDesc.text = weatherDesc.capitalized
//                        self.imageWeatherIcon.image = UIImage(named: weatherData.weather[0].icon ?? "none")
                }
            }
            catch let err {
                print("Err", err)
            }
        }.resume()
    }
}

struct CurrentWeather: Codable {
    let main: Main
    let weather: [Weather]
}

struct Main: Codable{
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}

