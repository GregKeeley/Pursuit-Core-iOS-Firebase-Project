//
//  UIView+Extensions.swift
//  Insta-Clone
//
//  Created by Gregory Keeley on 3/10/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
  @IBInspectable var cornerRadius: CGFloat = 0
  
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.masksToBounds = true
    layer.cornerRadius = cornerRadius
    let gradientLayer = CAGradientLayer()
    let color1: UIColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
    let color2: UIColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
    let colors = [color1.cgColor, color2.cgColor]
    gradientLayer.frame = bounds
    gradientLayer.colors = colors
    layer.addSublayer(gradientLayer)
  }
}
