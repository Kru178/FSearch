//
//  SearchViewController.swift
//  FSearch
//
//  Created by Sergei Krupenikov on 04.08.2023.
//

import UIKit
// MARK: - SearchViewControllerProtocol
protocol SearchViewControllerProtocol: AnyObject {
    func showEmptySearchAlert()
    func showResultScreen(for keyword: String)
}

// MARK: - SearchViewController
final class SearchViewController: UIViewController {
    private let presenter: SearchPresenterProtocol
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 30
        stack.distribution = .fillProportionally
        return stack
    }()
    private let logoImageView: UIImageView = {
        let image = UIImageView()
        image.image = Constants.Images.logo
        image.contentMode = .scaleAspectFit
        return image
    }()
    private let searchTextField = SearchTextField()
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.Buttons.search, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        return button
    }()
    // this constraint changes depending on keyboard height
    private lazy var stackCenterY: NSLayoutConstraint = stack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
    
    init(presenter: SearchPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureViews()
        createDismissKeyboardTapGesture()
        registerForKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc private func searchButtonTapped() {
        searchTextField.resignFirstResponder()
        presenter.initiateSearchFor(keyword: searchTextField.text)
    }
    
    private func configureViews() {
        searchTextField.delegate = self
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        
        view.addSubview(stack)
        stack.addArrangedSubviews(views: logoImageView, searchTextField, searchButton)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackCenterY,
            
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            
            searchTextField.heightAnchor.constraint(equalToConstant: 50),
            
            searchButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

// MARK: - SearchViewControllerProtocol methods
extension SearchViewController: SearchViewControllerProtocol {
    func showEmptySearchAlert() {
        showAlert(alertText: Constants.Alert.EmptySearch.title, alertMessage: Constants.Alert.EmptySearch.body, alertType: .information, handler: nil)
    }
    
    func showResultScreen(for keyword: String) {
        let networkService = NetworkService()
        let dataSource = PhotoDataManager(networkService: networkService)
        let imagesPresenter = ImagesPresenter(keyword: keyword, datasource: dataSource)
        let imagesViewController = ImagesViewController(presenter: imagesPresenter)
        imagesPresenter.view = imagesViewController
        navigationController?.pushViewController(imagesViewController, animated: true)
    }
}

// MARK: - textfield delegate methods
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchButtonTapped()
        return true
    }
}

// MARK: - keyboard methods
extension SearchViewController {
    private func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        moveViewWithKeyboard(notification: notification, viewCenterY: stackCenterY, keyboardWillShow: true)
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        moveViewWithKeyboard(notification: notification, viewCenterY: stackCenterY, keyboardWillShow: false)
    }
    
    private func moveViewWithKeyboard(notification: NSNotification, viewCenterY: NSLayoutConstraint, keyboardWillShow: Bool) {
        // Change the constraint constant
        if keyboardWillShow {
            viewCenterY.constant = -100
        }else {
            viewCenterY.constant = 0
        }
        // Animate the view
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }
}


