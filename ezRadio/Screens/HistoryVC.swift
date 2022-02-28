//
//  HistoryVC.swift
//  ezRadio
//
//  Created by Teto on 4.02.2022.
//

import UIKit

protocol PlayFromHistoryDelegate : AnyObject {
    func didTapHistoryPlayButton(name: String, url: String, image: String)
}

class HistoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var playFromHistoryDelegate: PlayFromHistoryDelegate?
    
    let historyTV = UITableView()
    var historyItems: [CacheRadio] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "History"
        getCacheFromSystem()
        configureTableView()
    }
    
    func getCacheFromSystem() {
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
        let radioName = historyItems[indexPath.row].name
        let radioImage = historyItems[indexPath.row].image
        let radioURL = historyItems[indexPath.row].url
        showAlert(name: radioName, image: radioImage, url: radioURL)
    }
    
    func showAlert(name: String, image: String, url: String) {
        let alert = UIAlertController(title: "History", message: "Play selected radio from history?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Play", style: .default, handler: { action in
            print("play tapped")
            self.playFromHistoryDelegate?.didTapHistoryPlayButton(name: name, url: url, image: image)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            print("cancel tapped")
        }))
        
        present(alert, animated: true)
    }
}
