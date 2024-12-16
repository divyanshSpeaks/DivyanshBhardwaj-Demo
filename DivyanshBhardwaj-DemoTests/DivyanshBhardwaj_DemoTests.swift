import XCTest
@testable import DivyanshBhardwaj_Demo

final class DivyanshBhardwaj_DemoTests: XCTestCase {
    
    func testDecodingCryptoCoin() {
        let json = """
        {
            "name": "Bitcoin",
            "symbol": "BTC",
            "type": "coin",
            "is_active": true,
            "is_new": false
        }
        """
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()

        do {
            let coin = try decoder.decode(CryptoCoin.self, from: data)
            XCTAssertEqual(coin.name, "Bitcoin")
            XCTAssertEqual(coin.symbol, "BTC")
            XCTAssertTrue(coin.isActive)
        } catch {
            XCTFail("Decoding failed: \(error)")
        }
    }
}
