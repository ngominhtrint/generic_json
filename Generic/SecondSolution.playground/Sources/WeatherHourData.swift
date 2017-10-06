import Foundation

public struct WeatherHourData {
    
    public let time: Date
    public let windSpeed: Int
    public let temperature: Double
    public let precipitation: Double
    
    public init(time: Date, windSpeed: Int, temperature: Double, precipitation: Double) {
        self.time = time
        self.windSpeed = windSpeed
        self.temperature = temperature
        self.precipitation = precipitation
    }
}
