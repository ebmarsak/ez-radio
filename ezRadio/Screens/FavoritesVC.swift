//
//  FavoritesVC.swift
//  ezRadio
//
//  Created by Teto on 4.02.2022.
//

import UIKit

class FavoritesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let favoritesTV = UITableView()
    var favoriteItems: [CacheRadio] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureTableView()
        
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
        showAlert()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Favorites", message: "Play selected radio from favorites?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Play", style: .default, handler: { action in
            print("play tapped")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            print("cancel tapped")
        }))
        
        present(alert, animated: true)
    }
}
