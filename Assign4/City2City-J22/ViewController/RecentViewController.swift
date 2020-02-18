//
//  RecentViewController.swift
//  City2City-J22
//
//  Created by mac on 1/31/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class RecentViewController: UIViewController {
    
    @IBOutlet weak var recentTableView: UITableView!
    
    var recentCities = [City]() {
        didSet {
            DispatchQueue.main.async {
                self.recentTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recentCities = CityManager.load()
    }
    
    
    private func setupRecent() {
        recentTableView.tableFooterView = UIView(frame: .zero)
    }
  
}

//MARK: Recent TableView
extension RecentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentTableCell", for: indexPath) as! RecentTableCell
        let city = recentCities[indexPath.row]
        let pop = city.population.addCommas ?? "Not Available"
        cell.recentMainLabel.text = "\(city.name), \(city.state)"
        cell.recentSubLabel.text = "Population: \(pop)"
        return cell
    }
    
}

extension RecentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = recentCities[0]
        tableView.deselectRow(at: indexPath, animated: true)
        let mapVC = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        mapVC.city = city
        
        navigationController?.view.backgroundColor = .white
        navigationController?.pushViewController(mapVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let city = recentCities[indexPath.row]
            CityManager.remove(city)
            recentCities.remove(at: indexPath.row)
        }
    }
    
}
