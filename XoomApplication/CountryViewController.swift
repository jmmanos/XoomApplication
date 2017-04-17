//
//  CountryViewController.swift
//  XoomApplication
//
//  Created by John Manos on 4/17/17.
//  Copyright © 2017 John Manos. All rights reserved.
//

import UIKit
import SceneKit

/// Displays important country info
public final class CountryViewController: UIViewController {
    // UIOutlets 
    
    @IBOutlet private weak var gradientView: GradientView!
    @IBOutlet private weak var receiveCurrencyCodeLabel: UILabel!
    @IBOutlet private weak var sendFxRateLabel: UILabel!
    @IBOutlet private weak var feesChangedDateLabel: UILabel!
    @IBOutlet private weak var sceneView: SCNView!
    
    /// current country on display
    private var country: Country!
    
    /// flag to show/hide labels
    private var hiddenLabels:  Bool = true
    
    /// attempt to keep viewDidLoad light
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let country = self.country else { return }
        
        title = country.isoCode.rawValue
        gradientView?.properties = country.gradientProperties
        
        receiveCurrencyCodeLabel?.alpha = 0
        sendFxRateLabel?.alpha = 0
        feesChangedDateLabel?.alpha = 0
        
        // perform API call if not loaded
        if !country.isLoaded {
            country.load({ [weak self] (result:APIResult<Country.LoadableProperties, Error>) in
                guard let weakSelf = self else { return }
                switch result {
                case let .success(properties): weakSelf.configure(for: properties)
                case let .error(error):
                    weakSelf.sendFxRateLabel?.text = "Error:"
                    weakSelf.feesChangedDateLabel?.text = "\(error)"
                }
                
                if weakSelf.hiddenLabels {
                    weakSelf.showLabels(animated: true)
                }
            })
        } else {
            configure(for: country.properties)
        }
    }
    
    private func showLabels(hide: Bool = false, animated: Bool = false) {
        let duration: Double = animated ? 1.2 : 0.2
        let alpha: CGFloat = hide ? 0.0 : 1.0
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [UIViewAnimationOptions.beginFromCurrentState], animations: { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.receiveCurrencyCodeLabel?.alpha = alpha
            weakSelf.sendFxRateLabel?.alpha = alpha
            weakSelf.feesChangedDateLabel?.alpha = alpha
            }, completion: { [weak self] completed in
                if completed, let weakSelf = self {
                    weakSelf.hiddenLabels = hide
                }
        })
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !hiddenLabels {
            showLabels(hide: true, animated: false)
        }
        
        if !(sceneView.scene?.isPaused ?? true) {
            sceneView.scene?.isPaused = true
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if country.isLoaded && hiddenLabels {
            showLabels()
        }
        
        if let scene = sceneView.scene, scene.isPaused {
            scene.isPaused = false
        }
    }
    
    /// internal date fromatter to turn date into string
    private static let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .none
        return f
    }()
    
    /// configure UI elements for current properties
    private func configure(for properties: Country.LoadableProperties) {
        guard let currCode = properties.receiveCurrencyCode,
            let rate = properties.sendFxRate,
            let date = properties.feesChanged else {
                return
        }
        receiveCurrencyCodeLabel?.text = "Rec. Currency Code: " + currCode
        sendFxRateLabel?.text = "Send Rate: \((rate * 1000).rounded()/1000.0)"
        feesChangedDateLabel?.text = "Changed: " + CountryViewController.formatter.string(from: date)
        
        Country.last = self.country
        
        if sceneView?.scene == nil {
            let scene = CurrencyScene(rate: rate)
            sceneView.scene = scene
            sceneView.pointOfView = scene.cameraNode
            //sceneView.delegate = scene
        }
    }
    
    /// creator pattern for dependancy injection of country. Shouldnt be created without a country.
    public static func create(with country: Country) -> CountryViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "country") as! CountryViewController
        vc.country = country
        return vc
    }
}
