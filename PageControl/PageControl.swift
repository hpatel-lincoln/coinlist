//  PageControl

import UIKit

class PageControl: UIControl {
  
  // Properties
  private var isReset: Bool = true
  
  var currentIndex: Int = 0 {
    didSet {
      currentIndex = max(min(titles.count-1, currentIndex), 0)
    }
  }
  
  var underlineHeight: CGFloat = 0
  
  var underlineColor: UIColor? = nil {
    didSet {
      underline.backgroundColor = underlineColor
    }
  }

  var titleAttributedContainer: AttributeContainer = AttributeContainer() {
    didSet {
      updateButtons()
    }
  }
  
  var titles: [String] = [] {
    didSet {
      isReset = true
      addButtons()
    }
  }
  
  // Views
  private var stackView: UIStackView!
  private var underline: UIView!
  
  // When the view is initialized from a Nib
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    initView()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    if isReset && titles.isEmpty == false {
      stackView.layoutIfNeeded()
      positionUnderline(toIndex: currentIndex)
      isReset = false
    }
  }
  
  func userDidScroll(toPercent percent: CGFloat) {
    let currentWidth = getWidth(forIndex: currentIndex)
    var toWidth: CGFloat = 0
    
    let currentX = getX(forIndex: currentIndex)
    var toX: CGFloat = 0
    
    // Moving to previous index
    if percent < 0 {
      if currentIndex == 0 { return }
      toWidth = getWidth(forIndex: currentIndex-1)
      toX = getX(forIndex: currentIndex-1)
    } else {
      if currentIndex == titles.count-1 { return }
      toWidth = getWidth(forIndex: currentIndex+1)
      toX = getX(forIndex: currentIndex+1)
    }
    
    // Calculate width
    let deltaWidth = (toWidth - currentWidth) * abs(percent)
    let newWidth = currentWidth + deltaWidth
    
    let deltaX = (toX - currentX) * abs(percent)
    let newX = currentX + deltaX
    
    positionUnderline(toX: newX, width: newWidth)
  }
  
  private func initView() {
    stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.distribution = .fillProportionally
    stackView.alignment = .center
    addSubview(stackView)
    
    let stackViewConstraints = [
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      stackView.topAnchor.constraint(equalTo: topAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ]
    NSLayoutConstraint.activate(stackViewConstraints)
    
    underline = UIView()
    underline.translatesAutoresizingMaskIntoConstraints = false
    underline.backgroundColor = underlineColor
    addSubview(underline)
    
    addButtons()
  }
  
  private func addButtons() {
    for view in stackView.arrangedSubviews {
      view.removeFromSuperview()
    }
    
    guard titles.count > 0 else { return }
    
    var configuration = UIButton.Configuration.plain()
    for (index, title) in titles.enumerated() {
      configuration.attributedTitle = AttributedString(title, attributes: titleAttributedContainer)
      let button = UIButton(configuration: configuration, primaryAction: nil)
      button.addTarget(self, action: #selector(onButtonTap(sender:)), for: .touchUpInside)
      button.tag = index
      stackView.addArrangedSubview(button)
    }
  }
  
  @objc private func onButtonTap(sender: UIButton) {
    let index = sender.tag
    currentIndex = index
    positionUnderline(toIndex: index)
    sendActions(for: .valueChanged)
  }
  
  private func positionUnderline(toIndex index: Int) {
    let width = getWidth(forIndex: index)
    let x = getX(forIndex: index)
    positionUnderline(toX: x, width: width)
  }
  
  private func positionUnderline(toX x: CGFloat, width: CGFloat) {
    underline.frame = CGRect(x: x, y: bounds.height-underlineHeight, width: width, height: underlineHeight)
  }
  
  private func getX(forIndex index: Int) -> CGFloat {
    return stackView.arrangedSubviews[index].frame.origin.x
  }
  
  private func getWidth(forIndex index: Int) -> CGFloat {
    return stackView.arrangedSubviews[index].frame.width
  }
  
  private func updateButtons() {
    for (index, view) in stackView.arrangedSubviews.enumerated() {
      guard let button = view as? UIButton else {
        continue
      }
      var buttonConfig = button.configuration
      buttonConfig?.attributedTitle = AttributedString(titles[index], attributes: titleAttributedContainer)
      button.configuration = buttonConfig
    }
  }
}
