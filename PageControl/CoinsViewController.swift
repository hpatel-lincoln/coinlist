//  PageControl

import UIKit

protocol CoinsViewControllerDelegate: AnyObject {
  func didScroll(_ scrollView: UIScrollView)
}

class CoinsViewController: UIViewController {
  
  struct Constants {
    static let TextFont = UIFont(name: "Avenir-Heavy", size: 12)
    static let TextColor = UIColor(hex: "#EDEDEDFF")
  }
  
  weak var delegate: CoinsViewControllerDelegate?
  
  private var tableView: UITableView!
  private let coins = Coin.allCoins().sorted { $0.rank < $1.rank }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initView()
    configureTableView()
  }
  
  private func initView() {
    view.backgroundColor = .clear
    
    tableView = UITableView()
    view.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    let tableViewCon = [
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
    ]
    NSLayoutConstraint.activate(tableViewCon)
  }
  
  private func configureTableView() {
    tableView.backgroundColor = .clear
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "\(UITableViewCell.self)")
  }
}

extension CoinsViewController: UITableViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    delegate?.didScroll(scrollView)
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

extension CoinsViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return coins.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "\(UITableViewCell.self)", for: indexPath)
    cell.backgroundColor = .clear
    cell.textLabel?.font = Constants.TextFont
    cell.textLabel?.textColor = Constants.TextColor
    let coin = coins[indexPath.row]
    cell.textLabel?.text = "\(coin.name)"
    return cell
  }
}

extension CoinsViewController {
  
  func scrollToTop() {
    tableView.contentOffset.y = 0
  }
}
