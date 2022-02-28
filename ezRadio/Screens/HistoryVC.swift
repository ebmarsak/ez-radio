//
//  HistoryVC.swift
//  ezRadio
//
//  Created by Teto on 4.02.2022.
//

import UIKit

class HistoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let historyTV = UITableView()
    var historyItems: [CacheRadio] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureTableView()
        
        if let savedHistory = UserDefaults.standard.object(forKey: "history") as? Data {
            do {
                let jsonDecoder = JSONDecoder()
                historyItems = try jsonDecoder.decode([CacheRadio].self, from: savedHistory)
            } catch {
                print("failed to load radio history")
            }
        }
        historyItems = historyItems.reversed()
    }
    
    func configureTableView() {
        view.addSubview(historyTV)
        
        historyTV.dataSource = self
        historyTV.delegate = self
        
        historyTV.frame = view.bounds
        historyTV.translatesAutoresizingMaskIntoConstraints = false
        historyTV.register(UITableViewCell.self, forCellReuseIdentifier: "historyCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        historyItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        cell.textLabel?.text = historyItems[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        historyTV.deselectRow(at: indexPath, animated: true)
        showAlert()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "History", message: "Play selected radio from history?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Play", style: .default, handler: { action in
            print("play tapped")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            print("cancel tapped")
        }))
        
        present(alert, animated: true)
    }
}
