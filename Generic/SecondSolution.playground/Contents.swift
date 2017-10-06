//: Playground - noun: a place where people can play

import Foundation

// Fetch URL
let url = Bundle.main.url(forResource: "response", withExtension: "json")!

// Load Data
let data = try! Data(contentsOf: url)

// Deserialize JSON
let JSON = try! JSONSerialization.jsonObject(with: data, options: [])

/**
 * SOLUTION 2: PROTOCOL AND EXTENSION
 */
protocol JSONDecodable {

    init?(JSON: Any)
}

extension WeatherData: JSONDecodable {
    init?(JSON: Any) {
        guard let JSON = JSON as? [String: AnyObject] else { return nil }

        guard let lat = JSON["latitude"] as? Double else { return nil }
        guard let long = JSON["longitude"] as? Double else { return nil }
        guard let hourlyData = JSON["hourly"]?["data"] as? [[String: AnyObject]] else { return nil }

        self.lat = lat
        self.long = long

        var buffer = [WeatherHourData]()

        for hourlyDataPoint in hourlyData {
            if let weatherHourData = WeatherHourData(JSON: hourlyDataPoint) {
                buffer.append(weatherHourData)
            }
        }

        self.hourData = buffer
    }
}

extension WeatherHourData: JSONDecodable {
    init?(JSON: Any) {
        guard let JSON = JSON as? [String: AnyObject] else { return nil }

        guard let time = JSON["time"] as? Double else { return nil }
        guard let windSpeed = JSON["windSpeed"] as? Int  else { return nil }
        guard let temperature = JSON["temperature"] as? Double else { return nil }
        guard let precipitation = JSON["precipIntensity"] as? Double else { return nil }

        self.windSpeed = windSpeed
        self.temperature = temperature
        self.precipitation = precipitation
        self.time = Date(timeIntervalSince1970: time)
    }
}

if let weatherData = WeatherData(JSON: JSON) {
     print(weatherData)
}


