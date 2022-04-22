//  PageControl

import UIKit

enum Coinlist: String, CaseIterable {
  case tradable = "Tradable"
  case watchlist = "Watchlist"
  case new = "New on Coinlist"
  case all = "All Assets"
}

class MainViewController: UIViewController {
  
  struct Constants {
    static let HeadingFont = UIFont(name: "Avenir-Heavy", size: 32)
    static let HeadingText = "Coinlist"
    static let TitleFont = UIFont(name: "Avenir-Heavy", size: 14)
    static let TitleColor = UIColor(hex: "#171717FF")
    static let UnderlineColor = UIColor(hex: "#1E5128FF")
    static let UnderlineHeight: CGFloat = 2
    static let BackgroundColor = UIColor(hex: "#FFFFFFFF")
    static let HeadingViewHeight: CGFloat = 160
    static let PageControlHeight: CGFloat = 40
    static let StandardMargin: CGFloat = 8
  }
  
  private var viewControllers: [CoinsViewController] = []
  private let titles: [String] = Coinlist.allCases.map { $0.rawValue }
  private var maxHeadingTopOffset: CGFloat {
    Constants.HeadingViewHeight - Constants.PageControlHeight
  }
  
  private var headingView: UIView!
  private var headingViewTop = NSLayoutConstraint()
  private var headingLabel: UILabel!
  private var pageControl: PageControl!
  private var scrollView: UIScrollView!
  private var stackView: UIStackView!
  private var checkScrollPosition: Bool = false
  
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
    headingViewTop = headingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
    let headingViewCon = [
      headingViewTop,
      headingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      headingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      headingView.heightAnchor.constraint(equalToConstant: Constants.HeadingViewHeight)
    ]
    NSLayoutConstraint.activate(headingViewCon)
    
    headingLabel = UILabel()
    headingView.addSubview(headingLabel)
    headingLabel.translatesAutoresizingMaskIntoConstraints = false
    headingLabel.text = Constants.HeadingText
    headingLabel.font = Constants.HeadingFont
    headingLabel.textColor = Constants.TitleColor
    let headingLabelCon = [
      headingLabel.centerXAnchor.constraint(equalTo: headingView.centerXAnchor),
      headingLabel.centerYAnchor.constraint(equalTo: headingView.centerYAnchor)
    ]
    NSLayoutConstraint.activate(headingLabelCon)
    
    let options = PageControlOptions(underlineHeight: Constants.UnderlineHeight,
                                     underlineColor: Constants.UnderlineColor,
                                     titleFont: Constants.TitleFont,
                                     titleColor: Constants.TitleColor,
                                     titles: titles)
    pageControl = PageControl(frame: .zero, options: options)
    headingView.addSubview(pageControl)
    pageControl.translatesAutoresizingMaskIntoConstraints = false
    pageControl.addTarget(self, action: #selector(onCurrentIndexChange), for: .valueChanged)
    let pageControlCon = [
      pageControl.leadingAnchor.constraint(equalTo: headingView.leadingAnchor,
                                           constant: Constants.StandardMargin),
      pageControl.trailingAnchor.constraint(equalTo: headingView.trailingAnchor,
                                            constant: -Constants.StandardMargin),
      pageControl.bottomAnchor.constraint(equalTo: headingView.bottomAnchor),
      pageControl.heightAnchor.constraint(equalToConstant: Constants.PageControlHeight)
    ]
    NSLayoutConstraint.activate(pageControlCon)
    
    scrollView = UIScrollView()
    view.addSubview(scrollView)
    view.sendSubviewToBack(scrollView)
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.bounces = false
    scrollView.isPagingEnabled = true
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.delegate = self
    let scrollViewCon = [
      scrollView.frameLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                       constant: Constants.PageControlHeight),
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
    for list in Coinlist.allCases {
      let viewController = createViewController(withList: list)
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
    
  private func createViewController(withList list: Coinlist) -> CoinsViewController {
    let viewController = CoinsViewController()
    viewController.coinlist = list
    viewController.delegate = self
    viewController.insetTop = maxHeadingTopOffset
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
    var trueOffsetY = scrollView.contentInset.top + offsetY
    trueOffsetY = max(0, min(maxHeadingTopOffset, trueOffsetY))
    headingViewTop.constant = -trueOffsetY
    if trueOffsetY < maxHeadingTopOffset {
      checkScrollPosition = true
      let offset = CGPoint(x: 0, y: offsetY)
      adjustContentOffset(offset)
    }
  }
  
  func didEndDragging(_ scrollView: UIScrollView) {
    guard checkScrollPosition == true else { return }
    let offsetY = scrollView.contentOffset.y
    let trueOffsetY = scrollView.contentInset.top + offsetY
    if trueOffsetY >= maxHeadingTopOffset {
      checkScrollPosition = false
      let offset = CGPoint(x: 0, y: 0)
      adjustContentOffset(offset)
    }
  }
  
  func didEndDecelerating(_ scrollView: UIScrollView) {
    guard checkScrollPosition == true else { return }
    let offsetY = scrollView.contentOffset.y
    let trueOffsetY = scrollView.contentInset.top + offsetY
    if trueOffsetY >= maxHeadingTopOffset {
      checkScrollPosition = false
      let offset = CGPoint(x: 0, y: 0)
      adjustContentOffset(offset)
    }
  }
  
  private func adjustContentOffset(_ contentOffset: CGPoint) {
    for (index, viewController) in viewControllers.enumerated() {
      if index == pageControl.currentIndex { continue }
      viewController.adjustContentOffset(contentOffset)
    }
  }
}
