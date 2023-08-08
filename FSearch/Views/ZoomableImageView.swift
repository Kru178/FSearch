//
//  ZoomableImageView.swift
//  FSearch
//
//  Created by Sergei Krupenikov on 05.08.2023.
//

import UIKit
// MARK: - ZoomableImageView
final class ZoomableImageView: UIScrollView {
    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }

    private func configureViews() {
        // Setup image view
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -100)
        ])

        // Setup scroll view
        minimumZoomScale = 1
        maximumZoomScale = 3
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        delegate = self
    }

}

// MARK: - UIScrollViewDelegate methods
extension ZoomableImageView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

// MARK: - image download
extension ZoomableImageView {
    func downloadImage(for photo: Photo) {
        imageView.downloadImage(for: photo, size: .big)
    }
}
