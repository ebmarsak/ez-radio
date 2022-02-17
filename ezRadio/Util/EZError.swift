//
//  EZError.swift
//  ezRadio
//
//  Created by Teto on 6.02.2022.
//

import Foundation

enum EZError: String, Error {
    case invalidName        = "This username created an invalid request. Please try again."
    case unableToComplete   = "Unable to complete your request. Please check your internet connection"
    case invalidResponse    = "Invalid response from the server. Please try again."
    case invalidData        = "The data received from the server was invalid. Please try again."
}
