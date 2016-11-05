//
//  FormBuilder.swift
//  Pods
//
//  Created by Andrey Belonogov on 11/19/15.
//
//

import Foundation

public class BuiltForm {
    public var form:Form;
    public var scope:JScope;
    public var transformDictionary:[String:Dictionary<String,AnyObject>];

    public init(scope ascope:JScope,form aform:Form,transformDictionary atransformDictionary:[String:Dictionary<String,AnyObject>]) {
        scope = ascope;
        form = aform;
        transformDictionary = atransformDictionary;
    }
    
    public func setValues(values:[String:AnyObject]) {
        
        
        //var anyValues = [String:Any?]();
        for (key,value) in values {
            var transformedValue = value;
            if let transform = transformDictionary[key] as [String:AnyObject]? {
                for (tkey, tvalue) in transform {
                    if tvalue.isEqual(value) {
                        transformedValue = tkey as AnyObject;
                        break;
                    }
                }
            }
            
            if let row = form.rowBy(tag: key) as BaseRow? {
                if row.baseValue is NSDate {
                    print("key=\(key) value=\(transformedValue)");
                    if let stringValue = transformedValue as? String {
                        let dateFormatter = scope.dateTimeFormatter;
                        let date = dateFormatter.date(from: stringValue);
                        row.baseValue = date
                    } else {
                        row.baseValue = transformedValue
                    }
                }
                else {
                    row.baseValue = transformedValue
                }
            }
            
        }
        
        
    }

    public func values(includeHidden: Bool = false) -> [String: AnyObject] {
        let values = form.values()
        var result = [String: AnyObject]()
        for (key,value) in values {
            if let value = value as? String,
               let transform = transformDictionary[key] as [String:AnyObject]? {
                if let newValue = transform[value] {
                    result[key] = newValue;
                }
                else {
                    result[key] = value as AnyObject?
                }
            }
            else {
                result[key] = value as? AnyObject
            }
        }
        return result;
    }
    
    public func result(scope:JScope, includeHidden: Bool = false) -> FormResult {
       let lvalues = values(includeHidden: includeHidden)
       let result = FormResult(values: lvalues)

        //simple required validation
        if let requiredKeys = scope.schema?.requiredKeys, requiredKeys.count>0 {
            for key in requiredKeys {
                if lvalues[key] == nil {
                    result.validationErrors.append(ValidationError2(fieldKey: key, errorType: ValidationErrorType.RequiredField))
                }
            }
        }
        
        return result;
    }
}

public class FormBuilder {
    public var scope:JScope;
    public var displayDateFormatter:DateFormatter?;
    public var displayDateTimeFormatter:DateFormatter?;

    var _transformDictionary = [String:Dictionary<String,AnyObject>]()

    public init(scope aScope:JScope) {
        scope = aScope;
    }
    
    public func createForm() throws -> BuiltForm {
        
        let rootSchema = scope.schema!;
        let rootForm:JForm? = scope.form;
        guard let rootSchemaProperties = rootSchema.properties else {
            throw FormBuilderError2.Missed("Schema misses properties tag");
        }
        
        var form = Form();
        let section = Section();
        form +++ section
        
        let fieldList = try Field.fieldList(properties: rootSchemaProperties, formItems: rootForm?.items, requiredItems: rootSchema.requiredKeys)
        for field in fieldList {
            if let row = row(field: field) {
                section <<< row;
            }
        }
        
        let builtForm = BuiltForm(scope: scope,form: form, transformDictionary: _transformDictionary);
        
        if let model = scope.model {
            builtForm.setValues(values: model);
        }
        
        return builtForm;
    }
    
    
    
    internal func row(field: Field) -> BaseRow? {
        let fieldType = field.formType;
        var row:BaseRow?;
        //1.check type in form has first priorite
        switch(fieldType) {
            
        case FormType.Textarea:
            row = TextAreaRow() { $0.placeholder = field.placeholder }
            
        case FormType.Checkboxes:
            row = SwitchRow()
            
        default:break;
            
        }
        
 
        //3. check type in schema and then format
        if let _ = row {
        }
        else {
            if let type = field.schema.type {
                switch(type) {
                case SchemaType.Integer:
                    var intRow:RowOf<Int>
                    if let enumArray = field.schema.enumIntArray as [Int]? {
                        intRow = PushRow<Int>() {
                            $0.options = enumArray
                        }
                    }
                    else {
                        intRow = IntRow() {
                            $0.placeholder = field.placeholder
                        }
                    }
                    if let defaultValue = field.defaultInt {
                        intRow.value = defaultValue
                    }
                    row = intRow;
                    
                case SchemaType.Number:
                    if let enumArray = field.schema.enumFloatArray as [Float]? {
                        row = PushRow<Float>() {
                            $0.options = enumArray
                            if let defaultValue = field.defaultFloat {
                                $0.value = defaultValue
                            }
                        }
                    }
                    else {
                        row = DecimalRow() {
                            $0.placeholder = field.placeholder;
                            if let defaultValue = field.defaultDouble {
                                $0.value = defaultValue
                            }
                        }
                }

                default: //consider as string
                    var options:[String]?;
                    if let titleMap = field.titleMap {
                        options = [String]();
                        var transform = [String:AnyObject]();
                        for (value, label) in titleMap {
                            options!.append(label);
                            transform[label] = value as AnyObject?;
                        }
                        _transformDictionary[field.key] = transform;
                    }
                    else if let enumArray = field.schema.enumStringArray as [String]? {
                        options = enumArray
                    }
                        
                    if let options = options {
                        let stringRow = PushRow<String>() {
                            $0.options = options
                        }
                        if let defaultValue = field.defaultString {
                            stringRow.value = defaultValue
                        }
                        row = stringRow
                    }
                    else if let format = field.format {
                        switch (format) {
                        case Format.Date:
                            row = DateInlineRow() {
                                if let formatter = self.displayDateFormatter {
                                    $0.dateFormatter = formatter;
                                }
                                $0.value = NSDate() as Date
                            }
                        case Format.DateTime:
                            row = DateTimeInlineRow() {
                                if let formatter = self.displayDateTimeFormatter {
                                    $0.dateFormatter = formatter;
                                }
                                $0.value = NSDate() as Date
                            }
                        case Format.Time:
                            row = TimeInlineRow() {
                                $0.value = NSDate() as Date
                            }
                        case Format.Countdown:
                            row = CountDownInlineRow() {
                                $0.value = NSDate() as Date
                            }
                        default:break;
                        }
                    }
                }
            }
        }
        
        //4. For unknown cases use simple Text Field
        if let _ = row {
        }
        else {
            row = TextRow() {
                $0.placeholder = field.placeholder
            }
        }
        
        if let row = row {
            row.tag = field.key;
            row.title = field.title;
        }
        return row;
    }
    

}

