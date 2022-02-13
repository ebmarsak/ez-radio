//
//  SearchResultVC.swift
//  ezRadio
//
//  Created by Teto on 7.02.2022.
//

import UIKit

class SearchResultVC: UIViewController {

    let tableView = UITableView()
    let searchButton = EZPlayButton(backgroundColor: .systemRed, title: "Search")
    
    var radioStations: [RadioStation] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTableView()
        configureSearchButton()
        
        
    }
    
    func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
    
    func configureSearchButton() {
        view.addSubview(searchButton)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        
        searchButton.addTarget(self, action: #selector(getStationsButton), for: .touchUpInside)
        
        
        NSLayoutConstraint.activate([
            searchButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 80),
            searchButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -80),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    
    
    @objc func getStationsButton() {
        getStations(country: "japan")
    }
    
    func getStations(country: String) {
        NetworkManager.shared.getRadioStationsByCountry(forCountry: country) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let radioStations):
                self.radioStations.append(contentsOf: radioStations)
                print(radioStations.description)
                
            case .failure(let error):
                print(error)
            }
            
            
        }
    }
    
   
}

extension SearchResultVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Hello World"
        return cell
    }
    
}
