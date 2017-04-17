//
//  GradientView.swift
//  XoomApplication
//
//  Created by John Manos on 4/17/17.
//  Copyright © 2017 John Manos. All rights reserved.
//

import UIKit

/// Basic uiview subclass for some visual effects
public final class GradientView: UIView {
    /// Struct to store visual properties of the gradient
    public struct VisualProperties {
        var colors: [UIColor]
        var startPoint: CGFloat
        var endPoint: CGFloat
    }
    
    /// Override for UIView layer setup
    public override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    /// the visual properties struct of the view
    public var properties = VisualProperties(colors: [], startPoint: 0, endPoint: 0) {
        didSet {
            gradientLayer.colors = properties.colors.map { $0.cgColor }
            gradientLayer.startPoint = CGPoint(x:properties.startPoint, y: 0)
            gradientLayer.endPoint = CGPoint(x:properties.endPoint, y: 1)
        }
    }
    
    private var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
}
