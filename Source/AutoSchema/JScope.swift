//
//  JScope.swift
//  Pods
//
//  Created by Andrey Belonogov on 11/24/15.
//
//

import Foundation

@objc public class JScope : NSObject {
    
    public var scopeDictionary:[String:AnyObject]?
    public var schema:JSchema?
    public var form:JForm?
    public var model:[String:AnyObject]?
    
    public lazy var dateTimeFormatter:DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        //dateFormatter.locale = .currentLocale()
        //dateFormatter.locale = .currentLocale
        return dateFormatter;
    }()
    
    public init(schema:JSchema, form:JForm, model:[String:AnyObject]) {
        self.schema = schema;
        self.form = form;
        self.model = model;
    }
    
    public init(schemaDictionary:[String:AnyObject]?, formArray:[AnyObject]?, modelDictionary:[String:AnyObject]?) {
        if let schemaDict = schemaDictionary {
            self.schema = JSchema(dictionary: schemaDict);
        }
        if let formArray = formArray {
            self.form = JForm(array: formArray);
        }
        if let modelDictionary = modelDictionary {
            self.model = modelDictionary;
        }
    }
    
    public convenience init?(scopeDictionary ascopeDictionary:[String:AnyObject]) throws {
        let expandedScopeDictionary = try ReferenceExpander(rootDictionary:ascopeDictionary).expand()
        
        var vformArray:[AnyObject]?;
        var vmodelDict:[String: AnyObject]?;
        var vschemaDict:[String: AnyObject]?;
        
        if let formArray = expandedScopeDictionary["form"] as! [AnyObject]? {
            vformArray = formArray;
        }
        
        if let modelDict = expandedScopeDictionary["model"] as! [String: AnyObject]? {
            vmodelDict = modelDict;
        }
        
        if let schemaDict = expandedScopeDictionary["schema"] as! [String: AnyObject]? {
            vschemaDict = schemaDict;
        }

        self.init(schemaDictionary:vschemaDict, formArray:vformArray, modelDictionary:vmodelDict);
        scopeDictionary = expandedScopeDictionary;
   }
    
  
    
    /*public convenience init(dictionary: [String: AnyObject]) throws {
        self.init(schema:JSchema(dictionary: dictionary));
    }
    */
}
