//
//  SearchBarVC.swift
//  ezRadio
//
//  Created by Teto on 12.02.2022.
//

import UIKit

struct SearchBarData {
    var countries: [String]
    var languages: [String]
    var tags: [String]
}

class SearchBarVC: UIViewController {
        
    var model : SearchBarData = SearchBarData(countries: [], languages: [], tags: [])
    var selectedScope : Int = 0
    
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
        
        // sinpaş: tepede çağırınca crash
        
        
        
        
    }

  
}

extension SearchBarVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch selectedScope {
        case 0:
            return model.countries.count
        case 1:
            return model.languages.count
        case 2:
            return model.tags.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
       
        var cellArray : [String]?
        
        switch selectedScope {
        case 0:
            cellArray = model.countries
        case 1:
            cellArray = model.languages
        case 2:
            cellArray = model.tags
        default:
            break
        }
        
        cell.textLabel?.text = cellArray?[indexPath.row]

        return cell
    }
}




