//  PageControl

import UIKit

class CoinViewCell: UITableViewCell {
  
  struct Constants {
    static let TextFont = UIFont(name: "Avenir", size: 12)
    static let TextColor = UIColor(hex: "#171717FF")
    static let StandardMargin: CGFloat = 16
    static let IconSize: CGFloat = 24
  }
  
  var coin: Coin? {
    didSet {
      updateUI()
    }
  }
  
  private var icon: UIImageView!
  private var label: UILabel!
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("\(CoinViewCell.self): init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    icon.image = nil
    label.text = nil
  }
  
  private func initView() {
    backgroundColor = .clear
    
    icon = UIImageView()
    icon.translatesAutoresizingMaskIntoConstraints = false
    icon.contentMode = .scaleAspectFit
    addSubview(icon)
    
    let iconHeightCon = icon.heightAnchor.constraint(equalToConstant: Constants.IconSize)
    iconHeightCon.priority = .defaultHigh
    let iconWidthCon = icon.widthAnchor.constraint(equalToConstant: Constants.IconSize)
    
    let iconCon = [
      icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.StandardMargin),
      icon.topAnchor.constraint(equalTo: topAnchor, constant: Constants.StandardMargin),
      icon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.StandardMargin),
      iconHeightCon, iconWidthCon
    ]
    NSLayoutConstraint.activate(iconCon)
    
    label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Constants.TextFont
    label.textColor = Constants.TextColor
    addSubview(label)
    
    let labelCon = [
      label.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: Constants.StandardMargin),
      label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.StandardMargin),
      label.centerYAnchor.constraint(equalTo: centerYAnchor)
    ]
    NSLayoutConstraint.activate(labelCon)
  }
  
  private func updateUI() {
    guard let coin = coin else {
      icon.image = nil
      label.text = nil
      return
    }
    
    icon.image = UIImage(named: coin.icon)
    label.text = coin.name
  }
}
