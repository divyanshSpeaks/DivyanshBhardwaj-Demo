import XCTest
@testable import DivyanshBhardwaj_Demo

class CryptoCoinsDataManagerTests: XCTestCase {
    var cryptoCoinsDataManager: CryptoCoinsDataManager!

    override func setUp() {
        super.setUp()
        cryptoCoinsDataManager = CryptoCoinsDataManager()
    }

    func testFetchCryptoCoins() {
        let expectation = self.expectation(description: "Fetching coins")

        cryptoCoinsDataManager.fetchCryptoCoins { result in
            switch result {
            case .success(let coins):
                XCTAssertGreaterThan(coins.count, 0, "Coins should not be empty")
            case .failure(let error):
                XCTFail("Error fetching coins: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
}
