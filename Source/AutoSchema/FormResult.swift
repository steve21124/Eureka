//
//  FormResult.swift
//  JSchemaFormExample
//
//  Created by Andrey Belonogov on 3/12/16.
//  Copyright © 2016 Andrey Belonogov. All rights reserved.
//

import Foundation

struct ValidationErrorType {
    static let RequiredField = "required";
    static let WrongFormat = "wrong format";
}

@objc public class FormResult : NSObject {
    public var values:[String: AnyObject]
    public var validationErrors:[ValidationError2]
    
    public init(values:[String: AnyObject]) {
        self.values = values;
        self.validationErrors = [];
    }
    
    public func isValid() -> Bool {
        return validationErrors.count>0;
    }
}

@objc public class ValidationError2 : NSObject {
    var fieldKey:String
    var errorType:String
    
    public init(fieldKey:String, errorType:String) {
        self.fieldKey = fieldKey;
        self.errorType = errorType;
    }
}
