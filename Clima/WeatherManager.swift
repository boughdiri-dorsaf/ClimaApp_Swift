//
//  WeatherManager.swift
//  Clima
//
//  Created by Boughdiri Dorsaf on 13/12/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
    
}

struct WeatherManager {
    
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=1556efb6097bf5fabdf0a83cd007b0e8&units=metric"
    
    var delegate: WeatherManagerDelegate?

    func fetchWeather(cityName: String){
        let urlString = "\(weatherUrl)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longtitude: CLLocationDegrees){
        let urlString = "\(weatherUrl)&lat=\(latitude)&lon=\(longtitude)"
        performRequest(urlString: urlString)
    }
    
    //Reusable part !!
    func performRequest(urlString: String) {
        //1 - Create URL
        if let url = URL(string: urlString) {
            
            // 2 - Create a URLSession
            let session = URLSession(configuration: .default)
            
            // 3 - Give the session task
            let task = session.dataTask(with: url)  { (data, response, error) in
                
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather =  parseJSON(weatherData: safeData) {
                        delegate?.didUpdateWeather(self ,weather: weather)
                            
                    }
                }
            }
            
            // 4 - Start the task
            task.resume()
            
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherDtata.self, from: weatherData)
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            
            let weather = WeatherModel(id: id, cityName: name, temp: temp)
            
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
            
        }
    }
    
    
    
    
}
