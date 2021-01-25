//
//  Weather.swift
//  WeatherBlogger
//
//  Created by Garima Ashish Bisht on 23/01/21.
//  Copyright © 2021 Garima Kushwah. All rights reserved.
//

import UIKit

struct WeatherDetails: Codable {
    let weather: [Weather]
    let main: Main
    let sys: Sys
    let name: String?
    let dt: Int
    let timezone: Int?
    let dt_txt: String?
    let visibility : Int64?
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int64
    let humidity: Int64
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Sys: Codable {
    let country: String?
    let sunrise: Int?
    let sunset: Int?
    let id: Int?
    let type: Int?
}
