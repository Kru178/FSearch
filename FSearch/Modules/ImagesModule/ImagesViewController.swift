//
//  ImagesViewController.swift
//  FSearch
//
//  Created by Sergei Krupenikov on 03.08.2023.
//

import UIKit
// MARK: - ImagesViewControllerProtocol
protocol ImagesViewControllerProtocol: AnyObject {
    func updateUI(with photos: [Photo])
    func showEmptyState()
    func showFailAlert(error: FSError)
    func proceedToFull(photo: Photo)
}

// MARK: - ImagesViewController
final class ImagesViewController: UIViewController {
    private let presenter: ImagesPresenterProtocol
    private enum Section { case main }
    private var isLoading = false
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: LayoutHelper.createTwoColumnFlowLayout(in: view)
        )
        collection.delegate = self
        collection.dataSource = dataSource
        collection.backgroundColor = .systemBackground
        collection.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseID)
        return collection
    }()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Photo>!
    
    init(presenter: ImagesPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        title = presenter.keyword
        view.backgroundColor = .white
        configureDataSource()
        presenter.provideData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func getData() {
        isLoading = true
        presenter.provideData()
    }
}

// MARK: - ImagesViewControllerProtocol methods
extension ImagesViewController: ImagesViewControllerProtocol {
    func updateUI(with photos: [Photo]) {
        isLoading = false
        self.updateData(with: photos)
    }
    
    func showEmptyState() {
        isLoading = false
        DispatchQueue.main.async {
            self.showEmptyStateView(with: Constants.EmptyStateMessage.images, in: self.view, withImage: true)
        }
    }
    
    func showFailAlert(error: FSError) {
        showAlert(alertText: Constants.Alert.errorTitle, alertMessage: error.rawValue, alertType: .information)
    }
    
    func proceedToFull(photo: Photo) {
        let selectedPresenter = SelectedImagePresenter(photo: photo)
        let selectedImageViewController = SelectedImageViewController(presenter: selectedPresenter)
        selectedPresenter.view = selectedImageViewController
        navigationController?.pushViewController(selectedImageViewController, animated: true)
    }
}

// MARK: - collectionview datasource methods
extension ImagesViewController {
    private func updateData(with items: [Photo]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Photo>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Photo>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, photo) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseID, for: indexPath) as! ImageCell
            cell.set(photo: photo)
            return cell
        })
    }
}

// MARK: - collectionview delegate methods
extension ImagesViewController: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        // loading next page in advance to provide smooth scrolling
        if offsetY > contentHeight - 2 * height {
            // if the previous request still in progress, the next doesn't start
            guard !isLoading else { return }
            getData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.selected(item: indexPath.row)
    }
}


