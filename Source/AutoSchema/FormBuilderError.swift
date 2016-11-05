//
//  ErrorEnum.swift
//  JSchemaFormExample
//
//  Created by Andrey Belonogov on 12/26/15.
//  Copyright © 2015 Andrey Belonogov. All rights reserved.
//

import Foundation

public enum FormBuilderError2 : Error {
    //case NoPropertiesInRootSchema
    //case WrongJsonReferencePoint
    case Missed(String)
    
    func userInfo() -> Dictionary<String,String>? {
        var userInfo:Dictionary<String,String>?
        if let errorString = errorDescription() {
            userInfo = [NSLocalizedDescriptionKey: errorString]
        }
        return userInfo
    }
    
    func errorDescription() -> String? {
        var errorString:String?
        switch self {
            case .Missed(let message):
            errorString = message
        }
        return errorString
    }

}
