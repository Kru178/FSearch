//
//  Constants.swift
//  FSearch
//
//  Created by Sergei Krupenikov on 06.08.2023.
//

import UIKit

enum Constants {
    enum Tabs {
        static let search = "Search"
        static let history = "History"
    }
    
    enum Images {
        static let logo = UIImage(named: "logo")
        static let placeholder = UIImage(named: "noImage")
        static let emptyViewImage = UIImage(systemName: "magnifyingglass")
    }
    
    enum EmptyStateMessage {
        static let images = "I couldn't find anything 😿\nPlease try another request"
        static let history = "Your search history\n will appear here\n 😉"
    }
    
    enum Alert {
        static let errorTitle = "Something went wrong"
        
        enum History {
            static let title = "Clear History"
            static let body = "Do you want to delete the whole history?"
        }
        
        enum EmptySearch {
            static let title = "Empty search"
            static let body = "Please enter a keyword and press Search button"
        }
    }
    
    enum Buttons {
        static let search = "Search"
        static let clear = "Clear"
    }
    
    enum Cells {
        enum ImageCell {
            static let reuseID = "ImageCell"
        }
        enum HistoryCell {
            static let reuseID = "HistoryCell"
        }
    }
    
    enum SearchTextField {
        static let placeholder = "Enter a keyword"
    }
    
    enum URLs {
        enum NetworkService {
            static let baseUrl = "https://api.flickr.com/services/rest/?%20method=flickr.photos.search&api_key=6af377dc54798281790fc638f6e4da5e&format=json&nojsoncallback=1&text="
        }
        enum ImageLoader {
            static let baseUrl = "https://live.staticflickr.com/"
        }
    }
}
