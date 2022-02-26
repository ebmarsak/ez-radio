//
//  SearchResultVC.swift
//  ezRadio
//
//  Created by Teto on 7.02.2022.
//

import UIKit

protocol PlayRadioButtonDelegate : AnyObject {
    func didTapRSPlayButton(name: String, url: String, favicon: String)
}

class SearchResultVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var playRadioButtonDelegate: PlayRadioButtonDelegate?
    
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
        tableView.separatorStyle = .none
        
        tableView.register(RadioStationCell.self, forCellReuseIdentifier: "rsCell")
        
        tableView.rowHeight = 200
    }
    
    // MARK: TableView functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return radioStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "rsCell", for: indexPath) as! RadioStationCell
        cell.currentRadioStation = radioStations[indexPath.row]
        cell.playRadioButtonDelegate = self.playRadioButtonDelegate
        cell.configure()
        cell.backgroundColor = indexPath.row % 2 == 0 ? .tertiarySystemBackground : .secondarySystemBackground
        
        return cell
    }
}


extension String {
    
    func trimAfterComma() -> String {
        var tempStr: String = self
        
        if let commaRange = tempStr.range(of: ",") {
            tempStr.removeSubrange(commaRange.lowerBound..<tempStr.endIndex)
        }
        
        return tempStr
    }
    
    func whitespaceAfterComma() -> String {
        let tempStr = self.replacingOccurrences(of: ",", with: ", ", options: .literal, range: nil)
        return tempStr
    }
}
