//
//  Persistable.swift
//  Xoom_private
//
//  Created by John Manos on 4/13/17.
//  Copyright © 2017 John Manos. All rights reserved.
//

/// Error encountered when attempting to save/load object
public enum PersistableError: Error {
    case unknownError
}

/// Protocool to simplify saving/loading to permanent memory
public protocol Persistable {
    /// Object that is the converted/converting instance type
    associatedtype PersistentObject
    
    func save() -> PersistentObject
    static func load(from object: PersistentObject) throws -> Self
}
