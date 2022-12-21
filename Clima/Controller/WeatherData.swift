//
//  WeatherData.swift
//  Clima
//
//  Created by Boughdiri Dorsaf on 14/12/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherDtata: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
}
