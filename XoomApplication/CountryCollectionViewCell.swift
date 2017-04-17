//
//  CountryCollectionViewCell.swift
//  XoomApplication
//
//  Created by John Manos on 4/17/17.
//  Copyright © 2017 John Manos. All rights reserved.
//

import UIKit

/// Cell to display Country properties
@IBDesignable
public final class CountryCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var gradientView: GradientView!
    @IBInspectable var cornerRadius: CGFloat = 4 {
        didSet {
            contentView.layer.cornerRadius = cornerRadius
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = nil
        contentView.clipsToBounds = true
        
        layer.shadowColor = UIColor(white: 0.1, alpha: 0.9).cgColor
        layer.shadowRadius = 3
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.4
        layer.shadowPath = UIBezierPath().cgPath
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        CATransaction.setDisableActions(true)
        CATransaction.begin()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        CATransaction.commit()
    }
    
    public func setCountry( _ country: Country) {
        label?.text = country.isoCode.rawValue
        gradientView?.properties = country.gradientProperties
    }
}
