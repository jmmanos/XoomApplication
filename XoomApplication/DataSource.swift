//
//  DataSource.swift
//  XoomApplication
//
//  Created by John Manos on 4/17/17.
//  Copyright © 2017 John Manos. All rights reserved.
//

/// Simple data source that works well with collectionViews
public protocol DataSource {
    associatedtype Element
    
    var count: Int { get }
    func index(of element: Element) -> Int?
    subscript(i: Int) -> Element? { get }
}
