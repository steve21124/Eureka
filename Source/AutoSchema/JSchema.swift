//
//  JsonSchema.swift
//  Pods
//
//  Created by Andrey Belonogov on 11/23/15.
//
//

import Foundation

public enum Type :Int{
    case Number
    case String
    case Bool
    case Array
    case Dictionary
    case Null
    case Unknown
}


public class JSchema {
    public var dictionary:[String:AnyObject];

    public var title:String? {
        get {
            return dictionary[Property.Title] as? String;
        }
    }
   
    public var description:String? {
        get {
            return dictionary[Property.Description] as? String;
        }
    }

    public var type:String?{
        get {
            return dictionary[Property.TypeKey] as? String;
        }
    }
    
    public var enumStringArray:[String]?{
        get {
            return dictionary[Property.Enum] as? [String];
        }
    }
    
    public var enumIntArray:[Int]?{
        get {
            return dictionary[Property.Enum] as? [Int];
        }
    }
    
    public var enumFloatArray:[Float]?{
        get {
            return dictionary[Property.Enum] as? [Float];
        }
    }

    public var requiredKeys:[String]?{
        get {
            return dictionary[Property.Required] as? [String];
        }
    }
    
    var _properties:[String:JSchema]?;
    public var properties:[String:JSchema]? {
        get {
            if let _properties = _properties {
                return _properties;
            }
            else {
                if let propertiesDictionary = dictionary[Property.Properties] as? [String:AnyObject] {
                    _properties = JSchema.createSchemaDictionary(dictionary: propertiesDictionary)
                }
                else {
                    _properties = [String:JSchema]();
                }
                return _properties;
            }
        }
    }

    required public init() {
        dictionary = [String:AnyObject]();
    }
    
    required public init(dictionary aDictionary:[String:AnyObject]) {
        dictionary = aDictionary;
    }

    public subscript(key: String) -> AnyObject? {
        get {
            return dictionary[key]
        }
        set(newValue) {
            dictionary[key] = newValue;
        }
    }
    
    static func createSchemaDictionary(dictionary:[String:AnyObject]) -> [String:JSchema]{
        var schemaDictionary = [String:JSchema]();
        for (key,obj) in dictionary {
            if let dictionary = obj as? [String:AnyObject] {
                schemaDictionary[key] = JSchema(dictionary: dictionary);
            }
        }
        return schemaDictionary;
    }
}



