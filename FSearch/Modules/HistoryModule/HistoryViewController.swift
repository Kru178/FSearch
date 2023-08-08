//
//  HistoryViewController.swift
//  FSearch
//
//  Created by Sergei Krupenikov on 03.08.2023.
//

import UIKit
// MARK: - HistoryViewControllerProtocol
protocol HistoryViewControllerProtocol: AnyObject {
    func updateUI(with history: [HistoryEntry])
    func showEmptyState()
    func showFailAlert(error: FSError) 
}

// MARK: - HistoryViewController
final class HistoryViewController: UIViewController {
    lazy private var tableView: UITableView = {
        let table = UITableView()
        table.rowHeight = 44
        table.delegate = self
        table.dataSource = self
        table.frame = view.bounds
        table.register(HistoryCell.self, forCellReuseIdentifier: HistoryCell.reuseID)
        table.removeExcessiveCells()
        return table
    }()
    lazy private var clearButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = Constants.Buttons.clear
        button.target = self
        button.action = #selector(clearHistory)
        return button
    }()
    private let presenter: HistoryPresenterProtocol
    
    init(presenter: HistoryPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.getHistory()
    }

    private func configureViewController() {
        view.backgroundColor = .systemBackground
        title = Constants.Tabs.history
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(tableView)
        navigationItem.rightBarButtonItem = clearButton
    }
    
    
    @objc private func clearHistory() {
        guard !presenter.history.isEmpty else { return }
        showAlert(
            alertText: Constants.Alert.History.title,
            alertMessage: Constants.Alert.History.body,
            alertType: .action
        ) { _ in
            self.presenter.clearHistory()
        }
    }
}

// MARK: - HistoryViewControllerProtocol methods
extension HistoryViewController: HistoryViewControllerProtocol {
    func updateUI(with history: [HistoryEntry]) {
        dismissEmptyStateView()
        tableView.reloadDataOnMainThread()
    }
    
    func showEmptyState() {
        showEmptyStateView(with: Constants.EmptyStateMessage.history, in: self.view, withImage: false)
    }
    
    func showFailAlert(error: FSError) {
        showAlert(alertText: Constants.Alert.errorTitle, alertMessage: error.rawValue, alertType: .information, handler: nil)
    }
}

// MARK: - tableview datasource methods
extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.reuseID, for: indexPath) as! HistoryCell
        let entry = presenter.history[indexPath.row]
        cell.set(history: entry)
        return cell
    }
}

// MARK: - tableview delegate methods
extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let keyword = presenter.history[indexPath.row].text
        let networkService = NetworkService()
        let dataSource = PhotoDataManager(networkService: networkService)
        let imagesPresenter = ImagesPresenter(keyword: keyword, datasource: dataSource)
        let imagesViewController = ImagesViewController(presenter: imagesPresenter)
        imagesPresenter.view = imagesViewController
        navigationController?.pushViewController(imagesViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        presenter.update(with: indexPath.row)
    }
}
