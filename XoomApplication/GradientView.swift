//
//  GradientView.swift
//  XoomApplication
//
//  Created by John Manos on 4/17/17.
//  Copyright © 2017 John Manos. All rights reserved.
//

import UIKit

public final class GradientView: UIView {
    public struct VisualProperties {
        var colors: [UIColor]
        var startPoint: CGFloat
        var endPoint: CGFloat
    }
    public override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    public var properties = VisualProperties(colors: [], startPoint: 0, endPoint: 0) {
        didSet {
            gradientLayer.colors = properties.colors.map { $0.cgColor }
            gradientLayer.startPoint = CGPoint(x:properties.startPoint, y: 0)
            gradientLayer.endPoint = CGPoint(x:properties.endPoint, y: 1)
        }
    }
    
    public var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
}
