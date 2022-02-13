//
//  SearchBarVC.swift
//  ezRadio
//
//  Created by Teto on 12.02.2022.
//

import UIKit

class SearchBarVC: UIViewController {
  
    var countries: [Country] = []
    var languages: [Language] = []
    var tags: [Tag] = []
    
    var searchCountry = [String]()
    
    let searchBar = UISearchBar()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tv.dataSource = self
        tv.delegate = self
        
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        /*
        if activeScope == "Country" {
            getCountryList()
        } else if activeScope == "Language" {
            getLanguageList()
        } else {
            getTagList()
        }
        */
        
        getCountryList()
    }
    
    func getCountryList() {
        
        
            NetworkManager.shared.getCountryList() { [weak self]
                result in
                
                guard let self = self else { return }
                
                switch result {
                case .success(let countries):
                    self.countries.append(contentsOf: countries)
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.tableView.reloadData()
                    }
                    print(countries.description)
                    
                case .failure(let error):
                    print(error)
                }
                
            }
        }
    
    func getLanguageList() {
        
        
            NetworkManager.shared.getLanguageList() { [weak self]
                result in
                
                guard let self = self else { return }
                
                switch result {
                case .success(let languages):
                    self.languages.append(contentsOf: languages)
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.tableView.reloadData()
                    }
                    
                case .failure(let error):
                    print(error)
                }
                
            }
        }
    
    func getTagList() {
        
        
            NetworkManager.shared.getTagList() { [weak self]
                result in
                
                guard let self = self else { return }
                
                switch result {
                case .success(let tags):
                    self.tags.append(contentsOf: tags)
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.tableView.reloadData()
                    }
                    
                case .failure(let error):
                    print(error)
                }
                
            }
        }
  
}

extension SearchBarVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        /*
        var activeScope = radioVC.tempScope
        
        if activeScope == "Country" {
            return countries.count
        } else if activeScope == "Language" {
            return languages.count
        } else {
            return tags.count
        }
        */
        
        return countries.count
        //return languages.count
        //return tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        /*
        var activeScope = radioVC.tempScope
        
        if activeScope == "Country" {
            getCountryList()
            cell.textLabel?.text = countries[indexPath.row].name
        } else if activeScope == "Language" {
            getLanguageList()
            cell.textLabel?.text = languages[indexPath.row].name
        } else {
            getTagList()
            cell.textLabel?.text = tags[indexPath.row].name
        }
        */
 
        cell.textLabel?.text = countries[indexPath.row].name
        //cell.textLabel?.text = languages[indexPath.row].name
        //cell.textLabel?.text = tags[indexPath.row].name

        return cell
    }
    
}
