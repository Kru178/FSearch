//
//  ImageCell.swift
//  FSearch
//
//  Created by Sergei Krupenikov on 04.08.2023.
//

import UIKit

final class ImageCell: UICollectionViewCell {
    static let reuseID = Constants.Cells.ImageCell.reuseID
    private let imageView = UIImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(photo: Photo) {
        imageView.downloadImage(for: photo, size: .small)
    }
    
    private func configure() {
        backgroundColor = .systemBackground
        addSubviews(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
                
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
