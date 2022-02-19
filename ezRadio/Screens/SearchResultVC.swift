//
//  SearchResultVC.swift
//  ezRadio
//
//  Created by Teto on 7.02.2022.
//

import UIKit

class SearchResultVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var radioStations: [RadioStation] = []
    
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.frame = view.bounds
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(RadioStationCell.self, forCellReuseIdentifier: "rsCell")
        
        tableView.rowHeight = 160
        
    }
    
    // MARK: TableView functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return radioStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "rsCell", for: indexPath) as! RadioStationCell
        
        let currentRadioStation = radioStations[indexPath.row]
        
        cell.rsRadioName.text = currentRadioStation.name
        cell.rsLanguage.text = currentRadioStation.language
        cell.rsTags.text = currentRadioStation.tags
        
        //cell.rsImageView.image = fetchImage(url: currentRadioStation.favicon)
        
        
        return cell
    }
}

