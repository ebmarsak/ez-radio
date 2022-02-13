//
//  SearchVC.swift
//  ezRadio
//
//  Created by Teto on 6.02.2022.
//

import UIKit

class SearchVC: UIViewController {
    
    
    weak var countryCollectionView: UICollectionView!
    
    let headerReuseIdentifier = "headerReuseIdentifier"
    
    var countries: [Country] = []

    
    override func loadView() {
        super.loadView()
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
            
        cv.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cv)
        
        NSLayoutConstraint.activate([
           cv.topAnchor.constraint(equalTo: view.topAnchor),
           cv.leadingAnchor.constraint(equalTo: view.leadingAnchor),
           cv.trailingAnchor.constraint(equalTo: view.trailingAnchor),
           cv.bottomAnchor.constraint(equalTo: view.bottomAnchor),
       ])
        
        cv.register(HeaderClass.self,forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        
        self.countryCollectionView = cv
        
        countryCollectionView.backgroundColor = .systemBackground
        
        //countryCollectionView.dataSource = self
        //countryCollectionView.delegate = self

        //countryCollectionView.register(EZCell.self, forCellWithReuseIdentifier: EZCell.identifier)
        
        if let collectionViewLayout = countryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                   collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        
    }
    
    override func viewDidLoad() {
        getCountryList()

        super.viewDidLoad()
    }
    
    func getCountryList() {
        
        
            NetworkManager.shared.getCountryList() { [weak self]
                result in
                
                guard let self = self else { return }
                
                switch result {
                case .success(let countries):
                    self.countries.append(contentsOf: countries)
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.countryCollectionView.reloadData()
                    }
                    print(countries.description)
                    
                case .failure(let error):
                    print(error)
                }
                
            }
        }
    
}

class HeaderClass: UICollectionViewCell{
    weak var textLabel: UILabel!
    
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
           label.topAnchor.constraint(equalTo: contentView.topAnchor),
           label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
           label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
           label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
       ])
        
        textLabel = label
        textLabel.textAlignment = .left
        
        textLabel.text = "Countries"
        backgroundColor = .systemFill
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

