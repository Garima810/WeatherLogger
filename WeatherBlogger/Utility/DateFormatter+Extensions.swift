//
//  DateFormatter+Extensions.swift
//  WeatherBlogger
//
//  Created by Garima Ashish Bisht on 23/01/21.
//  Copyright © 2021 Garima Kushwah. All rights reserved.
//


import Foundation

extension DateFormatter {

    static var sharedDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        // Add your formatter configuration here
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
}

