//
//  ShadowLabel.swift
//  Xoom
//
//  Created by John Manos on 4/17/17.
//  Copyright © 2017 John Manos. All rights reserved.
//

import UIKit

/// Label subclass to add shadow functionality and design
@IBDesignable
public final class ShadowLabel: UILabel {
    /// main background shadow color
    @IBInspectable
    public var layerShadowColor: UIColor? = .black {
        didSet {
            layer.shadowColor = layerShadowColor?.cgColor
        }
    }
    
    /// offset from center
    @IBInspectable
    public var layerShadowOffset: CGSize = .zero {
        didSet {
            layer.shadowOffset = layerShadowOffset
        }
    }
    
    /// radius of the shadow
    @IBInspectable
    public var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    /// opacity of the shadow
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
        
        // set shadowPath for performance
        // disable actions for implicit animation
        CATransaction.setDisableActions(true)
        CATransaction.begin()
        layer.shadowPath = UIBezierPath(roundedRect: shadowRect, cornerRadius: shadowRect.height/2).cgPath
        CATransaction.commit()
    }
}
