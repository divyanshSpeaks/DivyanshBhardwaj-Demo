import Foundation

class MockCryptoCoinsDataSource: CryptoCoinsDataSource {
    var coins: [CryptoCoin]
    var shouldFail: Bool = false  // Flag to simulate failure

    init(coins: [CryptoCoin], shouldFail: Bool = false) {
        self.coins = coins
        self.shouldFail = shouldFail
    }

    func fetchCryptoCoins(completion: @escaping (Result<[CryptoCoin], Error>) -> Void) {
        if shouldFail {
            // Simulate a failure
            completion(.failure(NSError(domain: "com.crypto", code: 404, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch coins"])))
        } else {
            // Simulate success
            completion(.success(coins))
        }
    }
}
