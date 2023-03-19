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

// A delay function
func delay(_ seconds: Double, completion: @escaping () -> Void) {
  DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}

class ViewController: UIViewController {
  // MARK: IB outlets

  @IBOutlet var loginButton: UIButton!
  @IBOutlet var heading: UILabel!
  @IBOutlet var username: UITextField!
  @IBOutlet var password: UITextField!

  @IBOutlet var cloud1: UIImageView!
  @IBOutlet var cloud2: UIImageView!
  @IBOutlet var cloud3: UIImageView!
  @IBOutlet var cloud4: UIImageView!

  // MARK: further UI

  let spinner = UIActivityIndicatorView(style: .large)
  let status = UIImageView(image: UIImage(named: "banner"))
  let label = UILabel()
  let info = UILabel()
  let messages = ["Connecting ...", "Authorizing ...", "Sending credentials ...", "Failed"]

  var statusPosition = CGPoint.zero

  // MARK: view controller methods

  override func viewDidLoad() {
    super.viewDidLoad()
    username.delegate = self
    password.delegate = self

    // set up the UI
    loginButton.layer.cornerRadius = 8.0
    loginButton.layer.masksToBounds = true

    spinner.frame = CGRect(x: -20.0, y: 6.0, width: 20.0, height: 20.0)
    spinner.startAnimating()
    spinner.alpha = 0.0
    loginButton.addSubview(spinner)

    status.isHidden = true
    status.center = loginButton.center
    view.addSubview(status)

    label.frame = CGRect(x: 0.0, y: 0.0, width: status.frame.size.width, height: status.frame.size.height)
    label.font = UIFont(name: "HelveticaNeue", size: 18.0)
    label.textColor = UIColor(red: 0.89, green: 0.38, blue: 0.0, alpha: 1.0)
    label.textAlignment = .center
    status.addSubview(label)
    statusPosition = status.center

    info.frame = CGRect(x: 0.0, y: loginButton.center.y - 60.0, width: view.frame.size.width, height: 30)
    info.backgroundColor = .clear
    info.font = UIFont(name: "HelveticaNeue", size: 12.0)
    info.textAlignment = .center
    info.textColor = .white
    info.text = "Tap on a field and enter username and password"
    view.insertSubview(info, belowSubview: loginButton)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    let formGroup = CAAnimationGroup()
    formGroup.duration = 0.5
    formGroup.fillMode = .backwards

    let flyRight = CABasicAnimation(keyPath: "position.x")
    flyRight.fromValue = -view.bounds.size.width / 2
    flyRight.toValue = view.bounds.size.width / 2

    let fadeFieldIn = CABasicAnimation(keyPath: "opacity")
    fadeFieldIn.fromValue = 0.25
    fadeFieldIn.toValue = 1.0

    formGroup.animations = [flyRight, fadeFieldIn]
    heading.layer.add(formGroup, forKey: nil)

    formGroup.delegate = self
    formGroup.setValue("form", forKey: "name")
    formGroup.setValue(username.layer, forKey: "layer")
    formGroup.beginTime = CACurrentMediaTime() + 0.3
    username.layer.add(formGroup, forKey: nil)

    formGroup.setValue(password.layer, forKey: "layer")
    formGroup.beginTime = CACurrentMediaTime() + 0.4
    password.layer.add(formGroup, forKey: nil)

    let cloudOpacity = CABasicAnimation(keyPath: "opacity")
    cloudOpacity.fromValue = 0
    cloudOpacity.toValue = 1
    cloudOpacity.duration = 0.5
    cloudOpacity.fillMode = .backwards

    cloudOpacity.beginTime = CACurrentMediaTime() + 0.5
    cloud1.layer.add(cloudOpacity, forKey: nil)

    cloudOpacity.beginTime = CACurrentMediaTime() + 0.7
    cloud2.layer.add(cloudOpacity, forKey: nil)

    cloudOpacity.beginTime = CACurrentMediaTime() + 0.9
    cloud3.layer.add(cloudOpacity, forKey: nil)

    cloudOpacity.beginTime = CACurrentMediaTime() + 1.1
    cloud4.layer.add(cloudOpacity, forKey: nil)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    let groupAnimation = CAAnimationGroup()
    groupAnimation.beginTime = CACurrentMediaTime() + 0.5
    groupAnimation.duration = 0.5
    groupAnimation.fillMode = .backwards
    groupAnimation.timingFunction = CAMediaTimingFunction(
      name: .easeIn
    )

    let scaleDown = CABasicAnimation(keyPath: "transform.scale")
    scaleDown.fromValue = 3.5
    scaleDown.toValue = 1.0

    let rotate = CABasicAnimation(keyPath: "transform.rotation")
    rotate.fromValue = .pi / 4.0
    rotate.toValue = 0.0

    let fade = CABasicAnimation(keyPath: "opacity")
    fade.fromValue = 0.0
    fade.toValue = 1.0

    groupAnimation.animations = [scaleDown, rotate, fade]
    loginButton.layer.add(groupAnimation, forKey: nil)

    animateCloud(layer: cloud1.layer)
    animateCloud(layer: cloud2.layer)
    animateCloud(layer: cloud3.layer)
    animateCloud(layer: cloud4.layer)

    let flyLeft = CABasicAnimation(keyPath: "position.x")
    flyLeft.fromValue = info.layer.position.x +
      view.frame.size.width
    flyLeft.toValue = info.layer.position.x
    flyLeft.duration = 5.0
    flyLeft.repeatCount = 2.5
    flyLeft.autoreverses = true
    info.layer.speed = 2.0
    info.layer.add(flyLeft, forKey: "infoAppear")

    let fadeLabelIn = CABasicAnimation(keyPath: "opacity")
    fadeLabelIn.fromValue = 0.2
    fadeLabelIn.toValue = 1.0
    fadeLabelIn.duration = 4.5
    info.layer.add(fadeLabelIn, forKey: "fadein")
  }

  // MARK: further methods

  @IBAction func login() {
    view.endEditing(true)

    UIView.animate(
      withDuration: 1.5,
      delay: 0.0,
      usingSpringWithDamping: 0.2,
      initialSpringVelocity: 0.0,
      options: [],
      animations: {
        self.loginButton.bounds.size.width += 80.0
      },
      completion: { _ in
        self.showMessage(index: 0)
      }
    )

    UIView.animate(
      withDuration: 0.33,
      delay: 0.0,
      usingSpringWithDamping: 0.7,
      initialSpringVelocity: 0.0,
      options: [],
      animations: {
        self.loginButton.center.y += 60.0
        self.spinner.center = CGPoint(
          x: 40.0,
          y: self.loginButton.frame.size.height / 2
        )
        self.spinner.alpha = 1.0
      },
      completion: nil
    )
    tintBackgroundColor(layer: loginButton.layer, toColor: UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0))
    roundCorners(layer: loginButton.layer, toRadius: 25.0)
  }

  func showMessage(index: Int) {
    label.text = messages[index]

    UIView.transition(
      with: status,
      duration: 0.33,
      options: [.curveEaseOut, .transitionCurlDown],
      animations: {
        self.status.isHidden = false
      },
      completion: { _ in
        delay(2.0) {
          if index < self.messages.count - 1 {
            self.removeMessage(index: index)
          } else {
            self.resetForm()
          }
        }
      }
    )
  }

  func removeMessage(index: Int) {
    UIView.animate(
      withDuration: 0.33,
      delay: 0.0,
      options: [],
      animations: {
        self.status.center.x += self.view.frame.size.width
      },
      completion: { _ in
        self.status.isHidden = true
        self.status.center = self.statusPosition

        self.showMessage(index: index + 1)
      }
    )
  }

  func resetForm() {
    UIView.transition(
      with: status,
      duration: 0.2,
      options: [.curveEaseOut, .transitionCurlUp]
    ) {
      self.status.isHidden = true
      self.status.center = self.statusPosition

      UIView.animate(withDuration: 0.2) { [self] in
        self.spinner.center = CGPoint(x: -20.0, y: 16.0)
        self.spinner.alpha = 0
        self.loginButton.bounds.size.width -= 80.0
        self.loginButton.center.y -= 60.0
      } completion: { _ in
        let tintColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1.0)
        self.tintBackgroundColor(layer: self.loginButton.layer, toColor: tintColor)
        self.roundCorners(layer: self.loginButton.layer, toRadius: 10.0)
      }
    }
  }

  func animateCloud(cloud: UIImageView) {
    let cloudSpeed = 60.0 / view.frame.size.width
    let duration = (view.frame.size.width - cloud.frame.origin.x) * cloudSpeed

    UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: [.curveLinear]) {
      cloud.frame.origin.x = self.view.frame.size.width
    } completion: { _ in
      cloud.frame.origin.x = -cloud.frame.size.width
      self.animateCloud(cloud: cloud)
    }
  }

  func animateCloud(layer: CALayer) {
    // 1
    let cloudSpeed = 60.0 / Double(view.layer.frame.size.width)
    let duration: TimeInterval = Double(
      view.layer.frame.size.width - layer.frame.origin.x
    )
      * cloudSpeed

    // 2
    let cloudMove = CABasicAnimation(keyPath: "position.x")
    cloudMove.duration = duration
    cloudMove.toValue = self.view.bounds.width +
      layer.bounds.width / 2
    cloudMove.delegate = self
    cloudMove.setValue("cloud", forKey: "name")
    cloudMove.setValue(layer, forKey: "layer")
    layer.add(cloudMove, forKey: nil)
  }

  func tintBackgroundColor(layer: CALayer, toColor: UIColor) {
    let animateBackground = CASpringAnimation(keyPath: "backgroundColor")
    animateBackground.fromValue = layer.backgroundColor
    animateBackground.toValue = toColor.cgColor
    animateBackground.duration = animateBackground.settlingDuration

    layer.add(animateBackground, forKey: nil)
    layer.backgroundColor = toColor.cgColor
  }

  func roundCorners(layer: CALayer, toRadius: CGFloat) {
    let roundCorners = CASpringAnimation(keyPath: "roundCorners")
    roundCorners.fromValue = layer.cornerRadius
    roundCorners.toValue = toRadius
    roundCorners.duration = roundCorners.settlingDuration

    layer.add(roundCorners, forKey: nil)
    layer.cornerRadius = toRadius
  }

  // MARK: UITextFieldDelegate

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let nextField = (textField === username) ? password : username
    nextField?.becomeFirstResponder()
    return true
  }
}

extension ViewController: CAAnimationDelegate {
  func animationDidStop(
    _ anim: CAAnimation,
    finished _: Bool
  ) {
    guard let name = anim.value(forKey: "name") as? String else {
      return
    }

    if name == "form" {
      let layer = anim.value(forKey: "layer") as? CALayer
      anim.setValue(nil, forKey: "layer")

      let pulse = CASpringAnimation(keyPath: "transform.scale")
      pulse.damping = 7.5
      pulse.fromValue = 1.25
      pulse.toValue = 1.0
      pulse.duration = pulse.settlingDuration
      layer?.add(pulse, forKey: nil)
    }

    if name == "cloud" {
      guard let layer = anim.value(forKey: "layer") as? CALayer else {
        return
      }
      anim.setValue(nil, forKey: "layer")

      layer.position.x = -layer.bounds.width / 2

      delay(0.5) {
        self.animateCloud(layer: layer)
      }
    }
  }
}

extension ViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_: UITextField) {
    guard let runningAnimations = info.layer.animationKeys() else {
      return
    }
    info.layer.removeAnimation(forKey: "infoAppear")
    print(runningAnimations)
  }
  func textFieldDidEndEditing(_ textField: UITextField) {
    guard let text = textField.text else { return }
        
      if text.count < 5 {
        let jump = CASpringAnimation(keyPath: "position.y")
        jump.initialVelocity = 100
        jump.mass = 10
        jump.stiffness = 1500
        jump.damping = 50
        jump.fromValue = textField.layer.position.y + 1.0
        jump.toValue = textField.layer.position.y
        jump.duration = jump.settlingDuration
        textField.layer.add(jump, forKey: nil)
      } else {
        textField.layer.borderWidth = 3
        textField.layer.borderColor = UIColor.clear.cgColor
        
        let flash = CASpringAnimation(keyPath: "borderColor")
        flash.damping = 30.0
        flash.mass = 20
        flash.stiffness = 200
        flash.fromValue = UIColor(red: 1.0, green: 0.27, blue: 0.0, alpha: 1.0).cgColor
        flash.toValue = UIColor.white.cgColor
        flash.duration = flash.settlingDuration
        textField.layer.add(flash, forKey: nil)
      }
  }
}
