//
//  JSONHelper1.swift
//  Pods
//
//  Created by Andrey Belonogov on 11/23/15.
//
//

import Foundation

public class JsonHelper {
    
    public static func readDictionary(bundleFileName:String) throws -> [String:AnyObject]?
    {
        guard let path = Bundle.main.path(forResource: bundleFileName, ofType: "json") else {
            return nil
        }
        
        let data = NSData(contentsOfFile: path)
        let json = try JSONSerialization.jsonObject(with: data! as Data, options: .mutableContainers) as? [String:AnyObject]
        return json
    }
    
    /*public static func readOrderedDictionary(bundleFileName:String) -> [String:AnyObject]?
    {
        let path = NSBundle.mainBundle().pathForResource(bundleFileName, ofType: "json")
        do {
            let data = NSData(contentsOfFile: path!)
            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? [String:AnyObject]
            return json
        } catch let error as NSError {
            print("error \(error) loading from url \(path)")
            return nil
        }
    }
    */
    
    public static func readArray(bundleFileName:String) -> [AnyObject]?
    {
        let path = Bundle.main.path(forResource: bundleFileName, ofType: "json")
        do {
            let data = NSData(contentsOfFile: path!)
            let json = try JSONSerialization.jsonObject(with: data! as Data, options: .mutableContainers) as? [AnyObject]
            return json
        } catch let error as NSError {
            print("error \(error) loading from url \(path)")
            return nil
        }
    }

}
