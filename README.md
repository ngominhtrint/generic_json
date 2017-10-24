# generic_json
Decoding JSON data by using generic in Swift

## 1st solution: Quick and dirty
The first solution is going to be the easiest way to understand. But this solution has several major drawbacks that become evident as we implement the solution.

We create an instance of `WeatherData` using the JSON response. This doesn't look too bad. Right?

```
if let JSON = JSON as? [String: AnyObject] {
    if let lat = JSON["latitude"] as? Double, let long = JSON["longitude"] as? Double {
        let weatherData = WeatherData(lat: lat, long: long, hourData: [])
    }
}
```

Even though it doesn't look terrible, take a look on the next snippet in which we parse the hourly weather data. This is starting to look like a bad idea.

```
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

```

We achived the goal we set out to achieve, but the approach we took needs to change. The current implementation is too brittle and overly complex. Let me show you how we can improve this by using protocols and extensions.

## 2nd solution: Protocols and extensions
We can improve the above solution with protocols and extensions. In the Project Navigator, create a new file in the Sources group, JSONDecodable.swift

```
protocol JSONDecodable {

    init?(JSON: Any)
}
```

We declare a protocol, `JSONDecodable`, with one method, a failable initializer that accepts a parameters of type `Any`. If we make the `WeatherData` and `WeatherHourData` structures conform to this protocol, we can move most of the logic we wrote earlier to their corresponding structures.

Open WeatherData.swift and add an extension for the `JSONDecodable` protocol. In the failable initializer, we add the logic for creating an instance of the structure with an object of type `Any`.

We also need to conform the `WeatherHourData` structure to `JSONDecodable` protocol. The implementation looks very similar.

Head back to playground to see if everything is working as expected. To create an instance of `WeatherData` structure, we invoke the `init(JSON: )` failable initializer. This returns an optional. In other words, if the JSON data isn't structured correctly, the initialization fails. We could also make the initializer throwing, which may be a better option.

```
if let weatherData = WeatherData(JSON: JSON) {
     print(weatherData)
}
```

## 3rd solution

