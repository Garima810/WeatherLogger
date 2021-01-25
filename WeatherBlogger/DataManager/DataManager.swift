//
//  DataManager.swift
//  WeatherBlogger
//
//  Created by Garima Ashish Bisht on 23/01/21.
//  Copyright © 2021 Garima Kushwah. All rights reserved.
//

import UIKit

enum NetworkError : Error {
    case invalidURL
    case invalidResponse(Data? , URLResponse?)
}

class DataManager {
    
    static let shared: DataManager = DataManager()
    
    
    func getWeatherDetails(urlString: String, completionBlock : @escaping (Result <WeatherDetails, Error>) -> Void)
    {
        
        guard let url = URL(string: urlString) else {
            completionBlock(.failure(NetworkError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                if let error = error {
                    completionBlock(.failure(error))
                    return
                }
                return
            }
            
            guard let responseData = data,
                let httpResponse = response as? HTTPURLResponse,
                200 ..< 300 ~= httpResponse.statusCode else {
                    completionBlock(.failure(NetworkError.invalidResponse(data, response)))
                    return
            }
    
            do {
                let currentWeather = try JSONDecoder().decode(WeatherDetails.self, from: responseData)
                print(responseData.description)
                completionBlock(.success(currentWeather))
            } catch {
                print(error)
            }
        }
        task.resume()
    }

}
