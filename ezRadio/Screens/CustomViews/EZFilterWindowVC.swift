//
//  EZFilterWindowVC.swift
//  ezRadio
//
//  Created by Teto on 6.02.2022.
//

import UIKit

class EZFilterWindowVC: UIViewController {
    
    // Container
    let containerView = UIView()
    
    // Labels
    let titleLabel = UILabel()
    let countryLabel = UILabel()
    let tagLabel = UILabel()
    let languageLabel = UILabel()
    // Pickers
    
    let countryPicker = UIPickerView()
    
    // Button
    
    let doneButton = UIButton()
    
    let padding: CGFloat = 20
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.75)
        
        configureContainerView()
        configureTitleLabel()
        configureFilterLabels()
        
        
    }
    
    func configureContainerView() {
        view.addSubview(containerView)
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.white.cgColor
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 240)
        ])
    }
    
    func configureTitleLabel() {
        containerView.addSubview(titleLabel)
        
        titleLabel.text = "Filters"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    
    func configureFilterLabels() {
        let labels = [countryLabel, languageLabel, tagLabel]
        
        for label in labels {
            containerView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .label
            label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        }
        
        countryLabel.text = "Country"
        languageLabel.text = "Language"
        tagLabel.text = "Tag"
        
        NSLayoutConstraint.activate([
            countryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding + 10),
            countryLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            countryLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            
            languageLabel.topAnchor.constraint(equalTo: countryLabel.bottomAnchor, constant: padding),
            languageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            languageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            
            tagLabel.topAnchor.constraint(equalTo: languageLabel.bottomAnchor, constant: padding),
            tagLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            tagLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
        ])
    }
    
    func configurePickers() {
        
        
        
    }
    
    @objc func dismissFilterVC() {
        dismiss(animated: true)
    }

}

