//
//  ViewController.swift
//  City2City-J22
//
//  Created by mac on 1/27/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var homeTableView: UITableView!
    
    //didSet, willSet - property observer - runs block of code after value has changed
    var cities = [City]() {
        didSet {
           orderedCities = orderCities(cities)
        }
    }
    
    var orderedCities = [String:[City]]() {
        didSet {
            DispatchQueue.main.async {
                self.homeTableView.reloadData()
            }
        }
    }
    
    var filteredCities = [City]() {
        didSet {
            DispatchQueue.main.async {
                self.homeTableView.reloadData()
            }
        }
    }
    
    //stored property - value set
    let searchCtrl = UISearchController(searchResultsController: nil)
    
    //computed property - value is computed every time requested
    var isFiltering: Bool {
        return !searchCtrl.searchBar.text!.isEmpty && searchCtrl.isActive
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHome()
        setupSearchBar()
    }
    
    //MARK: setup home
    private func setupHome() {
        CityManager.getCities { [weak self] result in //capture list has weak self
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { //don't do this, only for example
                self?.cities = result
                print("City Count: \(result.count)")
            }
        }
        homeTableView.tableFooterView = UIView(frame: .zero) // get rid of unused rows
    }
    
    //MARK: setup search
    private func setupSearchBar() {
        searchCtrl.searchResultsUpdater = self
        navigationItem.searchController = searchCtrl
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController?.obscuresBackgroundDuringPresentation = false
    }
    
    //MARK: order cities
    
    private func orderCities(_ cities: [City]) -> [String: [City]] {
        /* Long Way
         var orderedDict = [String:[City]]()
         for city in cities {
         let letter = city.name.first!.uppercased()
         if orderedDict[letter] != nil {
         orderedDict[letter]!.append(city)
         } else {
         orderedDict[letter]! = [city]
         }
         }
         */
        
        //order the dictionary by city name
        var orderedDict = Dictionary(grouping: cities) { city -> String in
            return city.name.first!.uppercased()
        }
        
        //alphabetize the cities
        for (key, value) in orderedDict {
            orderedDict[key] = value.sorted(by: { one, two -> Bool in
                one.name < two.name
            })
        }
        
        return orderedDict
    }
    
    private func getCities(from section: Int) -> [City] {
        let keys = orderedCities.keys.sorted(by: { $0 < $1}) //sort in ascending order
        let key = keys[section]
        return orderedCities[key]!
    }
    
    func filter(_ search: String) {
        filteredCities = [] //clear filtered cities
        filteredCities = cities.filter({$0.name.lowercased().hasPrefix(search.lowercased())})
    }
    
}

//MARK: Home TableView
extension HomeViewController: UITableViewDataSource {
    //number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return isFiltering ? 1 : orderedCities.keys.count
    }
    //number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cits = isFiltering ? filteredCities : getCities(from: section)
        return cits.count
    }
    
    //rendering each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableCell", for: indexPath) as! CityTableCell
        let cits = isFiltering ? filteredCities : getCities(from: indexPath.section) //get correct cities
        let city = cits[indexPath.row] //city for specific row
        cell.mainLabel.text = "\(city.name), \(city.state)"
        let pop = city.population.addCommas ?? "not available" //nil coalescing
        cell.subLabel.text = "Population: \(pop)"
        return cell
    }
    
    //header for section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let keys = orderedCities.keys.sorted(by: { $0 < $1})
        return isFiltering ? "Cities" : keys[section]
    }
}

extension HomeViewController: UITableViewDelegate {
    //controls the height of each row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    //controls side alphabet index
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        let keys = orderedCities.keys.sorted(by: { $0 < $1})
        return isFiltering ? nil : keys
    }
    //handles touch events for row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cities = isFiltering ? filteredCities : getCities(from: indexPath.section)
        let city = cities[indexPath.row]
        CityManager.save(city)
        
        let mapVC = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        mapVC.city = city
        
        navigationController?.view.backgroundColor = .white //remove black flicker on top right
        navigationController?.pushViewController(mapVC, animated: true) //push onto the stack
    }
}

//MARK: Search Bar Delegate

extension HomeViewController: UISearchResultsUpdating {
    //called every time user types in search bar
    func updateSearchResults(for searchController: UISearchController) {
        guard let message = searchController.searchBar.text else { return }
        filter(message)
    }
}
