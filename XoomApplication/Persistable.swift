//
//  Persistable.swift
//  Xoom_private
//
//  Created by John Manos on 4/13/17.
//  Copyright © 2017 John Manos. All rights reserved.
//

public enum PersistableError: Error {
    case unknownError
}
public protocol Persistable {
    associatedtype PersistentObject
    
    func save() -> PersistentObject
    static func load(from object: PersistentObject) throws -> Self
}
