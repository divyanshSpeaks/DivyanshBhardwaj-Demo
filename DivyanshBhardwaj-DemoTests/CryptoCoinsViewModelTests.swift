import XCTest
@testable import DivyanshBhardwaj_Demo

class CryptoCoinsViewModelTests: XCTestCase {
    var viewModel: CryptoCoinsViewModel!
    var mockDataSource: MockCryptoCoinsDataSource!
    var viewController: CryptoCoinsViewController!
    
    override func setUp() {
        super.setUp()
        
        createViewModel(shouldFail: false)
        
        // Initialize the ViewController with the ViewModel
        viewController = CryptoCoinsViewController(viewModel: viewModel)
        
        // Call loadViewIfNeeded to load the view manually (this won't call viewDidLoad)
        viewController.loadViewIfNeeded()
    }
    
    // Helper function to create a mock ViewModel with the given success or failure scenario
    private func createViewModel(shouldFail: Bool) {
        let mockCoins = [
            CryptoCoin(name: "Bitcoin", symbol: "BTC", type: "coin", isActive: true, isNew: false),
            CryptoCoin(name: "Ethereum", symbol: "ETH", type: "coin", isActive: true, isNew: true),
            CryptoCoin(name: "Cardano", symbol: "ADA", type: "coin", isActive: false, isNew: false)
        ]
        
        mockDataSource = MockCryptoCoinsDataSource(coins: mockCoins, shouldFail: shouldFail)
        viewModel = CryptoCoinsViewModel(dataSource: mockDataSource)
    }
    
    func testFetchCoins() {
        // Set an expectation for the async data update
        let expectation = self.expectation(description: "Data updated after fetch")
        
        // Bind the ViewModel's data to reload the table view when data changes
        viewModel.onDataUpdated = {
            expectation.fulfill()  // Fulfill the expectation once the data is updated
        }
        
        // Simulate the fetchCoins() method being called
        viewModel.fetchCoins()
        
        // Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 1.0) { error in
            if let error = error {
                XCTFail("Failed to fetch coins: \(error.localizedDescription)")
            }
        }
        
        // Now, check if the data was updated as expected
        XCTAssertEqual(viewModel.filteredCoins.count, 3)
        XCTAssertEqual(viewModel.filteredCoins.first?.name, "Bitcoin")
    }
    
    // Test Case 1: Successful fetch updates filteredCoins
    func testFetchCoins_withSuccessfulFetch_updatesFilteredCoins() {
        createViewModel(shouldFail: false)  // No failure
        let expectation = self.expectation(description: "Data updated after fetch")
        
        // Bind the ViewModel's data to reload the table view when data changes
        viewModel.onDataUpdated = {
            expectation.fulfill()  // Fulfill the expectation once the data is updated
        }
        
        // Call fetchCoins
        viewModel.fetchCoins()
        
        // Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 1.0)
        
        // Assertions
        XCTAssertEqual(viewModel.filteredCoins.count, 3)
        XCTAssertEqual(viewModel.filteredCoins.first?.name, "Bitcoin")
    }
    
    // Test Case 3: Fetch returns empty response (empty list of coins)
    func testFetchCoins_withEmptyResponse_updatesFilteredCoinsToEmpty() {
        // Simulate an empty response
        createViewModel(shouldFail: false)
        mockDataSource.coins = []  // Empty coins list
        let expectation = self.expectation(description: "Data updated after empty fetch")
        
        // Bind the ViewModel's data to reload the table view when data changes
        viewModel.onDataUpdated = {
            expectation.fulfill()  // Fulfill the expectation once the data is updated
        }
        
        // Call fetchCoins
        viewModel.fetchCoins()
        
        // Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 1.0)
        
        // Assertions
        XCTAssertEqual(viewModel.filteredCoins.count, 0)  // The filteredCoins should be empty
    }
    
    // Test Case 4: Simulate a delayed fetch (asynchronous behavior)
    func testFetchCoins_withDelayedFetch_updatesFilteredCoins() {
        createViewModel(shouldFail: false)
        let expectation = self.expectation(description: "Data updated after async fetch")
        
        // Bind the ViewModel's data to reload the table view when data changes
        viewModel.onDataUpdated = {
            expectation.fulfill()  // Fulfill the expectation once the data is updated
        }
        
        // Call fetchCoins (simulating async behavior)
        viewModel.fetchCoins()
        
        // Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 1.0)
        
        // Assertions
        XCTAssertEqual(viewModel.filteredCoins.count, 3)  // Three coins should be updated
        XCTAssertEqual(viewModel.filteredCoins.first?.name, "Bitcoin")
    }
    
    func testApplyFilters() {
        // Apply filter for active coins
        viewModel.applyFilters(isActive: true, isNew: nil, type: nil)
        
        // Assert that only 2 active coins are returned
        XCTAssertEqual(viewModel.filteredCoins.count, 2)
        XCTAssertEqual(viewModel.filteredCoins.first?.name, "Bitcoin")
    }
    
    func testSearch_withEmptyQuery_returnsAllCoins() {
        viewModel.search(query: "")
        
        // Check if all coins are returned
        XCTAssertEqual(viewModel.filteredCoins.count, 3)
        XCTAssertEqual(viewModel.filteredCoins.first?.name, "Bitcoin")
        XCTAssertEqual(viewModel.filteredCoins.last?.name, "Cardano")
    }
    
    func testSearch_withNoMatchingQuery_returnsEmptyArray() {
        viewModel.search(query: "NonExistingCoin")
        
        // Check that the filtered coins are empty
        XCTAssertEqual(viewModel.filteredCoins.count, 0)
    }
    
    func testSearch_withMatchingQuery_returnsMatchingCoins() {
        viewModel.search(query: "Bitcoin")
        
        // Check that only the "Bitcoin" coin is returned
        XCTAssertEqual(viewModel.filteredCoins.count, 1)
        XCTAssertEqual(viewModel.filteredCoins.first?.name, "Bitcoin")
    }
    
    func testSearch_withCaseInsensitiveQuery_returnsMatchingCoins() {
        viewModel.search(query: "bitcoin")
        
        // Check that the search matches "Bitcoin" despite case differences
        XCTAssertEqual(viewModel.filteredCoins.count, 1)
        XCTAssertEqual(viewModel.filteredCoins.first?.name, "Bitcoin")
    }
    
    func testSearch_withCoinSymbolMatchingQuery_returnsMatchingCoins() {
        viewModel.search(query: "BTC")
        
        // Check that the search matches coins with the symbol "BTC"
        XCTAssertEqual(viewModel.filteredCoins.count, 1)
        XCTAssertEqual(viewModel.filteredCoins.first?.symbol, "BTC")
    }
    
    func testSearch_withCoinNameAndSymbolMatchingQuery_returnsMatchingCoins() {
        viewModel.search(query: "ETH")
        
        // Check that the search matches Ethereum by symbol (ETH)
        XCTAssertEqual(viewModel.filteredCoins.count, 1)
        XCTAssertEqual(viewModel.filteredCoins.first?.symbol, "ETH")
    }
    
    func testClearFilters() {
        // Clear filters
        viewModel.applyFilters(isActive: nil, isNew: nil, type: nil)
        
        // Assert that all coins are returned after clearing filters
        XCTAssertEqual(viewModel.filteredCoins.count, 3)
    }
}
