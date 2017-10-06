//: Playground - noun: a place where people can play

import Foundation

// Fetch URL
let url = Bundle.main.url(forResource: "response", withExtension: "json")!

// Load Data
let data = try! Data(contentsOf: url)

// Deserialize JSON
let JSON = try! JSONSerialization.jsonObject(with: data, options: [])

/**
 * SOLUTION 3
 */

protocol Decodable {
    init(decoder: Decoder) throws
}

public enum DecoderError: Error {
    case invalidData
    case keyNotFound(String)
    case keyPathNotFound(String)
}

public struct Decoder {
    
    typealias JSON = [String: AnyObject]
    private let JSONData: JSON
    
    private init(JSONData: JSON) {
        self.JSONData = JSONData
    }
    
    public init(data: Data) throws {
        if let JSONData = try JSONSerialization.jsonObject(with: data, options: []) as? JSON {
            self.JSONData = JSONData
        } else {
            throw DecoderError.invalidData
        }
    }
    
    func decode<T>(key: String) throws -> T {
        if key.contains(".") {
            return try value(forKeyPath: key)
        }
        
        guard let value: T = try? value(forKey: key) else { throw DecoderError.keyNotFound(key) }
        return value
    }
    
    private func value<T>(forKey key: String) throws -> T {
        guard let value = JSONData[key] as? T else { throw DecoderError.keyNotFound(key) }
        return value
    }
    
    private func value<T>(forKeyPath keyPath: String) throws -> T {
        var partial = JSONData
        
        let keys = keyPath.components(separatedBy: ".")
        
        for i in 0..<keys.count {
            if i < keys.count - 1 {
                if let partialJSONData = JSONData[keys[i]] as? JSON {
                    partial = partialJSONData
                } else {
                    throw DecoderError.invalidData
                }
            } else {
                print(keys[i])
                print(partial)
                return try Decoder(JSONData: partial).value(forKey: keys[i])
            }
        }
        
        throw DecoderError.keyPathNotFound(keyPath)
    }
}

extension WeatherData: Decodable {
    init(decoder: Decoder) throws {
        self.lat = try decoder.decode(key: "latitude")
        self.long = try decoder.decode(key: "longitude")
        self.hourData = try decoder.decode(key: "hourly.data")
    }
}

extension WeatherHourData: Decodable {
    init(decoder: Decoder) throws {
        self.windSpeed = try decoder.decode(key: "windSpeed")
        self.temperature = try decoder.decode(key: "temperature")
        self.precipitation = try decoder.decode(key: "precipIntensity")
        
        let time: Double = try decoder.decode(key: "time")
        self.time = Date(timeIntervalSince1970: time)
    }
}

do {
    let decoder = try Decoder(data: data)
    let weatherData = try WeatherData(decoder: decoder)
    print(weatherData)
} catch {
    print(error)
}
