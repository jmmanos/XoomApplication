//
//  CountriesCollectionViewController.swift
//  XoomApplication
//
//  Created by John Manos on 4/17/17.
//  Copyright © 2017 John Manos. All rights reserved.
//

import UIKit

/// CollectionViewController to handle all possible countries
public final class CountriesCollectionViewController: UICollectionViewController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Perpetual dislike of nav scroll insets
        collectionView?.contentInset = UIEdgeInsets(top: 72, left: 10, bottom: 8, right: 10)
        
        // if last country is saved, push vc onto stack ASAP
        if let lastCountry = Country.last {
            let vc = CountryViewController.create(with: lastCountry)
            navigationController?.pushViewController(vc, animated: false)
        }
    }
}

/// UICollectionView DataSource and Delegate methods
extension CountriesCollectionViewController {
    public override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CountryDataSource.shared.count
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "countryCell", for: indexPath)
        
        // configure cell
        if let countryCell = cell as? CountryCollectionViewCell, let country = CountryDataSource.shared[indexPath.row] {
            countryCell.setCountry(country)
        }
        
        return cell
    }
    
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // ensure valid index and we have a nav to psuh vc onto
        guard let country = CountryDataSource.shared[indexPath.row], let nav = navigationController else { return }
        
        // push vc onto nav stack
        let vc = CountryViewController.create(with: country)
        nav.pushViewController(vc, animated: true)
        
        // save last country initially to store even if data doesnt load
        Country.last = country
    }
}

/// Layout method
extension CountriesCollectionViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width-30)/2
        let height = collectionView.bounds.height/3.5
        return CGSize(width: width, height: height)
    }
}
