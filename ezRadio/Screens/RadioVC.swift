//
//  RadioVC.swift
//  ezRadio
//
//  Created by Teto on 4.02.2022.
//

import UIKit
import AVKit
import AVFoundation

class RadioVC: UIViewController {
    
    
    lazy var searchController: UISearchController = {
        let s = UISearchController(searchResultsController: SearchBarVC())
        
        s.searchResultsUpdater = self
        
        s.obscuresBackgroundDuringPresentation = false
        s.searchBar.enablesReturnKeyAutomatically = false
        s.searchBar.placeholder = "Search stations by..."
        s.searchBar.returnKeyType = UIReturnKeyType.done
        s.searchBar.scopeButtonTitles = ["Country", "Language", "Tag"]
    
        s.searchBar.delegate = self
        return s
    }()
    
    let searchTV: UITableView = SearchBarVC().tableView
    
    let playButton = EZPlayButton(backgroundColor: .systemIndigo, title: "Play")
    var avPlayer: AVPlayer?
    var avPlayerItem: AVPlayerItem?
    
    let favoritesButton = UIButton()
    let historyButton = UIButton()
    
    var radioStations: [RadioStation] = []
    let radioStationExample = RadioStation(name: "Jap", urlResolved: "https://relay0.r-a-d.io/main.mp3", favicon: "", country: "Japan")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureSearchController()
        configurePlayButton()
        configureSideButtons()
    }
    
    func configureSearchController() {
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    func configurePlayButton() {
        
        view.addSubview(playButton)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        
        playButton.addTarget(self, action: #selector(startRadioButton), for: .touchUpInside)
        
        
        NSLayoutConstraint.activate([
            playButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 80),
            playButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -80),
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func configureSideButtons() {
        
        let padding : CGFloat = 20
        
        favoritesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        historyButton.setImage(UIImage(systemName: "clock.fill"), for: .normal)
        
        favoritesButton.tintColor = .systemPink
        historyButton.tintColor = .systemBlue
        
        
        view.addSubview(favoritesButton)
        view.addSubview(historyButton)
        
        favoritesButton.translatesAutoresizingMaskIntoConstraints = false
        historyButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            historyButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            historyButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            
            favoritesButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            favoritesButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding)
        ])
        
        favoritesButton.addTarget(self, action: #selector(pushFavoritesVC), for: .touchUpInside)
        historyButton.addTarget(self, action: #selector(pushHistoryVC), for: .touchUpInside)
        
    }
    
    @objc func startRadioButton() {
        
        //let urlString = "https://relay0.r-a-d.io/main.mp3"
        let url = URL(string: radioStationExample.urlResolved)
        print("playing radio: \(radioStationExample.name) with url: \(radioStationExample.urlResolved)")
        
        avPlayerItem = AVPlayerItem.init(url: url! as URL)
        avPlayer = AVPlayer.init(playerItem: avPlayerItem)
        avPlayer?.automaticallyWaitsToMinimizeStalling = false
        avPlayer?.play()
        
    }
    
    @objc func pushFavoritesVC() {
        let favoritesVC = FavoritesVC()
        navigationController?.pushViewController(favoritesVC, animated: true)
    }
    
    @objc func pushHistoryVC() {
        let historyVC = HistoryVC()
        navigationController?.pushViewController(historyVC, animated: true)
    }
}

extension RadioVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        //activeScope = selectedScope.description
    }
    
    
    
    func updateSearchResults(for searchController: UISearchController) {

    }
}



//        let s = UISearchController(searchResultsController: SearchBarVC())
//        if let searchBarVC = s.searchResultsController as? SearchBarVC {
//            searchBarVC.countryArray
//        }


