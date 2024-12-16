import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}

extension UITableView {
    func registerCell<T: UITableViewCell>(_ cellType: T.Type) {
        register(cellType, forCellReuseIdentifier: String(describing: cellType))
    }
}

extension UIColor {
    static let primaryColor = UIColor.systemBlue
    static let secondaryColor = UIColor.systemGray
}
