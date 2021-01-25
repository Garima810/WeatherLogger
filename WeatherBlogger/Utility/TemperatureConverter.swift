//
//  TemperatureConverter.swift
//  WeatherBlogger
//
//  Created by Garima Ashish Bisht on 25/01/21.
//  Copyright © 2021 Garima Kushwah. All rights reserved.
//

import UIKit

class TemperatureConverter {
    
    static let shared: TemperatureConverter = TemperatureConverter()

    func convertTemperatureToCelsius(fahrenheitTemp: Int) -> Int {
        return (fahrenheitTemp-32) * (5/9)
    }

}
