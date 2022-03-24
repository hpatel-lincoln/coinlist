//  PageControl

import UIKit

class ViewController: UIViewController {
  
  struct Constants {
    static let TitleFontBig = UIFont(name: "Avenir-Heavy", size: 40)
    static let TitleFontSmall = UIFont(name: "Avenir-Heavy", size: 18)
    static let TitleColor = UIColor(hex: "#EDEDEDFF")
    static let UnderlineColor = UIColor(hex: "#1E5128FF")
    static let UnderlineHeight: CGFloat = 2
    static let BackgroundColor = UIColor(hex: "#171717FF")
  }
  
  let titles: [String] = ["One", "Two", "Three", "Four"]
  
  @IBOutlet var scrollView: UIScrollView!
  @IBOutlet var stackView: UIStackView!
  @IBOutlet var pageControl: PageControl!
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    .lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    scrollView.bounces = false
    scrollView.delegate = self
    
    for title in titles {
      let viewController = createViewController(withTitle: title)
      
      addChild(viewController)
      stackView.addArrangedSubview(viewController.view)
      let constraints = [
        viewController.view.widthAnchor.constraint(equalTo: view.widthAnchor),
        viewController.view.heightAnchor.constraint(equalTo: view.heightAnchor)
      ]
      NSLayoutConstraint.activate(constraints)
      viewController.didMove(toParent: self)
    }
    
    pageControl.titles = titles
    pageControl.underlineColor = Constants.UnderlineColor
    pageControl.underlineHeight = Constants.UnderlineHeight
    var container = AttributeContainer()
    container.font = Constants.TitleFontSmall
    container.foregroundColor = Constants.TitleColor
    pageControl.titleAttributedContainer = container
    pageControl.addTarget(self, action: #selector(onCurrentIndexChange), for: .valueChanged)
  }
  
  @objc private func onCurrentIndexChange() {
    let currentIndex = CGFloat(pageControl.currentIndex)
    let pageWidth = scrollView.bounds.width
    let offsetX = currentIndex * pageWidth
    scrollView.contentOffset.x = offsetX
  }
  
  private func createViewController(withTitle title: String) -> UIViewController {
    let viewController = UIViewController()
    viewController.view.backgroundColor = Constants.BackgroundColor
    
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = title
    label.font = Constants.TitleFontBig
    label.textColor = Constants.TitleColor
    
    viewController.view.addSubview(label)
    let constraints = [
      label.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor)
    ]
    NSLayoutConstraint.activate(constraints)
    
    return viewController
  }
}

extension ViewController: UIScrollViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let currentOffsetX = scrollView.contentOffset.x
    let pageWidth = scrollView.bounds.width
    
    let currentIndex = max(0, Int(round(currentOffsetX/pageWidth)))
    let currentPageX = CGFloat(currentIndex) * pageWidth
    let percent = (currentOffsetX - currentPageX)/pageWidth
    
    pageControl.currentIndex = currentIndex
    pageControl.userDidScroll(toPercent: percent)
  }
}
