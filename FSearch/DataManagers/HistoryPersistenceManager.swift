//
//  PersistenceManager.swift
//  FSearch
//
//  Created by Sergei Krupenikov on 05.08.2023.
//

import Foundation
// MARK: - PersistenceActionType
enum PersistenceActionType {
    case add, remove
}

// MARK: - HistoryPersistenceManager
enum HistoryPersistenceManager {
    private static let defaults = UserDefaults.standard
    private struct Keys { static let history = "history" }
}

// MARK: - public methods
extension HistoryPersistenceManager {
    static func updateWith(entry: HistoryEntry, actionType: PersistenceActionType, completed: @escaping (FSError?) -> Void) {
        retrieveHistory { (result) in
            switch result {
            case .success(var history):
                switch actionType {
                case .add:
                    history.insert(entry, at: 0)
                case .remove:
                    history.removeAll { $0.date == entry.date }
                }
                completed(save(history: history))
            case .failure(let error):
                completed(error)
            }
        }
    }

    static func retrieveHistory(completed: @escaping (Result<[HistoryEntry], FSError>) -> Void) {
        guard let historyData = defaults.object(forKey: Keys.history) as? Data else {
            completed(.success([]))
            return
        }
        do {
            let decoder = JSONDecoder()
            let history = try decoder.decode([HistoryEntry].self, from: historyData)
            completed(.success(history))
        } catch {
            completed(.failure(.unableToRead))
        }
    }

    static func deleteAll() {
        defaults.set([HistoryEntry](), forKey: Keys.history)
    }
}

// MARK: - private methods
extension HistoryPersistenceManager {
    private static func save(history: [HistoryEntry]) -> FSError? {
        do {
            let encoder = JSONEncoder()
            let encodedHistory = try encoder.encode(history)
            defaults.set(encodedHistory, forKey: Keys.history)
            return nil
        } catch {
            return .unableToRead
        }
    }
}
