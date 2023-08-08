//
//  FSError.swift
//  FSearch
//
//  Created by Sergei Krupenikov on 06.08.2023.
//

import Foundation

enum FSError: String, Error {
    case badRequest = "Bad request"
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid."
    case unableToRead = "Something bad happened. Please try again."
}
