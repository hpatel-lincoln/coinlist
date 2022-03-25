//  PageControl

import UIKit

class MainViewController: UIViewController {
  
  struct Constants {
    static let HeadingFont = UIFont(name: "Avenir-Heavy", size: 32)
    static let TitleFont = UIFont(name: "Avenir-Heavy", size: 14)
    static let TitleColor = UIColor(hex: "#EDEDEDFF")
    static let UnderlineColor = UIColor(hex: "#1E5128FF")
    static let UnderlineHeight: CGFloat = 2
    static let BackgroundColor = UIColor(hex: "#171717FF")
    static let HeadingViewHeight: CGFloat = 150
  }
  
  private var viewControllers: [CoinsViewController] = []
  private let titles: [String] = ["Tradable",
                                  "Watchlist",
                                  "New Listings",
                                  "All Assets"]
  
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
      headingView.heightAnchor.constraint(equalToConstant: Constants.HeadingViewHeight)
    ]
    NSLayoutConstraint.activate(headingViewCon)
    
    var container = AttributeContainer()
    container.font = Constants.TitleFont
    container.foregroundColor = Constants.TitleColor
    let options = PageControlOptions(underlineHeight: Constants.UnderlineHeight,
                                     underlineColor: Constants.UnderlineColor,
                                     titleFont: Constants.TitleFont,
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
      viewControllers.append(viewController)
      
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
    
  private func createViewController(withTitle title: String) -> CoinsViewController {
    let viewController = CoinsViewController()
    viewController.delegate = self
    return viewController
  }
  
  @objc private func onCurrentIndexChange() {
    let currentIndex = CGFloat(pageControl.currentIndex)
    let pageWidth = scrollView.bounds.width
    let offsetX = currentIndex * pageWidth
    scrollView.contentOffset.x = offsetX
  }
}

extension MainViewController: UIScrollViewDelegate {
  
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

extension MainViewController: CoinsViewControllerDelegate {
  
  func didScroll(_ scrollView: UIScrollView) {
    let offsetY = scrollView.contentOffset.y
    
    // scrolling up and more room to move header up
    if offsetY > 0 && headingViewTopCon.constant > -Constants.HeadingViewHeight  {
      let newTopCon = max(-Constants.HeadingViewHeight, headingViewTopCon.constant - offsetY)
      headingViewTopCon.constant = newTopCon
      scrollView.contentOffset.y = 0
    }
    
    // scrolling down and more room to move header down
    if offsetY < 0 && headingViewTopCon.constant < 0 {
      resetScroll()
      let newTopCon = min(0, headingViewTopCon.constant - offsetY)
      headingViewTopCon.constant = newTopCon
      scrollView.contentOffset.y = 0
    }
  }
  
  private func resetScroll() {
    for (index, viewController) in viewControllers.enumerated() {
      if index == pageControl.currentIndex { continue }
      viewController.scrollToTop()
    }
  }
}
