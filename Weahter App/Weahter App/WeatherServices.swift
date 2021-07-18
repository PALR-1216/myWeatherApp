//
//  WeatherService.swift
//  Weahter App
//
//  Created by Pedro Alejandro on 11/30/20.
//

import Foundation
import CoreLocation


public final class WeatherServices: NSObject{
    private let locationManageer = CLLocationManager()
    private let API_Key = "ef659fb0fbfec94c77f2ce8b713e9866"
    private var completionHandler: ((Weather) -> Void)?
    
    public override init() {
        super.init()
        locationManageer.delegate = self
    }
    
    public func loadWeatherData(_ completionHandler: @escaping((Weather) -> Void)) {
        self.completionHandler = completionHandler
        locationManageer.requestWhenInUseAuthorization()
        locationManageer.startUpdatingLocation()
    }
    
    //https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
    private func makeDataRequest(forCoordinates coordinates: CLLocationCoordinate2D) {
        guard let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=\(API_Key)&units=imperial".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else {
            return
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil, let data = data else { return}
            if let response = try? JSONDecoder().decode(APIResponse.self, from: data){
                self.completionHandler?(Weather(response: response))
            }
        }.resume()
    }
}

extension WeatherServices: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager,didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first
        else {
            return
        }
        makeDataRequest(forCoordinates: location.coordinate)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("Someting went wrong: \(error.localizedDescription)")
    }
}
struct APIResponse: Decodable {
    let name: String
    let main: APIMain
    let weather: [APIWeather]
}

struct APIMain: Decodable {
    let temp: Double
    
}

struct APIWeather: Decodable {
    let description: String
    let iconName: String
    
    enum CodingKeys: String, CodingKey {
        case description
        case iconName = "main"
    }
}
