//  PageControl

import UIKit

class ViewController: UIViewController {
  
  struct Constants {
    static let TitleFontBig = UIFont(name: "Avenir-Heavy", size: 32)
    static let TitleFontSmall = UIFont(name: "Avenir-Heavy", size: 14)
    static let TitleColor = UIColor(hex: "#EDEDEDFF")
    static let UnderlineColor = UIColor(hex: "#1E5128FF")
    static let UnderlineHeight: CGFloat = 2
    static let BackgroundColor = UIColor(hex: "#171717FF")
  }
  
  let titles: [String] = ["Tradable", "Watchlist", "New Listings", "All Assets"]
  
  private var headingView: UIView!
  private var headingViewTopCon = NSLayoutConstraint()
  
  private var pageControl: PageControl!
  private var scrollView: UIScrollView!
  private var stackView: UIStackView!
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    .lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = Constants.BackgroundColor
    initView()
    addChildViewControllers()
  }
  
  private func initView() {
    headingView = UIView()
    view.addSubview(headingView)
    headingView.translatesAutoresizingMaskIntoConstraints = false
    headingView.backgroundColor = .clear
    headingViewTopCon = headingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
    let headingViewCon = [
      headingViewTopCon,
      headingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      headingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      headingView.heightAnchor.constraint(equalToConstant: 150)
    ]
    NSLayoutConstraint.activate(headingViewCon)
    
    var container = AttributeContainer()
    container.font = Constants.TitleFontSmall
    container.foregroundColor = Constants.TitleColor
    let options = PageControlOptions(underlineHeight: Constants.UnderlineHeight,
                                     underlineColor: Constants.UnderlineColor,
                                     titleFont: Constants.TitleFontSmall,
                                     titleColor: Constants.TitleColor,
                                     titles: titles)
    pageControl = PageControl(frame: .zero, options: options)
    view.addSubview(pageControl)
    pageControl.translatesAutoresizingMaskIntoConstraints = false
    pageControl.addTarget(self, action: #selector(onCurrentIndexChange), for: .valueChanged)
    let pageControlCon = [
      pageControl.topAnchor.constraint(equalTo: headingView.bottomAnchor),
      pageControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                           constant: 8),
      pageControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                            constant: -8),
      pageControl.heightAnchor.constraint(equalToConstant: 40)
    ]
    NSLayoutConstraint.activate(pageControlCon)
    
    scrollView = UIScrollView()
    view.addSubview(scrollView)
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.bounces = false
    scrollView.isPagingEnabled = true
    scrollView.delegate = self
    let scrollViewCon = [
      scrollView.frameLayoutGuide.topAnchor.constraint(equalTo: pageControl.bottomAnchor),
      scrollView.frameLayoutGuide.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      scrollView.frameLayoutGuide.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      scrollView.frameLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ]
    NSLayoutConstraint.activate(scrollViewCon)
    
    stackView = UIStackView()
    scrollView.addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fill
    let stackViewCon = [
      stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
      stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
      stackView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
    ]
    NSLayoutConstraint.activate(stackViewCon)
  }
  
  private func addChildViewControllers() {
    for title in titles {
      let viewController = createViewController(withTitle: title)
      
      addChild(viewController)
      stackView.addArrangedSubview(viewController.view)
      let childViewControllerCon = [
        viewController.view.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
        viewController.view.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
      ]
      NSLayoutConstraint.activate(childViewControllerCon)
      viewController.didMove(toParent: self)
    }
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
  
  @objc private func onCurrentIndexChange() {
    let currentIndex = CGFloat(pageControl.currentIndex)
    let pageWidth = scrollView.bounds.width
    let offsetX = currentIndex * pageWidth
    scrollView.contentOffset.x = offsetX
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
