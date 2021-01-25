//
//  ViewController.swift
//  WeatherBlogger
//
//  Created by Garima Ashish Bisht on 23/01/21.
//  Copyright © 2021 Garima Kushwah. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    let API_KEY = "f3d5bf38d606a04438f1a94f14a81357"
    let screenTitle = "Weather Logger"

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var detailsButton: UIButton!
    
    @IBOutlet weak var currentLocation: UILabel!
    
    @IBOutlet weak var temperature: UILabel!
    
    @IBOutlet weak var currentDate: UILabel!
    
    @IBOutlet weak var cityNameTextField: UITextField!
    
    private var weatherModel: WeatherDetails?
    private var saveButtonPressed: Bool = false
    
    private var currentLoc: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.title = screenTitle
        cityNameTextField.delegate = self
        detailsButton.isEnabled = false

        activityIndicator.hidesWhenStopped = true
        // Do any additional setup after loading the view.

    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureLocationManager()

    }
    
    func configureLocationManager() {
        
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func fetchWeatherDetails(latitude: Double?, longitude: Double?) {
        
        var  url = String(format: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude ?? 0.0 )&lon=\(longitude ?? 0.0)&units=metric&appid=%@",API_KEY)
        
    
        if let city = cityNameTextField.text  {
            if saveButtonPressed {
               url  = String(format: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=%@",API_KEY)
            }
        }
       
        
        DataManager.shared.getWeatherDetails(urlString: url){[weak self] (result) in
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let weatherModel):
                DispatchQueue.main.async {
                    strongSelf.activityIndicator.stopAnimating()
                    strongSelf.weatherModel = weatherModel
                    strongSelf.updateWeatherDetailsOnUI(weatherModel: weatherModel)
                }
            case .failure(let error):
                
                print("Error \(error.localizedDescription)")
                DispatchQueue.main.async {
                    strongSelf.activityIndicator.stopAnimating()
                }

            }
        }
    }
    
    private func updateWeatherDetailsOnUI(weatherModel: WeatherDetails) {
        currentLocation.text = String(weatherModel.name ?? "Riga")
        var temp = Int(round(weatherModel.main.temp))
        if temp > 70 {
            temp = TemperatureConverter.shared.convertTemperatureToCelsius(fahrenheitTemp: temp)
        }
        temperature.text = String(format: "%d°", temp)
        let date = DateFormatter.sharedDateFormatter.string(from: Date())
        currentDate.text = date
        
    }
    
    private func configureCoreDataEntity() {
        
        if let entity =  CoreDataHelper.sharedInstance().createEntityWithName("WeatherBlogger", uniqueKey: nil, value: nil) as? WeatherBlogger {
            entity.date = Date()
            entity.temperature = weatherModel?.main.temp ?? 0.0
            entity.minTemp = weatherModel?.main.temp_min ?? 0.0
            entity.maxTemp = weatherModel?.main.temp_max ?? 0.0
            entity.feelsLike = weatherModel?.main.feels_like ?? 0.0
            entity.humidity = weatherModel?.main.humidity ?? 0
            entity.mainDescription = weatherModel?.weather[0].description
            entity.visibility = weatherModel?.visibility ?? 0
            entity.name = weatherModel?.name ?? "Riga"
        }
        
    }
       
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        saveButtonPressed = true
        fetchWeatherDetails(latitude: currentLoc?.coordinate.latitude, longitude: currentLoc?.coordinate.longitude)
        configureCoreDataEntity()
        CoreDataHelper.sharedInstance().saveContext()
        detailsButton.isEnabled = true
        
    }


    @IBAction func detailsButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController")
        self.navigationController?.pushViewController(detailViewController, animated: true)

    }
    
}


extension ViewController : CLLocationManagerDelegate {
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        
    }
   
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        activityIndicator.startAnimating()
        guard let location = locations.last else { return }
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            print("long = \(location.coordinate.longitude)", "lat = \(location.coordinate.latitude)")
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            currentLoc = locationManager.location
            fetchWeatherDetails(latitude: latitude, longitude: longitude)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        
    }
       

}

extension ViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
       return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
