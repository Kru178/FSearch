//
//  SelectedImageViewController.swift
//  FSearch
//
//  Created by Sergei Krupenikov on 05.08.2023.
//

import UIKit
// MARK: - SelectedImageViewControllerProtocol
protocol SelectedImageViewControllerProtocol: AnyObject {
    func downloadImage(for photo: Photo)
}

// MARK: - SelectedImageViewController
final class SelectedImageViewController: UIViewController {
    private let presenter: SelectedImagePresenterProtocol
    private let imageView = ZoomableImageView(frame: .zero)
    
    init(presenter: SelectedImagePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureImageView()
        presenter.getImage()
    }
    
    private func configureImageView() {
        view.addSubview(imageView)
        imageView.frame = view.bounds
        imageView.contentMode = .scaleAspectFit
    }
}

// MARK: - SelectedImageViewControllerProtocol methods
extension SelectedImageViewController: SelectedImageViewControllerProtocol {
    func downloadImage(for photo: Photo) {
        imageView.downloadImage(for: photo)
    }
}
