//
//  WeatherBlogger+CoreDataProperties.swift
//  WeatherBlogger
//
//  Created by Garima Ashish Bisht on 25/01/21.
//  Copyright © 2021 Garima Kushwah. All rights reserved.
//
//

import Foundation
import CoreData


extension WeatherBlogger {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherBlogger> {
        return NSFetchRequest<WeatherBlogger>(entityName: "WeatherBlogger")
    }

    @NSManaged public var date: Date?
    @NSManaged public var temperature: Double
    @NSManaged public var minTemp: Double
    @NSManaged public var maxTemp: Double
    @NSManaged public var humidity: Int64
    @NSManaged public var visibility: Int64
    @NSManaged public var name: String?
    @NSManaged public var pressure: Int64
    @NSManaged public var feelsLike: Double
    @NSManaged public var mainDescription: String?

}
