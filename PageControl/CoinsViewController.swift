//  PageControl

import UIKit

protocol CoinsViewControllerDelegate: AnyObject {
  func didScroll(_ scrollView: UIScrollView)
  func didEndDragging(_ scrollView: UIScrollView)
  func didEndDecelerating(_ scrollView: UIScrollView)
}

class CoinsViewController: UIViewController {
    
  weak var delegate: CoinsViewControllerDelegate?
  var coinlist: Coinlist = .all
  var insetTop: CGFloat = 0
  
  private var tableView: UITableView!
  private var coins = Coin.allCoins().sorted { $0.rank < $1.rank }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    filterCoins()
    initView()
    configureTableView()
  }
  
  private func filterCoins() {
    switch coinlist {
    case .tradable:
      coins = coins.filter{ $0.tradable }
    case .watchlist:
      coins = coins.filter{ $0.watchilist }
    case .new:
      coins = coins.filter{ $0.new }
    case .all:
      break
    }
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
    
    tableView.register(CoinViewCell.self, forCellReuseIdentifier: "\(CoinViewCell.self)")
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.contentInset.top = insetTop
    tableView.contentOffset.y = -insetTop
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 100
    tableView.separatorStyle = .none
  }
}

extension CoinsViewController: UITableViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    delegate?.didScroll(scrollView)
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if !decelerate { delegate?.didEndDragging(scrollView) }
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    delegate?.didEndDecelerating(scrollView)
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
    let cell = tableView.dequeueReusableCell(withIdentifier: "\(CoinViewCell.self)", for: indexPath) as! CoinViewCell
    let coin = coins[indexPath.row]
    cell.coin = coin
    return cell
  }
}

extension CoinsViewController {
  
  func adjustContentOffset(_ contentOffset: CGPoint) {
    tableView.bounds.origin = contentOffset
  }
}
