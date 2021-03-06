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
    
    var historyCache = [CacheRadio]()
    var favoritesCache = [CacheRadio]()
    var currenlyPlaying = CacheRadio(name: "null", url: "null", image: "null")
    
    var countries: [Country] = []
    var languages: [Language] = []
    var tags: [Tag] = []
    
    let favoritesVC = FavoritesVC()
    let historyVC = HistoryVC()
    
    let searchBarVC = SearchBarVC()
    var filteredData2 = SearchBarData(countries: [], languages: [], tags: [])
    
    lazy var searchController = UISearchController(searchResultsController: searchBarVC)
    
    var avPlayer: AVPlayer?
    var avPlayerItem: AVPlayerItem?
    var isRadioPlaying: Bool = false
    
    let favoritesButton = UIButton()
    let historyButton = UIButton()
    
    var playingRadioName = UILabel()
    var playingRadioFavicon = UIImageView()
    let playButton = UIButton()
    let stopButton = UIButton()
    let addToFavoritesButton = UIButton()
    
    var radioStations: [RadioStation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        avPlayer?.automaticallyWaitsToMinimizeStalling = false
        
        setupCache()
        
        configureSearchController()
        configureSideButtons()
        configurePlayingRadioElements()
        configureSearchController()
        
        // TODO: async - await ile refactor edilcek.
        getCountryList()
        getLanguageList()
        getTagList()
        searchBarVC.searchSelectionDelegate = self
        favoritesVC.favoriteItemDelegate = self
        historyVC.playFromHistoryDelegate = self
    }
    
    func setupCache() {
        
        if let cacheFavoritesFromSystem = UserDefaults.standard.object(forKey: "favorites") as? Data {
            do {
                let jsonDecoder = JSONDecoder()
                favoritesCache = try jsonDecoder.decode([CacheRadio].self, from: cacheFavoritesFromSystem)
            } catch {
                print("failed to load favorites from system")
            }
        }
        
        if let cacheHistoryFromSystem = UserDefaults.standard.object(forKey: "history") as? Data {
            do {
                let jsonDecoder = JSONDecoder()
                historyCache = try jsonDecoder.decode([CacheRadio].self, from: cacheHistoryFromSystem)
            } catch {
                print("failed to load favorites from system")
            }
        }
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
    @objc func pushFavoritesVC() {
        navigationController?.pushViewController(favoritesVC, animated: true)
        favoritesVC.getCacheFromSystem()
        favoritesVC.favoritesTV.reloadData()
    }
    @objc func pushHistoryVC() {
        navigationController?.pushViewController(historyVC, animated: true)
        historyVC.getCacheFromSystem()
        historyVC.historyTV.reloadData()
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
    
    
    func configureSideButtons() {
        
        let padding : CGFloat = 20
        let buttonSize: CGFloat = 32
        
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
        
        favoritesButton.tintColor = .systemPink
        historyButton.tintColor = .systemBlue
        favoritesButton.contentHorizontalAlignment = .fill
        favoritesButton.contentVerticalAlignment = .fill
        favoritesButton.imageView?.contentMode = .scaleAspectFit
        favoritesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        historyButton.setBackgroundImage(UIImage(systemName: "clock.fill"), for: .normal)
        
        favoritesButton.addTarget(self, action: #selector(pushFavoritesVC), for: .touchUpInside)
        historyButton.addTarget(self, action: #selector(pushHistoryVC), for: .touchUpInside)
    }
    
    func configurePlayingRadioElements() {
        view.addSubview(playingRadioFavicon)
        view.addSubview(playingRadioName)
        view.addSubview(playButton)
        view.addSubview(stopButton)
        view.addSubview(addToFavoritesButton)
        
        playingRadioFavicon.image = UIImage(named: "RSPlaceholder")
        playingRadioFavicon.layer.borderWidth = 1
        playingRadioFavicon.layer.borderColor = CGColor(red: 0, green: 0, blue: 1, alpha: 1)
        
        playingRadioName.text = "Use the search bar to find a radio!"
        playingRadioName.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        playingRadioName.textAlignment = .center
        playingRadioName.numberOfLines = 3
        
        playButton.setTitle("Play", for: .normal)
        playButton.backgroundColor = UIColor.systemBlue
        playButton.layer.cornerRadius = 10
        
        stopButton.setTitle("Stop", for: .normal)
        stopButton.backgroundColor = UIColor.systemYellow
        stopButton.layer.cornerRadius = 10
        
        addToFavoritesButton.setTitle("Add to Favorites", for: .normal)
        addToFavoritesButton.backgroundColor = UIColor.systemRed
        addToFavoritesButton.layer.cornerRadius = 10
        
        playingRadioFavicon.translatesAutoresizingMaskIntoConstraints = false
        playingRadioName.translatesAutoresizingMaskIntoConstraints = false
        playButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        addToFavoritesButton.translatesAutoresizingMaskIntoConstraints = false
        
        stopButton.addTarget(self, action: #selector(stopRadio), for: .touchUpInside)
        addToFavoritesButton.addTarget(self, action: #selector(saveForFavorites), for: .touchUpInside)
        
        
        NSLayoutConstraint.activate([
            playingRadioFavicon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            playingRadioFavicon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playingRadioFavicon.heightAnchor.constraint(equalToConstant: 180),
            playingRadioFavicon.widthAnchor.constraint(equalToConstant: 180),
            
            playingRadioName.topAnchor.constraint(equalTo: playingRadioFavicon.bottomAnchor, constant: 10),
            playingRadioName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            playingRadioName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            playingRadioName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            playButton.topAnchor.constraint(equalTo: playingRadioName.bottomAnchor, constant: 20),
            playButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 80),
            playButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -80),
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stopButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 10),
            stopButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 80),
            stopButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -80),
            stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            addToFavoritesButton.topAnchor.constraint(equalTo: stopButton.bottomAnchor, constant: 10),
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

// MARK: RadioPlay Functions

extension RadioVC : PlayRadioButtonDelegate, FavoriteItemDelegate, PlayFromHistoryDelegate {
    
    func didTapRemoveItem(indexOfItem: Int) {
        if (favoritesCache.count > 0) {
            favoritesCache.remove(at: indexOfItem)
        } else {
            print("The list is already empty")
        }
        let jsonEncoder = JSONEncoder()
        if let favoriteData = try? jsonEncoder.encode(favoritesCache) {
            UserDefaults.standard.set(favoriteData, forKey: "favorites")
        } else {
            print("failed to save radio data to favorites")
        }
        favoritesVC.getCacheFromSystem()
        favoritesVC.favoritesTV.reloadData()
    }
    
    func didTapHistoryPlayButton(name: String, url: String, image: String) {
        // Set station name
        playingRadioName.text = name
        
        // Fetch station image
        fetchImage(url: image) { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async { [weak self]
                in
                guard let self = self else { return }
                self.playingRadioFavicon.image = image
            }
        }
        
        // Radio URL and Streaming
        if avPlayer?.currentItem == nil {
            startRadio(name: name, streamUrl: url)
        } else if avPlayer?.currentItem != nil {
            replaceRadio(name: name, streamURL: url)
        }
        
        // Caching for history
        historyCache.append(CacheRadio(name: name, url: url, image: image))
        saveForHistory()
        
        // Caching for favorites
        currenlyPlaying.name = name
        currenlyPlaying.image = image
        currenlyPlaying.url = url
    }
    
    func didTapFavoritePlayButton(name: String, url: String, image: String) {
        // Set station name
        playingRadioName.text = name
        
        // Fetch station image
        fetchImage(url: image) { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async { [weak self]
                in
                guard let self = self else { return }
                self.playingRadioFavicon.image = image
            }
        }
        
        // Radio URL and Streaming
        if avPlayer?.currentItem == nil {
            startRadio(name: name, streamUrl: url)
        } else if avPlayer?.currentItem != nil {
            replaceRadio(name: name, streamURL: url)
        }
        
        // Caching for history
        historyCache.append(CacheRadio(name: name, url: url, image: image))
        saveForHistory()
        
        // Caching for favorites
        currenlyPlaying.name = name
        currenlyPlaying.image = image
        currenlyPlaying.url = url
    }
    
    func didTapRSPlayButton (name: String, url: String, favicon: String) {
        
        // Set station name
        playingRadioName.text = name
        
        // Fetch station image
        fetchImage(url: favicon) { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async { [weak self]
                in
                guard let self = self else { return }
                self.playingRadioFavicon.image = image
            }
        }
        
        // Radio URL and Streaming
        if avPlayer?.currentItem == nil {
            startRadio(name: name, streamUrl: url)
        } else if avPlayer?.currentItem != nil {
            replaceRadio(name: name, streamURL: url)
        }
        
        // Caching for history
        historyCache.append(CacheRadio(name: name, url: url, image: favicon))
        saveForHistory()
        
        // Caching for favorites
        currenlyPlaying.name = name
        currenlyPlaying.image = favicon
        currenlyPlaying.url = url
    }
    
    func saveForHistory() {
        let jsonEncoder = JSONEncoder()
        if let historyData = try? jsonEncoder.encode(historyCache) {
            UserDefaults.standard.set(historyData, forKey: "history")
        } else {
            print("failed to save radio data to history")
        }
        historyVC.historyTV.reloadData()
    }
    
    @objc func saveForFavorites() {
        favoritesCache.append(currenlyPlaying)
        let jsonEncoder = JSONEncoder()
        if let favoriteData = try? jsonEncoder.encode(favoritesCache) {
            UserDefaults.standard.set(favoriteData, forKey: "favorites")
        } else {
            print("failed to save radio data to favorites")
        }
    }
    
    func startRadio(name: String, streamUrl: String) {
        let url = URL(string: streamUrl)
        avPlayerItem = AVPlayerItem.init(url: url! as URL)
        avPlayer = AVPlayer.init(playerItem: avPlayerItem)
        avPlayer?.play()
        
        isRadioPlaying = true
        
        print("playing radio: \(name) with url: \(streamUrl)")
    }
    
    func replaceRadio(name: String, streamURL: String) {
        let url = URL(string: streamURL)
        avPlayer?.pause()
        avPlayerItem =  AVPlayerItem.init(url: url! as URL)
        avPlayer?.replaceCurrentItem(with: avPlayerItem)
        avPlayer?.play()
        
        print("replaced radio with: \(name) with url: \(streamURL)")
    }
    
    @objc func stopRadio() {
        avPlayer?.pause()
        avPlayer?.rate = 0
        
        isRadioPlaying = false
        
        print("stopped radio")
    }
}
