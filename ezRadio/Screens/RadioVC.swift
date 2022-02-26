//
//  RadioVC.swift
//  ezRadio
//
//  Created by Teto on 4.02.2022.
//

import UIKit
import AVKit
import AVFoundation

class RadioVC: UIViewController, SearchSelectionDelegate {
    
    var countries: [Country] = []
    var languages: [Language] = []
    var tags: [Tag] = []
    
    
    let searchBarVC = SearchBarVC()
    var filteredData2 = SearchBarData(countries: [], languages: [], tags: [])
    
    lazy var searchController = UISearchController(searchResultsController: searchBarVC)
    
    var avPlayer: AVPlayer?
    var avPlayerItem: AVPlayerItem?
    
    let favoritesButton = UIButton()
    let historyButton = UIButton()
    
    var playingRadioName = UILabel()
    var playingRadioFavicon = UIImageView()
    let playButton = UIButton()
    let addToFavoritesButton = UIButton()
    
    var radioStations: [RadioStation] = []
    let radioStationExample = RadioStation(name: "Jap", urlResolved: "https://relay0.r-a-d.io/main.mp3", favicon: "", tags: "", country: "Japan", language: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureSearchController()
        configureSideButtons()
        configurePlayingRadioElements()
        configureSearchController()
        
        // TODO: async - await ile refactor edilcek.
        getCountryList()
        getLanguageList()
        getTagList()
        searchBarVC.searchSelectionDelegate = self
        
        
    }
    
}

extension RadioVC: UISearchResultsUpdating, UISearchBarDelegate {

    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchBarVC.selectedScope = selectedScope
        searchBarVC.tableView.reloadData()
        
    }
    
    func didTapCell(choice: String, scope: Int) {
        
        NetworkManager.shared.getRadioStationsByChoice(forChoice: choice, forScope: scope) { [weak self]
            result in
            guard let self = self else { return }
            
            switch result {
            case .success(let radioStations):
                DispatchQueue.main.async {
                    self.radioStations.append(contentsOf: radioStations)
                    let searchResultVC = SearchResultVC()
                    searchResultVC.playRadioButtonDelegate = self
                    searchResultVC.radioStations.append(contentsOf: radioStations)
                    self.navigationController?.pushViewController(searchResultVC, animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        var selectedScope = searchController.searchBar.selectedScopeButtonIndex
        
        filterSearchText(searchText: searchText, scopeButton: selectedScope)
    }
    
    
    func filterSearchText(searchText: String, scopeButton: Int) {
        
        switch scopeButton {
        case 0:
            searchBarVC.filteredData.countries = searchBarVC.model.countries.filter{
                data in
                if(searchText != "") {
                    let searchTextMatch = data.lowercased().contains(searchText.lowercased())
                    return searchTextMatch
                } else { return false }
            }
            searchBarVC.tableView.reloadData()
        case 1:
            searchBarVC.filteredData.languages = searchBarVC.model.languages.filter{
                data in
                if(searchText != "") {
                    let searchTextMatch = data.lowercased().contains(searchText.lowercased())
                    return searchTextMatch
                } else { return false }
            }
            searchBarVC.tableView.reloadData()
        case 2:
            searchBarVC.filteredData.tags = searchBarVC.model.tags.filter{
                data in
                if(searchText != "") {
                    let searchTextMatch = data.lowercased().contains(searchText.lowercased())
                    return searchTextMatch
                } else { return false }
            }
            searchBarVC.tableView.reloadData()
        default:
            return
        }
          
    }
}


// MARK: Button functions

extension RadioVC {
    @objc func startRadioButton() {
        
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
        
        searchBarVC.isSearchControllerActive = !((searchController.searchBar.text?.isEmpty) != nil)
        
        searchController.searchBar.delegate = self
    }
    
    func configurePlayButton() {
        
        
    }
    
    func configureSideButtons() {
        
        let padding : CGFloat = 20
        let buttonSize: CGFloat = 32
        
        historyButton.setBackgroundImage(UIImage(systemName: "clock.fill"), for: .normal)
        
        favoritesButton.tintColor = .systemPink
        historyButton.tintColor = .systemBlue
        
        view.addSubview(favoritesButton)
        view.addSubview(historyButton)
        
        favoritesButton.translatesAutoresizingMaskIntoConstraints = false
        historyButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            historyButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            historyButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            historyButton.widthAnchor.constraint(equalToConstant: buttonSize),
            historyButton.heightAnchor.constraint(equalToConstant: buttonSize),
            
            favoritesButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            favoritesButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            favoritesButton.widthAnchor.constraint(equalToConstant: buttonSize),
            favoritesButton.heightAnchor.constraint(equalToConstant: buttonSize),
        ])
               
        favoritesButton.contentHorizontalAlignment = .fill
        favoritesButton.contentVerticalAlignment = .fill
        favoritesButton.imageView?.contentMode = .scaleAspectFit
        
        favoritesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
 
        favoritesButton.addTarget(self, action: #selector(pushFavoritesVC), for: .touchUpInside)
        historyButton.addTarget(self, action: #selector(pushHistoryVC), for: .touchUpInside)
        
    }
    
    func configurePlayingRadioElements() {
        
        playingRadioFavicon.image = UIImage(named: "RSPlaceholder")
        
        playingRadioName.text = "Placeholder FM 100.1"
        playingRadioName.textAlignment = .center
        playingRadioName.numberOfLines = 3
        
        playButton.setTitle("Play", for: .normal)
        playButton.backgroundColor = UIColor.systemBlue
        playButton.layer.cornerRadius = 10
        
        addToFavoritesButton.setTitle("Add to Favorites", for: .normal)
        addToFavoritesButton.backgroundColor = UIColor.systemRed
        addToFavoritesButton.layer.cornerRadius = 10
        
        playingRadioFavicon.translatesAutoresizingMaskIntoConstraints = false
        playingRadioName.translatesAutoresizingMaskIntoConstraints = false
        playButton.translatesAutoresizingMaskIntoConstraints = false
        addToFavoritesButton.translatesAutoresizingMaskIntoConstraints = false
        
        playButton.addTarget(self, action: #selector(startRadioButton), for: .touchUpInside)
        
        view.addSubview(playingRadioFavicon)
        view.addSubview(playingRadioName)
        view.addSubview(playButton)
        view.addSubview(addToFavoritesButton)
        
        NSLayoutConstraint.activate([
            playingRadioFavicon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            playingRadioFavicon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playingRadioFavicon.heightAnchor.constraint(equalToConstant: 90),
            playingRadioFavicon.widthAnchor.constraint(equalToConstant: 90),
            
            playingRadioName.topAnchor.constraint(equalTo: playingRadioFavicon.bottomAnchor, constant: 10),
            playingRadioName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            playingRadioName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            playingRadioName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            playButton.topAnchor.constraint(equalTo: playingRadioName.bottomAnchor, constant: 20),
            playButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 80),
            playButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -80),
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            addToFavoritesButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 10),
            addToFavoritesButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 80),
            addToFavoritesButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -80),
            addToFavoritesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
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

extension RadioVC : PlayRadioButtonDelegate {
    func didTapRSPlayButton (name: String, url: String, favicon: String) {
        print(name)
        print(url)
        print(favicon)
    }
}
