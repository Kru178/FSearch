//
//  ImagesPresenter.swift
//  FSearch
//
//  Created by Sergei Krupenikov on 06.08.2023.
//

import Foundation
// MARK: - ImagesPresenterProtocol
protocol ImagesPresenterProtocol {
    var keyword: String { get }
    var photos: [Photo] { get }
    func provideData()
    func selected(item: Int)
}

// MARK: - ImagesPresenter
final class ImagesPresenter {
    private(set) var keyword: String
    private(set) var photos: [Photo] = []
    private var page = 0
    private let dataSource: PhotoDataManagerProtocol
    weak var view: ImagesViewControllerProtocol?
    
    init(keyword: String, datasource: PhotoDataManagerProtocol) {
        self.keyword = keyword
        self.dataSource = datasource
    }
}

// MARK: - ImagesPresenterProtocol methods
extension ImagesPresenter: ImagesPresenterProtocol {
    func provideData() {
        page += 1
        dataSource.provideData(for: keyword, page: page) { [weak self] result in
            switch result {
            case .success(let items):
                self?.photos += items
                guard let photos = self?.photos else { return }
                photos.isEmpty ?
                self?.view?.showEmptyState() : self?.view?.updateUI(with: photos)
            case .failure(let error):
                self?.view?.showFailAlert(error: error)
            }
        }
    }
    
    func selected(item: Int) {
        view?.proceedToFull(photo: photos[item])
    }
}
