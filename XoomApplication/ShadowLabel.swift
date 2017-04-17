//
//  ShadowLabel.swift
//  Xoom
//
//  Created by John Manos on 4/17/17.
//  Copyright © 2017 John Manos. All rights reserved.
//

import UIKit

@IBDesignable
public class ShadowLabel: UILabel {
    @IBInspectable
    public var layerShadowColor: UIColor? = .black {
        didSet {
            layer.shadowColor = layerShadowColor?.cgColor
        }
    }
    @IBInspectable
    public var layerShadowOffset: CGSize = .zero {
        didSet {
            layer.shadowOffset = layerShadowOffset
        }
    }
    @IBInspectable
    public var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    @IBInspectable
    public var shadowOpacity: Float = 0 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let rect = bounds
        let shadowRect = rect.insetBy(dx: rect.width/12, dy: rect.height/8)
        
        CATransaction.setDisableActions(true)
        CATransaction.begin()
        layer.shadowPath = UIBezierPath(roundedRect: shadowRect, cornerRadius: shadowRect.height/2).cgPath
        CATransaction.commit()
    }
}
