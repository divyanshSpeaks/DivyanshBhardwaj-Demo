import Foundation

// Define a protocol for the data source
protocol CryptoCoinsDataSource {
    func fetchCryptoCoins(completion: @escaping (Result<[CryptoCoin], Error>) -> Void)
}

class CryptoCoinsViewModel {
    
    private var dataSource: CryptoCoinsDataSource = CryptoCoinsDataManager()
    private var allCoins: [CryptoCoin] = []
    
    // The filteredCoins is now public and can be updated externally.
    private(set) var filteredCoins: [CryptoCoin] = []  // Keep the setter private

    var onDataUpdated: (() -> Void)?
    
    init() {
    }
    
    // Inject the data source using dependency injection.
    init(dataSource: CryptoCoinsDataSource) {
        self.dataSource = dataSource
    }
    
    func fetchCoins() {
        dataSource.fetchCryptoCoins { [weak self] result in
            switch result {
            case .success(let coins):
                self?.allCoins = coins
                self?.filteredCoins = coins
                self?.onDataUpdated?()
            case .failure(let error):
                print("Error fetching coins: \(error)")
            }
        }
    }

    func applyFilters(isActive: Bool?, isNew: Bool?, type: String?) {
        filteredCoins = allCoins.filter { coin in
            let matchesActive = isActive == nil || coin.isActive == isActive
            let matchesNew = isNew == nil || coin.isNew == isNew
            let matchesType = type == nil || coin.type == type
            return matchesActive && matchesNew && matchesType
        }
        onDataUpdated?()
    }

    func search(query: String) {
        guard !query.isEmpty else {
            filteredCoins = allCoins
            onDataUpdated?()
            return
        }
        filteredCoins = allCoins.filter {
            $0.name.lowercased().contains(query.lowercased()) ||
            $0.symbol.lowercased().contains(query.lowercased())
        }
        onDataUpdated?()
    }
}
