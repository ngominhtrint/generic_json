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
