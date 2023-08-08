//
//  ImageLoader.swift
//  FSearch
//
//  Created by Sergei Krupenikov on 05.08.2023.
//

import UIKit
// MARK: - ImageSize
enum ImageSize: String {
    case small = "m"
    case big = "b"
}

// MARK: - ImageLoader
final class ImageLoader {
    private enum BaseURL {
        static let baseUrl = "https://live.staticflickr.com/"
    }
    static let shared = ImageLoader()
    private let cache = NSCache<NSString, UIImage>()
    private let baseUrl = BaseURL.baseUrl
    private let placeholder = Constants.Images.placeholder
}

// MARK: - ImageLoader public methods
extension ImageLoader {
    func downloadImage(for photo: Photo, ofSize: ImageSize, completed: @escaping (UIImage?) -> Void) {
        let urlString = baseUrl + "\(photo.server)/\(photo.id)_\(photo.secret)_\(ofSize.rawValue).jpg"
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        guard let url = URL(string: urlString) else {
            completed(placeholder)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [ weak self ] (data, response, error) in
            guard let self = self,
            error == nil,
            let response = response as? HTTPURLResponse, response.statusCode == 200,
            let data = data,
            let image = UIImage(data: data) else {
                completed(self?.placeholder)
                return
            }
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        task.resume()
    }
}
