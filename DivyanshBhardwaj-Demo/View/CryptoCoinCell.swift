import UIKit

class CryptoCoinCell: UITableViewCell {

    static let identifier = "CryptoCoinCell"
    
    private let nameLabel = UILabel()
    private let symbolLabel = UILabel()
    private let typeImageView = UIImageView()
    private let newCryptoImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Configure labels
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        typeImageView.translatesAutoresizingMaskIntoConstraints = false
        newCryptoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        symbolLabel.font = UIFont.systemFont(ofSize: 14)
        
        // Add labels to content view
        contentView.addSubview(nameLabel)
        contentView.addSubview(symbolLabel)
        contentView.addSubview(typeImageView)
        contentView.addSubview(newCryptoImageView)
        
        // Apply Auto Layout constraints
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with coin: CryptoCoin) {
        nameLabel.text = coin.name
        symbolLabel.text = coin.symbol
        configureTypeImage(with: coin)
        // Adjust content view's alpha based on the 'isActive' status
        contentView.alpha = coin.isActive ? 1.0 : 0.5
    }
    
    func configureTypeImage(with coin: CryptoCoin) {
        var typeName = coin.type
        if !coin.isActive {
            typeName = "inactive"
        }
        
        typeImageView.image = UIImage(named: typeName.lowercased())
        
        newCryptoImageView.image = UIImage(named: "new")
        newCryptoImageView.isHidden = !coin.isNew
    }
    
    private func setupConstraints() {
        // Constraints for nameLabel
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        // Constraints for symbolLabel
        NSLayoutConstraint.activate([
            symbolLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            symbolLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            symbolLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        // Constraints for typeLabel
        NSLayoutConstraint.activate([
            typeImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
            typeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            typeImageView.widthAnchor.constraint(equalToConstant: 30),
            typeImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // Constraints for typeLabel
        NSLayoutConstraint.activate([
            newCryptoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -2),
            newCryptoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 2),
            newCryptoImageView.widthAnchor.constraint(equalToConstant: 30),
            newCryptoImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
