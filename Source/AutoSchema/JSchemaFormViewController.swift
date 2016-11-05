//
//  SRJsonSchema.swift
//  StudioRel
//
//  Created by Andrey Belonogov on 12/23/15.
//  Copyright © 2015 studiorel. All rights reserved.
//

import Foundation

public class JSchemaFormViewController: FormViewController {
    
    private var _scope:JScope?;
    public var scope:JScope? {
        get {
            return _scope;
        }
        set {
            _scope = newValue;
        }
    }
    public var displayDateFormatter:DateFormatter?;
    public var displayDateTimeFormatter:DateFormatter?;
    public var modelDateTimeFormatter:DateFormatter?;
    
    var _builtForm:BuiltForm?;
    
    public convenience init() {
        self.init(nibName: nil, bundle: nil);
    }
  
    /*
    public convenience init(scopeDictionary:[String:AnyObject]) {
        self.init(nibName: nil, bundle: nil);
        load(scopeDictionary);
    }
    
    
    public func load(scopeDictionary:[String:AnyObject]) {
        if let scope = try? JScope(scopeDictionary: scopeDictionary) {
            self.scope = scope
        }
    }
    */
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public func reloadScope() {
        guard _scope != nil else {
            return;
        }
        
        do {
            let builder = FormBuilder(scope: scope!)
            builder.displayDateFormatter = self.displayDateFormatter;
            builder.displayDateTimeFormatter = self.displayDateTimeFormatter;
            _builtForm = try builder.createForm();
            form = _builtForm!.form;
        }
        catch FormBuilderError2.Missed(let message) {
            form = Form() +++
                Section(header: "Error", footer: "\(message)")
        }
        catch let error  {
            form = Form() +++
                Section(header: "Error", footer: "\(error)")
        }
    }

    func setUIDefaults() {
        URLRow.defaultCellUpdate = { cell, row in cell.textField.textColor = .blueColor() }
        LabelRow.defaultCellUpdate = { cell, row in cell.detailTextLabel?.textColor = .orangeColor()  }
        CheckRow.defaultCellSetup = { cell, row in cell.tintColor = .orangeColor() }
        DateRow.defaultRowInitializer = { row in row.minimumDate = NSDate() as Date }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        if (_builtForm == nil && _scope != nil) {
            reloadScope();
        }
        
        setUIDefaults();
    }
    
    public func result(includeHidden  : Bool = false) -> FormResult? {
        guard let builtForm = _builtForm else {
            return nil;
        }
        
        return builtForm.result(scope: _scope!);
    }
}
