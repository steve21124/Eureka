//
//  ReferenceExpander.swift
//  JSchemaFormExample
//
//  Created by Andrey Belonogov on 12/26/15.
//  Copyright © 2015 Andrey Belonogov. All rights reserved.
//

import Foundation

public class ReferenceExpander: NSObject {
    var rootDictionary:[String:AnyObject]
    
    public init(rootDictionary:[String:AnyObject]) {
        self.rootDictionary = rootDictionary
    }
    
    public func expand() throws -> [String:AnyObject] {
        if let expandedDict = try expandDictionary(dictionary: rootDictionary) as? [String:AnyObject] {
            return expandedDict
        }
        else {
             throw FormBuilderError2.Missed("Failed expand json with json queries")
        }
    }
    
    func expandDictionary(dictionary:[String:AnyObject]) throws -> AnyObject {
        var newDict = [String:AnyObject]()
        for (k,v) in dictionary {
            var newValue:AnyObject;
            if (k == "#ref") {
                guard v is String else {
                    throw FormBuilderError2.Missed("Reference must be string")
                }
                
                if let refValue = try find(reference: v as! String) {
                    return refValue
                }
                else {
                    throw FormBuilderError2.Missed("Can't find data for json reference '\(v)'")
                }
            }
            else {
                if let dict = v as? [String:AnyObject] {
                    newValue = try expandDictionary(dictionary: dict)
                }
                else if let array = v as? [AnyObject] {
                    newValue = try expandArray(array: array) as AnyObject
                }
                else {
                    newValue = v
                }
            }
            newDict[k] = newValue
        }
        return newDict as AnyObject
    }
    
    func expandArray(array:[AnyObject]) throws -> [AnyObject] {
        var newArray = [AnyObject]()
        for v in array {
            var newValue:AnyObject;
            if let dict = v as? [String:AnyObject] {
                newValue = try expandDictionary(dictionary: dict)
            }
            else if let array = v as? [AnyObject] {
                newValue = try expandArray(array: array) as AnyObject
            }
            else {
                newValue = v
            }
            newArray.append(newValue)
        }
        return newArray
    }
    
    func find(reference:String) throws -> AnyObject? {        
        let components = reference.components(separatedBy: "/")
        var currentPoint:AnyObject! = nil;
        for comp in components {
            if (comp == "#") {
                currentPoint = rootDictionary as AnyObject!
            } else {
                guard (currentPoint != nil) else {
                    throw FormBuilderError2.Missed("Wrong Format of json query '\(reference)'")
                }
                
                if let dict = currentPoint as! [String:AnyObject]? {
                    currentPoint = dict[comp]
                    if (currentPoint == nil) {
                        return nil;
                    }
                } else if let array = currentPoint as! [AnyObject]? {
                    if let index = Int(comp) {
                        currentPoint = array[index]
                    }
                    else {
                        throw FormBuilderError2.Missed("Wrong json reference '\(reference)' points on non existent structure")
                    }
                }
                else {
                    return nil;
                }
            }
        }
        return currentPoint;
    }
    
}
