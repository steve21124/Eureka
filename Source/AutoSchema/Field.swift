//
//  FormField.swift
//  Pods
//
//  Created by Andrey Belonogov on 11/25/15.
//
//

import Foundation

internal class Field {
    var schema:JSchema;
    var formItem:JFormItem;
    var required:Bool;
    
    internal init(schema schemaA:JSchema, formItem formItemA:JFormItem) {
        schema = schemaA;
        formItem = formItemA;
        required = false;
    }
    
    internal var formType:String {
        get {
            if let type = formItem.type {
                return type
            }
            else {
                if let type = schema.type {
                    return Field.formType(schemaType: type);
                }
                else {
                    return Field.formType(schemaType: SchemaType.String);
                }
            }
        }
    }
    
    internal var placeholder:String? {
        return self["placeholder"] as! String?;
    }
   
    internal var format:String? {
        return self["format"] as! String?;
    }
    
    internal var defaultString:String? {
        return self["default"] as! String?;
    }
    
    internal var defaultInt:Int? {
        return self["default"] as! Int?;
    }
    
    internal var defaultFloat:Float? {
        return self["default"] as! Float?;
    }
    
    internal var defaultDouble:Double? {
        return self["default"] as! Double?;
    }
    
    internal var title:String? {
        if let title = self["title"] as! String? {
            return title;
        }
        else {
            //return key.capitalizedStringWith;
            return key.capitalized
        }
    }

    internal var titleMap:[(value:String,label:String)]? {
        guard let mapObj = self["titleMap"] as! JForm? else {
            return nil;
        }
        
        let titleArrayMap = mapObj.items;
        var titleMap = [(value:String,label:String)]()
        for dict in titleArrayMap {
            if let value = dict["value"] as! String? {
                if let label = dict["label"] as! String? {
                    titleMap.append((value:value,label:label));
                }
                else if let label = dict["text"] as! String? {
                    titleMap.append((value:value,label:label));
                }
                else if let label = dict["name"] as! String? {
                    titleMap.append((value:value,label:label));
                }
                else if let label = dict["title"] as! String? {
                    titleMap.append((value:value,label:label));
                }
            }
        }
        return titleMap;
        
        
    }
    
    internal var key:String {
        return formItem.key!;//field can't be created without a key anyway
    }

    internal subscript(key: String) -> AnyObject? {
        get {
            if let obj = formItem[key] {
                return obj;
            }
            else if let obj = schema[key] {
                return obj;
            }
            return nil;
        }
    }
    
    internal static func formType(schemaType:String) -> String {
        switch(schemaType) {
        case SchemaType.Boolean:
            return FormType.Checkboxes;
        default:
            return FormType.Text;
        }
    }


    internal static func fieldList(properties:[String:JSchema], formItems:[JFormItem]?, requiredItems:[String]?) throws -> [Field] {
        var fields = [Field]();
        if let formItems = formItems {
            for formItem in formItems {
                if formItem.isAll() {
                    appendAllFormItems(properties: properties, fields: &fields);
                }
                else {
                    if let key = formItem.key, let schema = properties[key] {
                        let field = Field(schema: schema, formItem: formItem);
                        fields.append(field);
                    }
                    else {
                        throw FormBuilderError2.Missed("Can't find field '\(formItem.key!)' in properties")
                    }
                }
            }
        } else {
            appendAllFormItems(properties: properties, fields: &fields);
        }
        
        //set required flags
        if let requiredItems = requiredItems, requiredItems.count > 0 {
            var fieldMap = [String:Field]();
            for field in fields {
                fieldMap[field.key] = field;
            }
            for requiredKey in requiredItems {
                if let found = fieldMap[requiredKey] {
                    found.required = true;
                }
                else {
                    throw FormBuilderError2.Missed("Can't find required field '\(requiredKey)'")
                }
            }
        }
        return fields;
    }
    
    static func appendAllFormItems(properties:[String:JSchema], fields:inout [Field]) {
        for (key,schema) in properties {
            let formItem = JFormItem(key:key);
            let field = Field(schema: schema, formItem: formItem);
            fields.append(field);
        }
    }
    
}
