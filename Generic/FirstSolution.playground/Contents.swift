//: Playground - noun: a place where people can play

import Foundation

// Fetch URL
let url = Bundle.main.url(forResource: "response", withExtension: "json")!

// Load Data
let data = try! Data(contentsOf: url)

// Deserialize JSON
let JSON = try! JSONSerialization.jsonObject(with: data, options: [])

/**
 * SOLUTION 1: QUICK AND DIRTY
 */
// Parse WeatherData without WeatherHourData
if let JSON = JSON as? [String: AnyObject] {
    if let lat = JSON["latitude"] as? Double, let long = JSON["longitude"] as? Double {
        let weatherData = WeatherData(lat: lat, long: long, hourData: [])
    }
}

// Parse WeatherData within WeatherHourData
if let JSON = JSON as? [String: AnyObject] {
    if let lat = JSON["latitude"] as? Double,
        let long = JSON["longitude"] as? Double,
        let hourlyData = JSON["hourly"]?["data"] as? [[String: AnyObject]] {

        // Create Buffer
        var hourData = [WeatherHourData]()

        for hourlyDataPoint in hourlyData {
            if let time = hourlyDataPoint["time"] as? Double,
                let windSpeed = hourlyDataPoint["windSpeed"] as? Int,
                let temperature = hourlyDataPoint["temperature"] as? Double,
                let precipitation = hourlyDataPoint["precipIntensity"] as? Double {
                // Convert Time to Date
                let timeAsDate = Date(timeIntervalSince1970: time)

                // Create Weather Hour Data
                let weatherHourData = WeatherHourData(time: timeAsDate, windSpeed: windSpeed, temperature: temperature, precipitation: precipitation)

                // Append to Buffer
                hourData.append(weatherHourData)
            }
        }

        let weatherData = WeatherData(lat: lat, long: long, hourData: hourData)
    }
}
