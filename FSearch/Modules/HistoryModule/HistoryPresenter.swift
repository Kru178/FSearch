//
//  HistoryPresenter.swift
//  FSearch
//
//  Created by Sergei Krupenikov on 06.08.2023.
//

import Foundation
// MARK: - HistoryPresenterProtocol
protocol HistoryPresenterProtocol {
    var history: [HistoryEntry] { get set }
    func getHistory()
    func update(with index: Int)
    func clearHistory()
}

// MARK: - HistoryPresenter
final class HistoryPresenter {
    var history: [HistoryEntry] = []
    weak var view: HistoryViewControllerProtocol?
    
    init(){}
}

// MARK: - HistoryPresenterProtocol methods
extension HistoryPresenter: HistoryPresenterProtocol {
    func getHistory() {
        HistoryPersistenceManager.retrieveHistory { [weak self] (result) in
            switch result {
            case .success(let history):
                self?.history = history
                guard let history = self?.history else { return }
                history.isEmpty ?
                self?.view?.showEmptyState() : self?.view?.updateUI(with: history)
            case .failure(let error):
                self?.view?.showFailAlert(error: error)
            }
        }
    }
    
    func update(with index: Int) {
        HistoryPersistenceManager.updateWith(entry: history[index], actionType: .remove) { [weak self] (error) in
            guard let error = error else  {
                self?.history.remove(at: index)
                guard let history = self?.history else { return }
                self?.view?.updateUI(with: history)
                return
            }
            self?.view?.showFailAlert(error: error)
        }
    }
    
    func clearHistory() {
        HistoryPersistenceManager.deleteAll()
        history = []
        view?.updateUI(with: history)
    }
}
