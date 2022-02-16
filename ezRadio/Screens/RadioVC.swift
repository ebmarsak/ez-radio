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
    
    var countries: [Country] = []
    var languages: [Language] = []
    var tags: [Tag] = []
    
    var countryDataTemp: [String] = []
    let searchBarVC = SearchBarVC()
    
    lazy var searchController = UISearchController(searchResultsController: searchBarVC)
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
        configureSearchController()
        
        // TODO: async - await ile refactor edilcek.
        getCountryList()
        getLanguageList()
        getTagList()
        
    }
    
}

extension RadioVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchBarVC.selectedScope = selectedScope
        searchBarVC.tableView.reloadData()
    }
    
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}


// MARK: Button functions

extension RadioVC {
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



// MARK: Configure UI elements

extension RadioVC {
    
    func configureSearchController(){
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.searchResultsUpdater = self
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.placeholder = "Search stations by..."
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        searchController.searchBar.scopeButtonTitles = ["Country", "Language", "Tag"]
        
        searchController.searchBar.delegate = self
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
}

// MARK: Network Calls

extension RadioVC {
    
    
    
    func getCountryList() {
        
        NetworkManager.shared.getCountryList() { [weak self]
            result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let countries):
                self.countries.append(contentsOf: countries)
                self.searchBarVC.model.countries = self.countries.map {$0.name}
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
                self.searchBarVC.model.languages = self.languages.map {$0.name}
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
                self.searchBarVC.model.tags = self.tags.map {$0.name}
            case .failure(let error):
                print(error)
            }
        }
    }
}
