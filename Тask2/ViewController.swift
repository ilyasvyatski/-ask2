//
//  ViewController.swift
//  Тask2
//
//  Created by neoviso on 8/25/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var countryTableView: UITableView!
    @IBOutlet weak var countrySearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.countrySearchBar.delegate = self
        self.countryTableView.delegate = self
        self.countryTableView.dataSource = self
        
        getCountriesList()
    }
    
    private var countries: [String] = []
    private var filteredCountries: [String] = []
    
    //ведется ли поиск или нет
    private var isSearching = false
    
    func getCountriesList () {
        countries = Locale.isoRegionCodes.compactMap { Locale.current.localizedString(forRegionCode: $0) }
        countries.sort()
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //для начала очищаем массив, чтобы не хранить результаты прошлого поиска
        self.filteredCountries.removeAll()
        
        guard !searchText.isEmpty || searchText != " " else {
            return
        }
        
        for item in countries {
            let countryName = searchText.lowercased()
            let isArrayContain = item.lowercased().range(of: countryName)
            
            if isArrayContain != nil {
                filteredCountries.append(item)
            }
        }
        
        if searchBar.text == ""  {
            isSearching = false
            countryTableView.reloadData()
        } else {
            isSearching = true
            filteredCountries = countries.filter({ $0.contains(searchBar.text ?? "") })
            countryTableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredCountries.count
        } else {
            return countries.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewCell.countryCellId, for: indexPath) as? CountryTableViewCell  else {
            fatalError()
        }
        
        if isSearching {
            cell.textLabel?.text = filteredCountries[indexPath.row]
        } else {
            cell.textLabel?.text = countries[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching {
            if let url = URL(string: "https://en.wikipedia.org/wiki/\(filteredCountries.map { $0.replacingOccurrences(of: "\\s+", with: "_", options: .regularExpression) }[indexPath.row])") {
                        UIApplication.shared.open(url, options: [:])
                    }
        } else {
            if let url = URL(string: "https://en.wikipedia.org/wiki/\(countries.map { $0.replacingOccurrences(of: "\\s+", with: "_", options: .regularExpression) }[indexPath.row])") {
                        UIApplication.shared.open(url, options: [:])
                    }
        }
    }
}

