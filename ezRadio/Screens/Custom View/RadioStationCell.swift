//
//  RadioStationCell.swift
//  ezRadio
//
//  Created by Teto on 18.02.2022.
//

import UIKit

class RadioStationCell: UITableViewCell {
    
    var rsImageView = UIImageView()
    var rsName = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(rsImageView)
        addSubview(rsName)
        
        configureName()
        configureImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureImageView() {
        rsImageView.translatesAutoresizingMaskIntoConstraints = false
        rsImageView.layer.cornerRadius = 10
        rsImageView.clipsToBounds = true
        rsImageView.image = UIImage(named: "TR")
        
    }
    
    func configureName() {
        rsName.translatesAutoresizingMaskIntoConstraints = false
        rsName.numberOfLines = 0
        rsName.adjustsFontSizeToFitWidth = true
    }
    
    func componentConstraints() {
        NSLayoutConstraint.activate([
            rsImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            rsImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            rsImageView.heightAnchor.constraint(equalToConstant: 100),
            rsImageView.widthAnchor.constraint(equalToConstant: 100),
        ])
    }
}
