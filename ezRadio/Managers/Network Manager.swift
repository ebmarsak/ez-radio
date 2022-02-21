//
//  Network Manager.swift
//  ezRadio
//
//  Created by Teto on 6.02.2022.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "http://nl1.api.radio-browser.info/json/"
    
    private init() {}
    
    func getRadioStationsByCountry(forCountry country: String, completed: @escaping (Result<[RadioStation], EZError>) -> Void) {
        
        let endpoint = baseURL + "stations/bycountry/\(country)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidName))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let radioStations = try decoder.decode([RadioStation].self, from: data)
                completed(.success(radioStations))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    func getCountryList(completed: @escaping (Result<[Country], EZError>) -> Void) {
        
        let endpoint = baseURL + "/countries"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidName))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let countries = try decoder.decode([Country].self, from: data)
                completed(.success(countries))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    func getLanguageList(completed: @escaping (Result<[Language], EZError>) -> Void) {
        
        let endpoint = baseURL + "/languages"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidName))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let languages = try decoder.decode([Language].self, from: data)
                completed(.success(languages))
            } catch {
                completed(.failure(.invalidData))
            }
        }.resume()

    }
    
    func getTagList(completed: @escaping (Result<[Tag], EZError>) -> Void) {
        
        let endpoint = baseURL + "/tags"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidName))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let tags = try decoder.decode([Tag].self, from: data)
                completed(.success(tags))
            } catch {
                completed(.failure(.invalidData))
            }
        }
    
    task.resume()
}
    
//    closure
//    completionHandler
    
    func getRadioStationsByChoice(forChoice choice: String, forScope scope: Int, completed: @escaping (Result<[RadioStation], EZError>) -> Void) {
        
        var endpoint: String
        
        switch scope {
        case 0:
            endpoint = baseURL + "stations/bycountry/\(choice)"
        case 1:
            endpoint = baseURL + "stations/bylanguage/\(choice)"
        case 2:
            endpoint = baseURL + "stations/bytag/\(choice)"
        default:
            return
        }
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidName))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let radioStations = try decoder.decode([RadioStation].self, from: data)
                completed(.success(radioStations))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
}
