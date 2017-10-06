//
//  WeatherData.swift
//  Generic
//
//  Created by TriNgo on 10/6/17.
//  Copyright © 2017 TriNgo. All rights reserved.
//

import Foundation

public struct WeatherData {
    
    public let lat: Double
    public let long: Double
    
    public let hourData: [WeatherHourData]
    
    public init(lat: Double, long: Double, hourData: [WeatherHourData]) {
        self.lat = lat
        self.long = long
        self.hourData = hourData
    }
}

