import Foundation

class CryptoCoinsDataManager: CryptoCoinsDataSource {
    
    private let baseURL = "https://37656be98b8f42ae8348e4da3ee3193f.api.mockbin.io/"

    func fetchCryptoCoins(completion: @escaping (Result<[CryptoCoin], Error>) -> Void) {
        guard let url = URL(string: baseURL) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let coins = try JSONDecoder().decode([CryptoCoin].self, from: data)
                completion(.success(coins))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
