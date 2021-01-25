//
//  DetailViewController.swift
//  WeatherBlogger
//
//  Created by Garima Ashish Bisht on 25/01/21.
//  Copyright © 2021 Garima Kushwah. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var weatherData: [WeatherBlogger] = [WeatherBlogger]()
    var weatherDetailDescription = [String]()
    var weatherParameters = ["Place","Humidity","Visibility","Temperature","Max Temperature","Min Temperature", "Feels Like", "Weather Description"]
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWeatherData()
        configureWeatherDetailParams()
        configureSubviews()
        // Do any additional setup after loading the view.
    }
    
    func configureSubviews() {
        tableView.register(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = UIColor.white
        
    }
    
    func configureWeatherData() {
        guard let data = CoreDataHelper.sharedInstance().getListOfEntityWithName("WeatherBlogger", withPredicate: nil, sortKey: nil, isAscending: true) as? [WeatherBlogger] else {
            return
        }
        weatherData = data
    }
    
    func configureWeatherDetailParams() {
        
        if let weatherDetail = weatherData.last {
            if let name = weatherDetail.name, let desc = weatherDetail.mainDescription {
                
                weatherDetailDescription.append(name)
                weatherDetailDescription.append(String(format: "%d%%", weatherDetail.humidity))
                weatherDetailDescription.append(String(format: "%d km", weatherDetail.visibility/1000))
                weatherDetailDescription.append(String(format: "%.0f°", ceil(weatherDetail.temperature)))
                weatherDetailDescription.append(String(format: "%.0f°", ceil(weatherDetail.maxTemp)))
                weatherDetailDescription.append(String(format: "%.0f°", ceil(weatherDetail.minTemp)))
                weatherDetailDescription.append(String(format: "%.0f°", weatherDetail.feelsLike))
                weatherDetailDescription.append(desc)

            }
        }
    }
    
    
}

extension DetailViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherParameters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: DetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as? DetailTableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = UIColor(red: 67.0/255.0, green: 146.0/255.0, blue: 226.0/255.0, alpha: 1.0)
        cell.selectionStyle = .none
        if weatherDetailDescription.count > 0 {
           cell.leftDescription.text = weatherDetailDescription[indexPath.row]
        }
        cell.lblLeftTitle.text = weatherParameters[indexPath.row]
        
        return cell
    }
    
    
}
extension DetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

