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
    /// displays current country isoCode
    @IBOutlet private weak var label: UILabel!
    
    /// display colors of the country
    @IBOutlet private weak var gradientView: GradientView!
    
    /// rounded corners are nice
    @IBInspectable var cornerRadius: CGFloat = 4 {
        didSet {
            contentView.layer.cornerRadius = cornerRadius
        }
    }
    
    /// Cells are all in Interface builder so awake is acceptable place to perform some setup tasks
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = nil
        contentView.clipsToBounds = true
        
        // Add shadow to layer
        layer.shadowColor = UIColor(white: 0.1, alpha: 0.9).cgColor
        layer.shadowRadius = 3
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.4
        layer.shadowPath = UIBezierPath().cgPath
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // set shadowPath for performance
        // disable actions for implicit animation
        CATransaction.setDisableActions(true)
        CATransaction.begin()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        CATransaction.commit()
    }
    
    /// method to configure current country, internalized to separate model from too much work
    public func setCountry( _ country: Country) {
        label?.text = country.isoCode.rawValue
        gradientView?.properties = country.gradientProperties
    }
}
