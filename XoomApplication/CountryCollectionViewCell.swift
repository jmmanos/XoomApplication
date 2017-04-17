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
    @IBOutlet public weak var label: UILabel!
    @IBInspectable var cornerRadius: CGFloat = 4 {
        didSet {
            contentView.layer.cornerRadius = cornerRadius
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = nil
        contentView.clipsToBounds = true
        
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
    }
    
    public func setCountry( _ country: Country) {
        label?.text = country.isoCode.rawValue
    }
}
