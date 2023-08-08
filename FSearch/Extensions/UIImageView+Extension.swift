//
//  UIImageView+Extension.swift
//  FSearch
//
//  Created by Sergei Krupenikov on 06.08.2023.
//

import UIKit

extension UIImageView {
    func downloadImage(for photo: Photo, size: ImageSize) {
        let spinner = UIActivityIndicatorView(frame: bounds)

        self.addSubview(spinner)
        spinner.startAnimating()
        ImageLoader.shared.downloadImage(for: photo, ofSize: size) { [weak self] image in
            DispatchQueue.main.async {
                self?.image = image
                spinner.stopAnimating()
                spinner.removeFromSuperview()
            }
        }
    }
}
