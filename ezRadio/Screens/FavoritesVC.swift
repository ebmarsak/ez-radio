//
//  FavoritesVC.swift
//  ezRadio
//
//  Created by Teto on 4.02.2022.
//

import UIKit

protocol FavoriteItemDelegate: AnyObject {
    func didTapRemoveItem(indexOfItem: Int)
    
    func didTapFavoritePlayButton(name: String, url: String, image: String)
}

class FavoritesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var favoriteItemDelegate: FavoriteItemDelegate?

    let favoritesTV = UITableView()
    var favoriteItems: [CacheRadio] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Favorites"
        
        getCacheFromSystem()
        configureTableView()
    }
    
    func getCacheFromSystem() {
        if let savedFavorites = UserDefaults.standard.object(forKey: "favorites") as? Data {
            do {
                let jsonDecoder = JSONDecoder()
                favoriteItems = try jsonDecoder.decode([CacheRadio].self, from: savedFavorites)
            } catch {
                print("failed to load radio favorites")
            }
        }
    }
    
    func configureTableView() {
        view.addSubview(favoritesTV)
        
        favoritesTV.dataSource = self
        favoritesTV.delegate = self
        
        favoritesTV.frame = view.bounds
        favoritesTV.translatesAutoresizingMaskIntoConstraints = false
        favoritesTV.register(UITableViewCell.self, forCellReuseIdentifier: "favoritesCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favoriteItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesCell", for: indexPath)
        cell.textLabel?.text = favoriteItems[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        favoritesTV.deselectRow(at: indexPath, animated: true)
        
        let radioName = favoriteItems[indexPath.row].name
        let radioImage = favoriteItems[indexPath.row].image
        let radioURL = favoriteItems[indexPath.row].url
        showAlert(name: radioName, image: radioImage, url: radioURL, index: indexPath.row)
    }
    
    func showAlert(name: String, image: String, url: String, index: Int) {
        let alert = UIAlertController(title: "Favorites", message: "Play or Delete selected radio from Favorites?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Play", style: .default, handler: { action in
            print("play tapped")
            self.favoriteItemDelegate?.didTapFavoritePlayButton(name: name, url: url, image: image)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            print("cancel tapped")
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            print("delete tapped")
            self.favoriteItemDelegate?.didTapRemoveItem(indexOfItem: index)
            self.favoritesTV.reloadData()
        }))
        
        present(alert, animated: true)
    }
}
