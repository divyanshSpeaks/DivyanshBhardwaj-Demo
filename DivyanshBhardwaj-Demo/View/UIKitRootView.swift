import Foundation
import SwiftUI

struct UIKitRootView: UIViewControllerRepresentable {
    // This method creates the UIKit ViewController
    func makeUIViewController(context: Context) -> CryptoCoinsViewController {
        
        let cryptoCoinsVieModel = CryptoCoinsViewModel()
        return CryptoCoinsViewController(viewModel: cryptoCoinsVieModel)
    }

    // This method updates the UIKit ViewController when the SwiftUI view updates
    func updateUIViewController(_ uiViewController: CryptoCoinsViewController, context: Context) {
        // No additional updates needed for this project
    }
}
