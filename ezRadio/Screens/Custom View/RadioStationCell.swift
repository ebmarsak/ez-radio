//
//  RadioStationCell.swift
//  ezRadio
//
//  Created by Teto on 18.02.2022.
//

import UIKit

class RadioStationCell: UITableViewCell {
    
    var rsImageView = UIImageView()
    var rsRadioName = UILabel()
    var rsLanguage = UILabel()
    var rsTags = UILabel()
    var rsPlayButton = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(rsImageView)
        addSubview(rsRadioName)
        addSubview(rsLanguage)
        addSubview(rsTags)
        addSubview(rsPlayButton)
        
        configureSubviewProperties()
        componentConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getImageFromURL(url: URL) {
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
            if let data = data {
                DispatchQueue.main.async {
                    self?.imageView?.image = UIImage(data: data)
                }
            }
        }
        
        dataTask.resume()
    }
    
    func configureSubviewProperties() {
        
        // Image
        rsImageView.translatesAutoresizingMaskIntoConstraints = false
        rsImageView.layer.cornerRadius = 10
        rsImageView.clipsToBounds = true
        rsImageView.image = UIImage(named: "TR")
        
        
        // Name
        rsRadioName.translatesAutoresizingMaskIntoConstraints = false
        rsRadioName.numberOfLines = 0
        rsRadioName.adjustsFontSizeToFitWidth = true
        rsRadioName.text = "Best FM"
        rsRadioName.textAlignment = .left
        rsRadioName.numberOfLines = 1
        
        // Language
        rsLanguage.translatesAutoresizingMaskIntoConstraints = false
        rsLanguage.text = "german, english"
        rsLanguage.textAlignment = .left
        rsLanguage.numberOfLines = 1
        //rsLanguage.font = textLabel?.font.withSize(10)
        
        // Tags
        rsTags.translatesAutoresizingMaskIntoConstraints = false
        rsTags.text = "jazz,pop,rock,indie"
        rsTags.textAlignment = .left
        rsTags.numberOfLines = 0
        //rsTags.font = textLabel?.font.withSize(10)
        
        // PlayButton
        rsPlayButton.translatesAutoresizingMaskIntoConstraints = false
        rsPlayButton.setBackgroundImage(UIImage(systemName: "play.circle"), for: .normal)
        
    }
    
    func componentConstraints() {
        let padding: CGFloat = 6
        let buttonSize: CGFloat = 42

        NSLayoutConstraint.activate([
            rsImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            rsImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            rsImageView.heightAnchor.constraint(equalToConstant: 120),
            rsImageView.widthAnchor.constraint(equalToConstant: 120),
            
            rsRadioName.leadingAnchor.constraint(equalTo: rsImageView.trailingAnchor, constant: 15),
            rsRadioName.topAnchor.constraint(equalTo: rsImageView.topAnchor),
            
            rsLanguage.leadingAnchor.constraint(equalTo: rsImageView.trailingAnchor, constant: 15),
            rsLanguage.topAnchor.constraint(equalTo: rsRadioName.bottomAnchor, constant: padding),
            
            rsTags.leadingAnchor.constraint(equalTo: rsImageView.trailingAnchor, constant: 15),
            rsTags.topAnchor.constraint(equalTo: rsLanguage.bottomAnchor, constant: padding),
            
            rsPlayButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            rsPlayButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            rsPlayButton.widthAnchor.constraint(equalToConstant: buttonSize),
            rsPlayButton.heightAnchor.constraint(equalToConstant: buttonSize)
            
        ])
    }
}
