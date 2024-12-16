import Foundation
import UIKit

class CryptoCoinsViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {
    
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    private let filterButton = UIButton(type: .system)
    
    private var viewModel: CryptoCoinsViewModel!
    
    // Initialize ViewController with ViewModel (injected via the App struct)
    init(viewModel: CryptoCoinsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the view
        setupView()
        
        // Fetch data from ViewModel
        viewModel.fetchCoins()
        
        // Bind the ViewModel's data to reload the table view when data changes
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    private func setupView() {
        // Setup the search bar
        searchBar.placeholder = "Search by name or symbol"
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)

        // Setup the filter button
        filterButton.setTitle("Filter", for: .normal)
        filterButton.addTarget(self, action: #selector(showFilters), for: .touchUpInside)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterButton)

        // Setup the table view
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CryptoCoinCell.self, forCellReuseIdentifier: CryptoCoinCell.identifier)
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.keyboardDismissMode = .onDrag
        tableView.showsVerticalScrollIndicator = false

        // Apply Layout Constraints
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 44),

            filterButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            filterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterButton.heightAnchor.constraint(equalToConstant: 36),

            tableView.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - UITableViewDataSource Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredCoins.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CryptoCoinCell.identifier, for: indexPath) as! CryptoCoinCell
        let coin = viewModel.filteredCoins[indexPath.row]
        cell.configure(with: coin)
        cell.selectionStyle = .none
        return cell
    }

    // MARK: - Search Bar Logic

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(query: searchText)
    }

    // MARK: - Filter Logic

    @objc private func showFilters() {
        let filterAlert = UIAlertController(title: "Filters", message: "Select filter criteria", preferredStyle: .actionSheet)

        filterAlert.addAction(UIAlertAction(title: "Active", style: .default, handler: { [weak self] _ in
            self?.viewModel.applyFilters(isActive: true, isNew: nil, type: nil)
        }))
        
        filterAlert.addAction(UIAlertAction(title: "Inactive", style: .default, handler: { [weak self] _ in
            self?.viewModel.applyFilters(isActive: false, isNew: nil, type: nil)
        }))

        filterAlert.addAction(UIAlertAction(title: "New", style: .default, handler: { [weak self] _ in
            self?.viewModel.applyFilters(isActive: nil, isNew: true, type: nil)
        }))
        
        filterAlert.addAction(UIAlertAction(title: "Clear Filters", style: .cancel, handler: { [weak self] _ in
            self?.viewModel.applyFilters(isActive: nil, isNew: nil, type: nil)
        }))

        present(filterAlert, animated: true, completion: nil)
    }
}
