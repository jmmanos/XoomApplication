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
public class CountryViewController: UIViewController {
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var receiveCurrencyCodeLabel: UILabel!
    @IBOutlet weak var sendFxRateLabel: UILabel!
    @IBOutlet weak var feesChangedDateLabel: UILabel!
    @IBOutlet weak var sceneView: SCNView!
    
    private var country: Country!
    private var hiddenLabels:  Bool = true
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let country = self.country else { return }
        
        title = country.isoCode.rawValue
        gradientView?.properties = country.gradientProperties
        
        receiveCurrencyCodeLabel?.alpha = 0
        sendFxRateLabel?.alpha = 0
        feesChangedDateLabel?.alpha = 0
        
        sceneView.isPlaying = false
        
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
        
        if sceneView.isPlaying && hide {
            sceneView.isPlaying = false
        }
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [UIViewAnimationOptions.beginFromCurrentState], animations: { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.receiveCurrencyCodeLabel?.alpha = alpha
            weakSelf.sendFxRateLabel?.alpha = alpha
            weakSelf.feesChangedDateLabel?.alpha = alpha
            }, completion: { [weak self] completed in
                if completed, let weakSelf = self {
                    weakSelf.hiddenLabels = hide
                    weakSelf.sceneView.isPlaying = hide
                }
        })
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !hiddenLabels {
            showLabels(hide: true, animated: false)
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if country.isLoaded && hiddenLabels {
            showLabels()
        }
    }
    
    private static let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .none
        return f
    }()
    
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
    
    public static func create(with country: Country) -> CountryViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "country") as! CountryViewController
        vc.country = country
        return vc
    }
}
