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
        tableView.separatorStyle = .none
        
        tableView.register(RadioStationCell.self, forCellReuseIdentifier: "rsCell")
        
        tableView.rowHeight = 170
        
    }
    
    // MARK: TableView functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return radioStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "rsCell", for: indexPath) as! RadioStationCell
        let currentRadioStation = radioStations[indexPath.row]
        
        cell.backgroundColor = indexPath.row % 2 == 0 ? .tertiarySystemBackground : .secondarySystemBackground
        
        cell.rsRadioName.text = currentRadioStation.name
        
        // Language info handling
        if currentRadioStation.language == "" {
            cell.rsLanguage.text = "N/A"
        } else {
            let trimmedLanguage = trimAfterComma(str: currentRadioStation.language!)
            cell.rsLanguage.text = trimmedLanguage.capitalized
        }
        
        // Tag info handling
        let modifiedTag = whitespaceAfterComma(str: currentRadioStation.tags!)
        cell.rsTags.text = modifiedTag
        
        // Image handling
        fetchImage(url: currentRadioStation.favicon) { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                cell.rsImageView.image = image
            }
        }
        
        // Button handling
        cell.rsPlayButton.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
        
        return cell
    }
    
    @objc func didTapPlayButton(){
        print("cell play button tapped")
    }
    
    // MARK: Cell component functions
    
    func trimAfterComma(str: String) -> String {
        var tempStr: String = str
        
        if let commaRange = tempStr.range(of: ",") {
            tempStr.removeSubrange(commaRange.lowerBound..<tempStr.endIndex)
        }
        
        return tempStr
    }
    
    func whitespaceAfterComma(str: String) -> String {
        let tempStr = str.replacingOccurrences(of: ",", with: ", ", options: .literal, range: nil)
        return tempStr
    }
    
    private func fetchImage(url: String, completion: @escaping (UIImage?) -> ())  {
        
        guard let url = URL(string: url) else {
            completion(UIImage(named: "RSPlaceholder"))
            return
        }
        
        let getDataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in 
            guard let data = data, error == nil else {
                completion(UIImage(named: "RSPlaceholder"))
                return
            }
           
            completion(UIImage(data: data))

        }
        
        getDataTask.resume()
    }
    
}

