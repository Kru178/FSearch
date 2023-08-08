//
//  SelectedImagePresenter.swift
//  FSearch
//
//  Created by Sergei Krupenikov on 06.08.2023.
//

import Foundation
// MARK: - SelectedImagePresenterProtocol
protocol SelectedImagePresenterProtocol {
    func getImage()
}

// MARK: - SelectedImagePresenter
final class SelectedImagePresenter {
    private let photo: Photo
    weak var view: SelectedImageViewControllerProtocol?
    
    init(photo: Photo) {
        self.photo = photo
    }
}

// MARK: - SelectedImagePresenterProtocol methods
extension SelectedImagePresenter: SelectedImagePresenterProtocol {
    func getImage() {
        view?.downloadImage(for: photo)
    }
}
