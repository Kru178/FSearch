//
//  SearchPresenter.swift
//  FSearch
//
//  Created by Sergei Krupenikov on 06.08.2023.
//

import Foundation
// MARK: - SearchPresenterProtocol
protocol SearchPresenterProtocol {
    func initiateSearchFor(keyword: String?)
}

// MARK: - SearchPresenter
final class SearchPresenter {
    weak var view: SearchViewControllerProtocol?
}

// MARK: - SearchPresenterProtocol methods
extension SearchPresenter: SearchPresenterProtocol {
    func initiateSearchFor(keyword: String?) {
        guard let keyword = keyword, inputIsValid(keyword: keyword) else {
            view?.showEmptySearchAlert()
            return
        }
        save(entry: keyword)
        view?.showResultScreen(for: keyword)
    }
    
    private func save(entry: String?) {
        guard let keyword = entry else { return }
        let entry = HistoryEntry(text: keyword, date: Date())
        HistoryPersistenceManager.updateWith(entry: entry, actionType: .add) { _ in }
    }
    // ensuring the input doesn't consist of whitespaces only or is not empty
    private func inputIsValid(keyword: String) -> Bool {
        !keyword.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
