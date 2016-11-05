//
//  JForm.swift
//  Pods
//
//  Created by Andrey Belonogov on 11/24/15.
//
//

import Foundation

public class JForm {
    
    public var items:[JFormItem];
    
    required public init() {
        items = [JFormItem]();
    }
    
    required public init(array aArray:[AnyObject]) {
        items = [JFormItem]();
        for obj in aArray {
            if let formItem = JFormItem(object: obj) {
                items.append(formItem);
            }
        }
    }
}

public class JFormItem {
    public var key:String?;
    public var dictionary:[String:AnyObject]?;

    internal var placeholder:String? {
        return self["placeholder"] as! String?;
    }
    
    internal var type:String? {
        return self["type"] as! String?;
    }
    
    required public init(key keyA: String) {
        key = keyA
    }
    
    required public init?(object: AnyObject) {
        if let lKey = object as? String {
            key = lKey;
        }
        else if let dict = object as? [String:AnyObject] {
            if let lKey = dict["key"] as? String {
                key = lKey;
            }

            dictionary = [String:AnyObject]()
            for (k,v) in dict {
                if let array = v as? [AnyObject] {
                    dictionary![k] = JForm(array:array);
                }
                else if let dict = v as? [String:AnyObject] {
                    dictionary![k] = JFormItem(object: dict as AnyObject);
                }
                else {
                    dictionary![k] = v;
                }
            }
        }
        else {
            key = "compiler workaround:)";
            return nil;
        }
    }
    
    public subscript(key: String) -> AnyObject? {
        get {
            if let dictionary = dictionary {
                return dictionary[key]
            }
            else {
                return nil;
            }
        }
        set(newValue) {
            if var dictionary = dictionary {
                dictionary[key] = newValue;
            }
            else {
                dictionary = [String:AnyObject]()
                dictionary![key] = newValue;
            }
        }
    }
    
    public func isAll() -> Bool {
        return key == FormProperties.FormAllKey
    }
}
