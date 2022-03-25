//  PageControl

import UIKit

class TableViewController: UIViewController {
  
  struct Constants {
    static let TextFont = UIFont(name: "Avenir-Heavy", size: 12)
    static let TextColor = UIColor(hex: "#EDEDEDFF")
  }
  
  var itemLabel: String?
  
  private var tableView: UITableView!
  private let numberOfItems: Int = 20
  
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

extension TableViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

extension TableViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return numberOfItems
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "\(UITableViewCell.self)", for: indexPath)
    cell.backgroundColor = .clear
    cell.textLabel?.font = Constants.TextFont
    cell.textLabel?.textColor = Constants.TextColor
    cell.textLabel?.text = "\(itemLabel ?? "Label") - \(indexPath.row+1)"
    return cell
  }
}
