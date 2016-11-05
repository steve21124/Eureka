//
//  ResourceFormViewController.swift
//  Example
//
//  Created by Andrey Belonogov on 11/19/15.
//  Copyright © 2015 Andrey Belonogov. All rights reserved.
//

import Foundation

public class ResourceFormViewController: JSchemaFormViewController {

    public init(scopeName: String)  {
        super.init(nibName: nil, bundle: nil);

        let scopeDict:[String: AnyObject] = try! JsonHelper.readDictionary(bundleFileName: scopeName)!;
        if let vscope = try? JScope(scopeDictionary: scopeDict) {
            scope = vscope;
        }
    }
 
    public init(schemaName: String, formName: String?, modelName: String?)  {
        super.init(nibName: nil, bundle: nil);
        
        var _schemaDict:[String: AnyObject];
        var _formArray:[AnyObject]?;
        var _modelDict:[String: AnyObject]?;
        
        _schemaDict = try! JsonHelper.readDictionary(bundleFileName: schemaName)!;
        if let formName = formName {
            _formArray = JsonHelper.readArray(bundleFileName: formName)!
        }
        if let modelName = modelName {
            _modelDict = try! JsonHelper.readDictionary(bundleFileName: modelName)!
        }
        scope = JScope(schemaDictionary: _schemaDict, formArray: _formArray, modelDictionary: _modelDict)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    func convertStringToDictionary(_ text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    
      
    func readFile(_ bundleFileName:String) -> String?
    {
        let path = Bundle.main.path(forResource: "bundleFileName", ofType: "json")
        do {
            let text = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
            return text
        } catch let error as NSError {
            print("error \(error) loading from url \(path)")
            return nil
        }
        
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
      
        let submitButton = UIBarButtonItem(barButtonSystemItem: .done, target:self, action: #selector(submitAction))
        self.navigationItem.rightBarButtonItems = [submitButton];
    }
    
    func multipleSelectorDone(_ item:UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    func submitAction() {
        let lvalues = result()?.values
        print("\(lvalues)")
    }
    
}
