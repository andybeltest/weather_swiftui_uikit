//
//  SearchViewController.swift
//  WeatherJp
//
//  Created by Andrey Belonogov on 9/17/23.
//

import UIKit
import Combine

protocol SearchViewControllerDelegate: AnyObject {
    func didSelect(controller: SearchViewController, item: SearchItem)
}

class SearchViewController: UIViewController {
    let viewModel: SearchViewModel
    weak var delegate: SearchViewControllerDelegate?
    let section = SearchSection(id: "main")
    
    // Using Combine as Apple swift-async-algorithms doesn't support Cocoapods
    private var searchTextSubject = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Lifecycle
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        observeDebouncedSearch()
    }
    
    private func setupViews() {
        view.addSubview(searchStack)
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            searchStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            searchStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            searchStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            searchStack.heightAnchor.constraint(equalToConstant: 78),
            collectionView.topAnchor.constraint(equalTo: searchStack.bottomAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    // MARK: - Setup views
    
    private lazy var collectionView: UICollectionView = {
        collectionView = .init(frame: view.bounds, collectionViewLayout: listLayout)
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var listLayout: UICollectionViewLayout = {
        var listConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: listConfig)
    }()
    
    private let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SearchItem>(
        handler: { (cell: UICollectionViewListCell, _, itemModel: SearchItem) in
            var content = cell.defaultContentConfiguration()
            content.text = itemModel.id
            cell.contentConfiguration = content
        })
    
    private lazy var dataSource = UICollectionViewDiffableDataSource<SearchSection, SearchItem>(
        collectionView: collectionView,
        cellProvider: { [weak self] (collectionView, indexPath, itemModel) -> UICollectionViewCell? in
            guard let self = self else { return nil }
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemModel)
            return cell
        })
    
    lazy var searchBar: UISearchBar = {
        let s = UISearchBar()
        s.placeholder = "Search places"
        s.delegate = self
        s.sizeToFit()
        return s
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let xImage = UIImage(systemName: "xmark")
        button.setImage(xImage, for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var searchStack: UIStackView = {
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints=false
        
        
        let searchStack = UIStackView(arrangedSubviews: [searchBar, backButton])
        searchStack.axis = .horizontal
        searchStack.distribution = .fill
        searchStack.alignment = .fill
        searchStack.spacing = 16
        searchStack.translatesAutoresizingMaskIntoConstraints = false
        return searchStack
    }()
    
    // MARK: - Actions
    
    private func search(text: String) {
        Task {
            do {
                let items = try await viewModel.search(text: text)
                await MainActor.run {
                    self.applySnapshot(items: items)
                }
            } catch {
                print("Error during search \(error)")
            }
        }
    }
    
    private func applySnapshot(items: [SearchItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<SearchSection, SearchItem>()
        snapshot.appendSections([section])
        snapshot.appendItems(items, toSection: section)
        dataSource.apply(snapshot, animatingDifferences: true) {}
    }
    
    private func observeDebouncedSearch() {
        searchTextSubject
            .debounce(for: .seconds(0.1), scheduler: RunLoop.main)
            .map { $0.lowercased() }
            .sink { [weak self] (text: String) in
                guard let self = self else { return }
                let trimmed = text.trimmingCharacters(in: NSCharacterSet.whitespaces)
                if trimmed.isEmpty {
                    applySnapshot(items: viewModel.prevResult)
                } else {
                    search(text: trimmed)
                }
            }
            .store(in: &cancellables)
    }
    
    @objc func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) { // called when text ends editing
        searchTextSubject.send(searchBar.text ?? "")
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = self.dataSource.itemIdentifier(for: indexPath) else { return }
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.didSelect(controller: self, item: item)
        navigationController?.popViewController(animated: true)
    }
}
