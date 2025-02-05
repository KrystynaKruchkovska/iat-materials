/// Copyright (c) 2022-present Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import QuartzCore

@IBDesignable
class AnimatedMaskLabel: UIView {
  let gradientLayer: CAGradientLayer = {
    let gradientLayer = CAGradientLayer()
    // Configure the gradient here
    gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
    gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
    let colors = [
      UIColor.yellow.cgColor,
      UIColor.green.cgColor,
      UIColor.orange.cgColor,
      UIColor.cyan.cgColor,
      UIColor.red.cgColor,
      UIColor.yellow.cgColor
    ]
    gradientLayer.colors = colors

    let locations: [NSNumber] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.25]
    gradientLayer.locations = locations
    return gradientLayer
  }()

  let textAttributes: [NSAttributedString.Key: Any] = {
    let style = NSMutableParagraphStyle()
    style.alignment = .center
    return [
      .font: UIFont(
        name: "HelveticaNeue-Thin",
        size: 28.0)!,
      .paragraphStyle: style
    ]
  }()


  @IBInspectable var text: String = "" {
    didSet {
      setNeedsDisplay()
      let textAttributes: [NSAttributedString.Key: Any] = {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        return [
          .font: UIFont(
            name: "HelveticaNeue-Thin",
            size: 28.0)!,
          .paragraphStyle: style
        ]
      }()

      let image = UIGraphicsImageRenderer(size: bounds.size)
        .image { _ in
          text.draw(in: bounds, withAttributes: textAttributes)
      }

      let maskLayer = CALayer()
      maskLayer.backgroundColor = UIColor.clear.cgColor
      //mask will show up in the center of the gradient. This is necessary as your “stretched” gradient is currently three times as wide as the visible view.
      maskLayer.frame = bounds.offsetBy(dx: bounds.size.width, dy: 0)
      maskLayer.contents = image.cgImage
      gradientLayer.mask = maskLayer
    }
  }

  override func layoutSubviews() {
    layer.borderColor = UIColor.green.cgColor
    gradientLayer.frame = CGRect(
      x: -bounds.size.width,
      y: bounds.origin.y,
      width: 3 * bounds.size.width,
      height: bounds.size.height)
  }

  override func didMoveToWindow() {
    super.didMoveToWindow()
    layer.addSublayer(gradientLayer)
    addAnimation()
  }

  func addAnimation() {
    let gradientAnimation = CABasicAnimation(keyPath: "locations")
    gradientAnimation.fromValue = [0.0, 0.0, 0.0, 0.0, 0.0, 0.25]
    gradientAnimation.toValue = [0.65, 0.8, 0.85, 0.9, 0.95, 1.0]
    gradientAnimation.duration = 3.0
    gradientAnimation.repeatCount = Float.infinity

    gradientLayer.add(gradientAnimation, forKey: nil)
  }
}
