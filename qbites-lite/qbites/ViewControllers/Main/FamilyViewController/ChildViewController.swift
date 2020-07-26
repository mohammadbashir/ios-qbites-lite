//
//  ChildViewController.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 11/2/19.
//  Copyright © 2019 Mohammad Bashir sidani. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import Sheeeeeeeeet
import SkyFloatingLabelTextField

class ChildViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let genderArray = ["Male", "Female"]
    
    let feedingTypesArray = [
        ["value": "", "name": ""],
        ["value": "BREAST_FEEDING", "name": "Breastfeeding"],
        ["value": "FORMULA_FEEDING", "name": "Formula feeding"],
        ["value": "COMBINATION", "name": "Combined breastmilk and formula"],
        ["value": "DONE", "name": "Finished with breastmilk and formula"]
    ]
    
    let numberOfFeedingsArray = ["", "1", "2", "3", "4", "5+"]
    
    let sizeOfFeedingsArray =  [
        ["Name": "", "USName" : "",  "min": 0, "max": 0],
        ["Name": "<=100 ml", "USName" : "<=3.3 fl. oz",  "min": 100, "max": 100],
        ["Name": "101-150 ml", "USName" : "3.3-5.0 fl. oz",  "min": 101, "max": 150],
        ["Name": "151-200 ml", "USName" : "5.1-6.6 fl. oz",  "min": 151, "max": 200],
        ["Name": "201-250 ml", "USName" : "6.7-8.3 fl. oz",  "min": 201, "max": 250],
        ["Name": ">250 ml", "USName" : ">8.3 fl. oz",  "min": 250, "max": 250]
    ]
    
    let heightUnitDict = ["US": "inch", "Normal": "cm"]
    let weightUnitDict = ["US": "Pound - Ounce", "Normal": "kg"]
    
    //    let allergiesArray = ["MILK", "EGGS", "WHEAT", "SOY", "TREENUTS", "PEANUTS", "FISH", "SHELLFISH"]
    //    let allergiesValuesArray = [false, false, false, false, false, false, false, false]
    //    var items = [MenuItem]()
    
    let allergiesArray = [
        MultiSelectItem(title: "MILK (Lactose)", isSelected: appChild().isAllergicToMilk, value: "isAllergicToMilk"),
        MultiSelectItem(title: "Cow’s milk protein (CMP)", isSelected: appChild().isAllergicToMilkCMP, value: "isAllergicToMilkCMP"),
        MultiSelectItem(title: "EGGS", isSelected: appChild().isAllergicToMilk, value: "isAllergicToEggs"),
        MultiSelectItem(title: "WHEAT", isSelected: appChild().isAllergicToMilk, value: "isAllergicToWheat"),
        MultiSelectItem(title: "SOY", isSelected: appChild().isAllergicToMilk, value: "isAllergicToSoy"),
        MultiSelectItem(title: "TREENUTS (ex:  almonds, walnuts, ...etc.)", isSelected: appChild().isAllergicToMilk, value: "isAllergicToTreenuts"),
        MultiSelectItem(title: "PEANUTS", isSelected: appChild().isAllergicToMilk, value: "isAllergicToPeanuts"),
        MultiSelectItem(title: "FISH", isSelected: appChild().isAllergicToMilk, value: "isAllergicToFish"),
        MultiSelectItem(title: "SHELLFISH", isSelected: appChild().isAllergicToMilk, value: "isAllergicToShellfish"),
        OkButton(title: "OK")
    ]
    
    lazy var oldChildObject = appChild()
    
    let fieldsHeightConstant = 50.0
    
    //
    var feedingTypeValue = ""
    
    var breastFeedingSizeMin = 0
    var breastFeedingSizeMax = 0
    var formulaFeedingSizeMin = 0
    var formulaFeedingSizeMax = 0
    //
    
    lazy var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let childImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        //        imageView.backgroundColor = .lightGray
        imageView.image = UIImage(named:"baby-boy")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var usernameField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        Utilities.sharedInstance.styleSkyField(field: field, color: .black)
        field.lineColor = mainGreenColor
        field.selectedLineColor = mainGreenColor
        field.placeholder = "Child Name"
        field.tag = 0
        field.delegate = self
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var genderField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        Utilities.sharedInstance.styleSkyField(field: field, color: .black)
        field.lineColor = mainGreenColor
        field.selectedLineColor = mainGreenColor
        field.placeholder = "Gender"
        field.tag = 1
        field.delegate = self
        field.inputView = genderPicker
        field.inputAccessoryView = pickerToolbar
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var genderPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        
        picker.tag = 0
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    lazy var dobField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        Utilities.sharedInstance.styleSkyField(field: field, color: .black)
        field.lineColor = mainGreenColor
        field.selectedLineColor = mainGreenColor
        field.placeholder = "Birthday"
        field.tag = 2
        field.delegate = self
        field.inputView = dobPicker
        field.inputAccessoryView = pickerToolbar
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var dobPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = UIDatePicker.Mode.date
        picker.backgroundColor = UIColor.white
        picker.maximumDate = Date()
        
        picker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    lazy var weightField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        Utilities.sharedInstance.styleSkyField(field: field, color: .black)
        field.lineColor = mainGreenColor
        field.selectedLineColor = mainGreenColor
        field.placeholder = "Weight"
        field.tag = 3
        field.delegate = self
        
        field.inputView = weightPicker
        field.inputAccessoryView = pickerToolbar
        
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var weightPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        
        picker.tag = 1
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    lazy var heightField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        Utilities.sharedInstance.styleSkyField(field: field, color: .black)
        field.lineColor = mainGreenColor
        field.selectedLineColor = mainGreenColor
        field.placeholder = "Height"
        field.tag = 4
        field.delegate = self
        field.inputView = heightPicker
        field.inputAccessoryView = pickerToolbar
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var heightPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        
        picker.tag = 2
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    lazy var foodTypeField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        Utilities.sharedInstance.styleSkyField(field: field, color: .black)
        field.lineColor = mainGreenColor
        field.selectedLineColor = mainGreenColor
        field.placeholder = "Infant Feeding Type"
        field.tag = 4
        field.delegate = self
        field.inputView = foodTypePicker
        field.inputAccessoryView = pickerToolbar
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var foodTypePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        
        picker.tag = 3
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    lazy var numberOfBreastFeedingsField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        Utilities.sharedInstance.styleSkyField(field: field, color: .black)
        field.lineColor = mainGreenColor
        field.selectedLineColor = mainGreenColor
        field.placeholder = "No. of breastfeeding / day"
        field.delegate = self
        field.inputView = numberOfBreastFeedingsPicker
        field.inputAccessoryView = pickerToolbar
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var numberOfBreastFeedingsPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        
        picker.tag = 6
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    lazy var sizeOfBreastFeedingsField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        Utilities.sharedInstance.styleSkyField(field: field, color: .black)
        field.lineColor = mainGreenColor
        field.selectedLineColor = mainGreenColor
        field.placeholder = "Avg. amount of breastfeeding"
        field.delegate = self
        field.inputView = sizeOfBreastFeedingsPicker
        field.inputAccessoryView = pickerToolbar
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var sizeOfBreastFeedingsPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        
        picker.tag = 7
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    
    lazy var numberOfFormulaFeedingsField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        Utilities.sharedInstance.styleSkyField(field: field, color: .black)
        field.lineColor = mainGreenColor
        field.selectedLineColor = mainGreenColor
        field.placeholder = "No. of formula Feeding / day"
        field.delegate = self
        field.inputView = numberOfFormulaFeedingsPicker
        field.inputAccessoryView = pickerToolbar
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var numberOfFormulaFeedingsPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        
        picker.tag = 8
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    lazy var sizeOfFormulaFeedingsField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        Utilities.sharedInstance.styleSkyField(field: field, color: .black)
        field.lineColor = mainGreenColor
        field.selectedLineColor = mainGreenColor
        field.placeholder = "Avg. amount of formula feeding"
        field.delegate = self
        field.inputView = sizeOfFormulaFeedingsPicker
        field.inputAccessoryView = pickerToolbar
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var sizeOfFormulaFeedingsPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        
        picker.tag = 9
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let pickerToolbar: UIToolbar = {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(ToolbarDonePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
        
    }()
    
    @objc func ToolbarDonePressed(){
        self.view.endEditing(true)
    }
    
    lazy var allergiesField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        Utilities.sharedInstance.styleSkyField(field: field, color: mainOrangeColor)
        field.placeholder = "Food Allergies / Intolerances"
        field.tag = 5
        field.delegate = self
        //        field.textField.addTarget(self, action: #selector(allergiesPressed), for: .touchDown)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    var numberOfBreastFeedingsFieldTopAnchor:NSLayoutConstraint!
    var numberOfFormulaFeedingsFieldTopAnchor:NSLayoutConstraint!
    var AllergiesFieldTopAnchor: NSLayoutConstraint!
    
    var numberOfBreastFeedingsFieldHeightAnchor:NSLayoutConstraint!
    var numberOfFormulaFeedingsFieldHeightAnchor:NSLayoutConstraint!
    var AllergiesFieldHeightAnchor: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utilities.sharedInstance.applyBlueGradient(view: self.view)
        GlobalChildViewController = self
        
        
        if(appChild().id == -1){
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(EditSavePressed))
            editMode(isEdit: true)
        }
        else{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(EditSavePressed))
            editMode(isEdit: false)
        }
        
        
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(contentView)
        
        contentView.addSubview(childImage)
        contentView.addSubview(usernameField)
        contentView.addSubview(genderField)
        contentView.addSubview(dobField)
        contentView.addSubview(weightField)
        contentView.addSubview(heightField)
        contentView.addSubview(foodTypeField)
        
        contentView.addSubview(numberOfBreastFeedingsField)
        contentView.addSubview(sizeOfBreastFeedingsField)
        contentView.addSubview(numberOfFormulaFeedingsField)
        contentView.addSubview(sizeOfFormulaFeedingsField)
        
        contentView.addSubview(allergiesField)
        
        updateFields()
        
        oldChildObject = appChild()
        
    }
    
    func updateFields() {
        
        if(appChild().id != -1){
            
            if(appChild().gender == "MALE"){
                childImage.image = UIImage(named: "baby-boy")
            }
            else{
                childImage.image = UIImage(named: "baby-girl")
            }
            
            usernameField.text = appChild().name
            genderField.text = appChild().gender.capitalizingFirstLetter()
            
            
            dobField.text = appChild().birthDate.toString(withFormat: "MMMM dd yyyy")
            dobPicker.date = appChild().birthDate
            
            //weight and height are to be calculated dynamiclly from the placeholders so fine..
            weightField.text = appChild().weightPlaceholder
            heightField.text = appChild().heightPlaceholder
            
            feedingTypeValue = appChild().infantFeeding
            
            for type in feedingTypesArray {
                if(type["value"] == feedingTypeValue){
                    foodTypeField.text = type["name"]
                }
            }
            
            if(appChild().numberOfBreastFeedings != 5){
                numberOfBreastFeedingsField.text = String(appChild().numberOfBreastFeedings)
            }
            else{
                numberOfBreastFeedingsField.text = "5+"
            }
            
            breastFeedingSizeMin = appChild().sizeOfBreastFeedingsMin
            breastFeedingSizeMax = appChild().sizeOfBreastFeedingsMax
            
            if(appChild().numberOfFormulaFeedings != 5){
                numberOfFormulaFeedingsField.text = String(appChild().numberOfFormulaFeedings)
            }
            else{
                numberOfFormulaFeedingsField.text = "5+"
            }
            
            formulaFeedingSizeMin = appChild().sizeOfFormulaFeedingsMin
            formulaFeedingSizeMax = appChild().sizeOfFormulaFeedingsMax
            
            for size in sizeOfFeedingsArray {
                
                if (size["min"] as? Int == breastFeedingSizeMin){
                    sizeOfBreastFeedingsField.text = size["Name"] as? String
                }
                
                if (size["min"] as? Int == formulaFeedingSizeMin){
                    sizeOfFormulaFeedingsField.text = size["Name"] as? String
                }
                
            }
            
            //allergies
            for element in allergiesArray{
                
                if let item = element as? MultiSelectItem {
                    
                    if(item.value as? String == "isAllergicToEggs"){
                        item.isSelected = appChild().isAllergicToEggs
                    }
                    
                    if(item.value as? String == "isAllergicToFish"){
                        item.isSelected = appChild().isAllergicToFish
                    }
                    
                    if(item.value as? String == "isAllergicToMilk"){
                        item.isSelected = appChild().isAllergicToMilk
                    }
                    
                    if(item.value as? String == "isAllergicToPeanuts"){
                        item.isSelected = appChild().isAllergicToPeanuts
                    }
                    
                    if(item.value as? String == "isAllergicToShellfish"){
                        item.isSelected = appChild().isAllergicToShellfish
                    }
                    
                    if(item.value as? String == "isAllergicToSoy"){
                        item.isSelected = appChild().isAllergicToSoy
                    }
                    
                    if(item.value as? String == "isAllergicToTreenuts"){
                        item.isSelected = appChild().isAllergicToTreenuts
                    }
                    
                    if(item.value as? String == "isAllergicToWheat"){
                        item.isSelected = appChild().isAllergicToWheat
                    }
                    
                }
                
            }
            
            self.allergiesField.text = ""
            
            for (_, element) in self.allergiesArray.enumerated(){
                if let item = element as? MultiSelectItem {
                    if(item.isSelected){
                        self.allergiesField.text = (self.allergiesField.text ?? "") + ", " + item.title
                    }
                }
            }
            
            if(self.allergiesField.text != ""){
                self.allergiesField.text!.remove(at: self.allergiesField.text!.startIndex)
                self.allergiesField.text!.remove(at: self.allergiesField.text!.startIndex)
            }
            
        }
        else{
            
        }
        
    }
    
    override func viewSafeAreaInsetsDidChange() {
        // ... your layout code here
        layoutViews()
    }
    
    func layoutViews(){
        
        mainScrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainScrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: Utilities.sharedInstance.SafeAreaTopInset() + (self.navigationController?.navigationBar.frame.size.height ?? 0)).isActive = true
        mainScrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        contentView.topAnchor.constraint(equalTo: mainScrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: mainScrollView.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: mainScrollView.rightAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor).isActive = true
        
        childImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        childImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        childImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4).isActive = true
        childImage.heightAnchor.constraint(equalTo: childImage.widthAnchor, multiplier: 1).isActive = true
        
        usernameField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        usernameField.topAnchor.constraint(equalTo: childImage.bottomAnchor, constant:23).isActive = true
        usernameField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.65).isActive = true
        usernameField.heightAnchor.constraint(equalToConstant: CGFloat(fieldsHeightConstant)).isActive = true
        
        genderField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 23).isActive = true
        genderField.widthAnchor.constraint(equalTo: usernameField.widthAnchor).isActive = true
        genderField.heightAnchor.constraint(equalToConstant: CGFloat(fieldsHeightConstant)).isActive = true
        genderField.centerXAnchor.constraint(equalTo: usernameField.centerXAnchor).isActive = true
        
        dobField.topAnchor.constraint(equalTo: genderField.bottomAnchor, constant: 23).isActive = true
        dobField.widthAnchor.constraint(equalTo: usernameField.widthAnchor).isActive = true
        dobField.heightAnchor.constraint(equalToConstant: CGFloat(fieldsHeightConstant)).isActive = true
        dobField.centerXAnchor.constraint(equalTo: usernameField.centerXAnchor).isActive = true
        
        weightField.topAnchor.constraint(equalTo: dobField.bottomAnchor, constant: 23).isActive = true
        weightField.widthAnchor.constraint(equalTo: usernameField.widthAnchor).isActive = true
        weightField.heightAnchor.constraint(equalToConstant: CGFloat(fieldsHeightConstant)).isActive = true
        weightField.centerXAnchor.constraint(equalTo: usernameField.centerXAnchor).isActive = true
        
        heightField.topAnchor.constraint(equalTo: weightField.bottomAnchor, constant: 23).isActive = true
        heightField.widthAnchor.constraint(equalTo: usernameField.widthAnchor).isActive = true
        heightField.heightAnchor.constraint(equalToConstant: CGFloat(fieldsHeightConstant)).isActive = true
        heightField.centerXAnchor.constraint(equalTo: usernameField.centerXAnchor).isActive = true
        
        foodTypeField.topAnchor.constraint(equalTo: heightField.bottomAnchor, constant: 23).isActive = true
        foodTypeField.widthAnchor.constraint(equalTo: usernameField.widthAnchor).isActive = true
        foodTypeField.heightAnchor.constraint(equalToConstant: CGFloat(fieldsHeightConstant)).isActive = true
        foodTypeField.centerXAnchor.constraint(equalTo: usernameField.centerXAnchor).isActive = true
        
        //        numberOfBreastFeedingsField.topAnchor.constraint(equalTo: foodTypeField.bottomAnchor, constant: 23).isActive = true
        numberOfBreastFeedingsField.widthAnchor.constraint(equalTo: usernameField.widthAnchor).isActive = true
        numberOfBreastFeedingsField.centerXAnchor.constraint(equalTo: usernameField.centerXAnchor).isActive = true
        numberOfBreastFeedingsField.heightAnchor.constraint(equalTo: usernameField.heightAnchor).isActive = true
        
        sizeOfBreastFeedingsField.topAnchor.constraint(equalTo: numberOfBreastFeedingsField.bottomAnchor, constant: 23).isActive = true
        sizeOfBreastFeedingsField.widthAnchor.constraint(equalTo: usernameField.widthAnchor).isActive = true
        sizeOfBreastFeedingsField.centerXAnchor.constraint(equalTo: usernameField.centerXAnchor).isActive = true
        sizeOfBreastFeedingsField.heightAnchor.constraint(equalTo: usernameField.heightAnchor).isActive = true
        
        //        numberOfFormulaFeedingsField.topAnchor.constraint(equalTo: sizeOfBreastFeedingsField.bottomAnchor, constant: 23).isActive = true
        numberOfFormulaFeedingsField.widthAnchor.constraint(equalTo: usernameField.widthAnchor).isActive = true
        numberOfFormulaFeedingsField.centerXAnchor.constraint(equalTo: usernameField.centerXAnchor).isActive = true
        numberOfFormulaFeedingsField.heightAnchor.constraint(equalTo: usernameField.heightAnchor).isActive = true
        
        sizeOfFormulaFeedingsField.topAnchor.constraint(equalTo: numberOfFormulaFeedingsField.bottomAnchor, constant: 23).isActive = true
        sizeOfFormulaFeedingsField.widthAnchor.constraint(equalTo: usernameField.widthAnchor).isActive = true
        sizeOfFormulaFeedingsField.centerXAnchor.constraint(equalTo: usernameField.centerXAnchor).isActive = true
        sizeOfFormulaFeedingsField.heightAnchor.constraint(equalTo: usernameField.heightAnchor).isActive = true
        
        allergiesField.widthAnchor.constraint(equalTo: usernameField.widthAnchor).isActive = true
        allergiesField.centerXAnchor.constraint(equalTo: usernameField.centerXAnchor).isActive = true
        allergiesField.heightAnchor.constraint(equalTo: usernameField.heightAnchor).isActive = true
        
        updateDynamicFields()
        
        contentView.bottomAnchor.constraint(equalTo: allergiesField.bottomAnchor, constant: 10).isActive = true
        
        view.layoutIfNeeded()
        
        childImage.layer.cornerRadius = 15
        
    }
    
    func updateDynamicFields(){
        
        if(numberOfBreastFeedingsFieldTopAnchor != nil){
            numberOfBreastFeedingsFieldTopAnchor.isActive = false
        }
        if(numberOfFormulaFeedingsFieldTopAnchor != nil){
            numberOfFormulaFeedingsFieldTopAnchor.isActive = false
        }
        if(AllergiesFieldTopAnchor != nil){
            AllergiesFieldTopAnchor.isActive = false
        }
        
        
        if (feedingTypeValue == feedingTypesArray[1]["value"]!){ //breast
            
            numberOfBreastFeedingsField.isHidden = false
            sizeOfBreastFeedingsField.isHidden = false
            
            numberOfFormulaFeedingsField.isHidden = true
            sizeOfFormulaFeedingsField.isHidden = true
            
            numberOfBreastFeedingsFieldTopAnchor = numberOfBreastFeedingsField.topAnchor.constraint(equalTo: foodTypeField.bottomAnchor, constant: 23)
            AllergiesFieldTopAnchor = allergiesField.topAnchor.constraint(equalTo: sizeOfBreastFeedingsField.bottomAnchor, constant: 23)
            
        }
            
        else if (feedingTypeValue == feedingTypesArray[2]["value"]!){ //formula
            
            numberOfBreastFeedingsField.isHidden = true
            sizeOfBreastFeedingsField.isHidden = true
            
            numberOfFormulaFeedingsField.isHidden = false
            sizeOfFormulaFeedingsField.isHidden = false
            
            numberOfFormulaFeedingsFieldTopAnchor = numberOfFormulaFeedingsField.topAnchor.constraint(equalTo: foodTypeField.bottomAnchor, constant: 23)
            AllergiesFieldTopAnchor = allergiesField.topAnchor.constraint(equalTo: sizeOfFormulaFeedingsField.bottomAnchor, constant: 23)
            
        }
        else if (feedingTypeValue == feedingTypesArray[3]["value"]!){ // breast and formula
            
            numberOfBreastFeedingsField.isHidden = false
            sizeOfBreastFeedingsField.isHidden = false
            
            numberOfFormulaFeedingsField.isHidden = false
            sizeOfFormulaFeedingsField.isHidden = false
            
            numberOfBreastFeedingsFieldTopAnchor = numberOfBreastFeedingsField.topAnchor.constraint(equalTo: foodTypeField.bottomAnchor, constant: 23)
            numberOfFormulaFeedingsFieldTopAnchor = numberOfFormulaFeedingsField.topAnchor.constraint(equalTo: sizeOfBreastFeedingsField.bottomAnchor, constant: 23)
            AllergiesFieldTopAnchor = allergiesField.topAnchor.constraint(equalTo: sizeOfFormulaFeedingsField.bottomAnchor, constant: 23)
            
        }
        else { //none
            
            numberOfBreastFeedingsField.isHidden = true
            sizeOfBreastFeedingsField.isHidden = true
            
            numberOfFormulaFeedingsField.isHidden = true
            sizeOfFormulaFeedingsField.isHidden = true
            
            AllergiesFieldTopAnchor = allergiesField.topAnchor.constraint(equalTo: foodTypeField.bottomAnchor, constant: 23)
            
        }
        
        if(numberOfBreastFeedingsFieldTopAnchor != nil){
            numberOfBreastFeedingsFieldTopAnchor.isActive = true
        }
        if(numberOfFormulaFeedingsFieldTopAnchor != nil){
            numberOfFormulaFeedingsFieldTopAnchor.isActive = true
        }
        if(AllergiesFieldTopAnchor != nil){
            AllergiesFieldTopAnchor.isActive = true
        }
        
        self.view.layoutIfNeeded()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showNavigationBar()
        makeNavigationTransparent()
        self.navigationController?.navigationBar.tintColor = .black//mainLightBlueColor//mainGreenColor//.white
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow( notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide( notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    //0->gender, 1->weight, 2->height, 3-> Food Type
    //4-> numberOfFeedingsField 5-> sizeOfFeedingsField 6-> numberOfBreastFeedingsField 7-> sizeOfBreastFeedingsField 8-> numberOfFormulaFeedingsField 9-> sizeOfFormulaFeedingsField
    //(4 6 8 are number of serings) (5 7 9 are size of servings)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        if(pickerView.tag == 0){
            return 1
        }
        else if(pickerView.tag == 1){
            
            if(appParent().isUSMetrics){
                return 2
            }
            else{
                return 3
            }
            
        }
        else if(pickerView.tag == 2){
            return 3
        }
        else if(pickerView.tag == 3){
            return 1
        }
        else if(pickerView.tag == 4 || pickerView.tag == 5 || pickerView.tag == 6 || pickerView.tag == 7 || pickerView.tag == 8 || pickerView.tag == 9){
            return 1
        }
        
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if(pickerView.tag == 0){
            return genderArray.count
        }
        else if(pickerView.tag == 1){
            
            if(appParent().isUSMetrics){
                
                if(component == 0){
                    return 100
                }
                else if(component == 1){
                    return 17
                }
                //                else if (component == 2){
                //                    return 1
                //                }
                
            }
            else{
                
                if(component == 0){
                    return 100
                }
                else if(component == 1){
                    return 10
                }
                else if (component == 2){
                    return 1
                }
                
            }
            
            
            
        }
        else if(pickerView.tag == 2){
            
            if(component == 0){
                return 120
            }
            else if(component == 1){
                return 10
            }
            else if (component == 2){
                return 1
            }
            
        }
        else if(pickerView.tag == 3){
            return feedingTypesArray.count
        }
        else if(pickerView.tag == 4 || pickerView.tag == 6 || pickerView.tag == 8){
            return numberOfFeedingsArray.count
        }
        else if(pickerView.tag == 5 || pickerView.tag == 7 || pickerView.tag == 9){
            return sizeOfFeedingsArray.count
        }
        
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if(pickerView.tag == 0){
            return genderArray[row]
        }
        else if(pickerView.tag == 1){
            
            if(appParent().isUSMetrics){
                
                var poundString = "pounds"
                var ouncesString = "ounces"
                
                if(row == 1){
                    poundString = "pound"
                    ouncesString = "ounce"
                }
                
                if(component == 0){
                    return String(row) + " " + poundString
                }
                else if(component == 1){
                    return String(row) + " " + ouncesString
                }
                
            }
            else{
                
                if(component == 0){
                    return String(row)
                }
                else if(component == 1){
                    return "." + String(row)
                }
                else if (component == 2){
                    return weightUnitDict["Normal"]
                }
                
            }
            
        }
        else if(pickerView.tag == 2){
            
            if(component == 0){
                return String(row)
            }
            else if(component == 1){
                return "." + String(row)
            }
            else if (component == 2){
                
                if(appParent().isUSMetrics){
                    return heightUnitDict["US"]
                }
                else{
                    return heightUnitDict["Normal"]
                }
                
            }
            
        }
            
        else if(pickerView.tag == 3){
            return feedingTypesArray[row]["name"]
        }
            
        else if(pickerView.tag == 4 || pickerView.tag == 6 || pickerView.tag == 8){
            return numberOfFeedingsArray[row]
        }
        else if(pickerView.tag == 5 || pickerView.tag == 7 || pickerView.tag == 9){
            
            let feedingDict = sizeOfFeedingsArray[row] as NSDictionary
            
            if(appParent().isUSMetrics){
                return feedingDict["USName"] as? String
            }
            else{
                return feedingDict["Name"] as? String
            }
            //            return sizeOfFeedingsArray[row]
        }
        
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        if(pickerView.tag == 0){
            genderField.text = genderArray[row]
            
            if(genderArray[row] == "Male"){
                //                parentImage.backgroundColor = mainLightBlueColor
                childImage.image = UIImage(named: "baby-boy")
            }
            else{
                //                parentImage.backgroundColor = mainPinkColor
                childImage.image = UIImage(named: "baby-girl")
            }
            
        }
        else if(pickerView.tag == 1){
            
            
            if(appParent().isUSMetrics){
                
                var poundString = "pounds"
                var ouncesString = "ounces"
                
                if(pickerView.selectedRow(inComponent: 0) == 1){
                    poundString = "pound"
                }
                
                if(pickerView.selectedRow(inComponent: 1) == 1){
                    ouncesString = "ounce"
                }
                
                weightField.text = String(pickerView.selectedRow(inComponent: 0)) + " " + poundString + " " + String(pickerView.selectedRow(inComponent: 1)) + " " + ouncesString
            }
            else{
                weightField.text = String(pickerView.selectedRow(inComponent: 0)) + "." + String(pickerView.selectedRow(inComponent: 1)) + " "
                
                if(appParent().isUSMetrics){
                    weightField.text = weightField.text! + weightUnitDict["US"]!
                }
                else{
                    weightField.text = weightField.text! + weightUnitDict["Normal"]!
                }
            }
            
            
        }
        else if(pickerView.tag == 2){
            
            heightField.text = String(pickerView.selectedRow(inComponent: 0)) + "." + String(pickerView.selectedRow(inComponent: 1)) + " "
            
            //+ heightMeasurmentArray[pickerView.selectedRow(inComponent: 2)]
            if(appParent().isUSMetrics){
                heightField.text = heightField.text! + heightUnitDict["US"]!
            }
            else{
                heightField.text = heightField.text! + heightUnitDict["Normal"]!
            }
            
        }
        else if(pickerView.tag == 3){
            foodTypeField.text = feedingTypesArray[row]["name"]
            feedingTypeValue = feedingTypesArray[row]["value"]!
            updateDynamicFields()
        }
            
            //       else if(pickerView.tag == 4){
            //            numberOfFeedingsField.textField.text = numberOfFeedingsArray[row]
            //        }
            //        else if(pickerView.tag == 5){
            //
            //            let feedingDict = sizeOfFeedingsArray[row] as NSDictionary
            //            feedingSizeMin = feedingDict["min"] as! Int
            //            feedingSizeMax = feedingDict["max"] as! Int
            //
            //            if(appParent().isUSMetrics){
            //                sizeOfFeedingsField.textField.text = feedingDict["USName"] as? String
            //            }
            //            else{
            //                sizeOfFeedingsField.textField.text = feedingDict["Name"] as? String
            //            }
            //
            //        }
        else if(pickerView.tag == 6){
            numberOfBreastFeedingsField.text = numberOfFeedingsArray[row]
        }
        else if(pickerView.tag == 7){
            
            let feedingDict = sizeOfFeedingsArray[row] as NSDictionary
            breastFeedingSizeMin = feedingDict["min"] as! Int
            breastFeedingSizeMax = feedingDict["max"] as! Int
            
            if(appParent().isUSMetrics){
                sizeOfBreastFeedingsField.text = feedingDict["USName"] as? String
            }
            else{
                sizeOfBreastFeedingsField.text = feedingDict["Name"] as? String
            }
            
        }
        else if(pickerView.tag == 8){
            numberOfFormulaFeedingsField.text = numberOfFeedingsArray[row]
        }
        else if(pickerView.tag == 9){
            
            let feedingDict = sizeOfFeedingsArray[row] as NSDictionary
            formulaFeedingSizeMin = feedingDict["min"] as! Int
            formulaFeedingSizeMax = feedingDict["max"] as! Int
            
            if(appParent().isUSMetrics){
                sizeOfFormulaFeedingsField.text = feedingDict["USName"] as? String
            }
            else{
                sizeOfFormulaFeedingsField.text = feedingDict["Name"] as? String
            }
            
        }
        
    }
    
    @objc func dateChanged(sender: UIDatePicker){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd yyyy"
        
        dobField.text = formatter.string(from: sender.date)
    }
    
    @objc func keyboardWillShow(notification: Notification){
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let toolbarHeight = pickerToolbar.frame.size.height
            mainScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: (keyboardHeight + toolbarHeight + 20) - (self.view.frame.size.height - mainScrollView.frame.size.height), right: 0)
            mainScrollView.scrollIndicatorInsets = mainScrollView.contentInset
        }
    }
    
    @objc func keyboardWillHide(notification: Notification){
        mainScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        mainScrollView.scrollIndicatorInsets = mainScrollView.contentInset
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField.tag == 5){
            allergiesPressed(sender: textField)
            return false
        }
        
        return true
    }
    
    func allergiesPressed(sender: UITextField){
        
        let menu = Menu(title: "Select allergies", items: allergiesArray)
        
        menu.presentAsActionSheet(in: self, from: self.view) { (sheet, item) in
            
            self.allergiesField.text = ""
            
            for (_, element) in self.allergiesArray.enumerated(){
                if let item = element as? MultiSelectItem {
                    if(item.isSelected){
                        self.allergiesField.text = (self.allergiesField.text ?? "") + ", " + item.title
                    }
                }
            }
            
            if(self.allergiesField.text != ""){
                self.allergiesField.text!.remove(at: self.allergiesField.text!.startIndex)
                self.allergiesField.text!.remove(at: self.allergiesField.text!.startIndex)
            }
            
            
        }
    }
    
    
    func editMode(isEdit: Bool){
        
        self.view.endEditing(true)
        
        usernameField.isUserInteractionEnabled = isEdit
        genderField.isUserInteractionEnabled = isEdit
        dobField.isUserInteractionEnabled = isEdit
        weightField.isUserInteractionEnabled = isEdit
        heightField.isUserInteractionEnabled = isEdit
        foodTypeField.isUserInteractionEnabled = isEdit
        
        if(appChild().id == -1){
            weightField.isUserInteractionEnabled = isEdit
            heightField.isUserInteractionEnabled = isEdit
        }
        else{
            weightField.isUserInteractionEnabled = false
            heightField.isUserInteractionEnabled = false
        }
        
        numberOfBreastFeedingsField.isUserInteractionEnabled = isEdit
        sizeOfBreastFeedingsField.isUserInteractionEnabled = isEdit
        numberOfFormulaFeedingsField.isUserInteractionEnabled = isEdit
        sizeOfFormulaFeedingsField.isUserInteractionEnabled = isEdit
        
        allergiesField.isUserInteractionEnabled = isEdit
        
    }
    
    @objc func EditSavePressed(){
        
        if(self.navigationItem.rightBarButtonItem?.title == "Edit"){
            
            //alert here to update weight, height, or child details
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let weightEditAction = UIAlertAction(title: "Update Weight & Height", style: .default, handler: { action in
                self.present(ChildGrowthViewController(), animated: true) { }
            })
            alert.addAction(weightEditAction)
            
            let detailsEditAction = UIAlertAction(title: "Edit Child", style: .default, handler: { action in
                self.navigationItem.rightBarButtonItem?.title = "Save"
                self.editMode(isEdit: true)
            })
            alert.addAction(detailsEditAction)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                
            }))
            
            self.present(alert, animated: true, completion: {
                
            })
            
            //                self.navigationItem.rightBarButtonItem?.title = "Save"
            //                editMode(isEdit: true)
        }
        else if (self.navigationItem.rightBarButtonItem?.title == "Save"){
            
            if(usernameField.text == ""){
                SVProgressHUD.showInfo(withStatus: "Name cannot be empty")
            }
            else if (usernameField.text!.count < 3){
                SVProgressHUD.showInfo(withStatus: "Name is too short")
            }
            else if(genderField.text == ""){
                SVProgressHUD.showInfo(withStatus: "Gender is required")
            }
            else if(dobField.text == ""){
                SVProgressHUD.showInfo(withStatus: "Birthday is required")
            }
            else if(weightField.text == ""){
                SVProgressHUD.showInfo(withStatus: "Weight is required")
            }
            else if(heightField.text == ""){
                SVProgressHUD.showInfo(withStatus: "Height is required")
            }
            else if(foodTypeField.text == ""){
                SVProgressHUD.showInfo(withStatus: "Infant feeding type is required")
            }
            else if( (feedingTypeValue == feedingTypesArray[1]["value"]!) && ( numberOfBreastFeedingsField.text == "" || sizeOfBreastFeedingsField.text == "" ) ){
                SVProgressHUD.showInfo(withStatus: "Number and sizes breast of feedings are required")
            }
            else if( (feedingTypeValue == feedingTypesArray[2]["value"]!) && ( numberOfFormulaFeedingsField.text == "" || sizeOfFormulaFeedingsField.text == "" ) ){
                SVProgressHUD.showInfo(withStatus: "Number and sizes formula of feedings are required")
            }
            else if( feedingTypeValue == feedingTypesArray[3]["value"]! && ( numberOfBreastFeedingsField.text == "" || sizeOfBreastFeedingsField.text == "" || numberOfFormulaFeedingsField.text == "" || sizeOfFormulaFeedingsField.text == "") ){
                SVProgressHUD.showInfo(withStatus: "Number and sizes of breast and formula feedings are required")
            }
            else{
                //
                var params = [:] as [String : Any]
                
                if (appChild().id != -1){
                    params["id"] = appChild().id
                }
                else{
                    params["family"] = ["id": appFamily().id]
                }
                
                params["name"] = usernameField.text
                params["gender"] = genderField.text?.uppercased()
                
                let date = dobField.text!.asDate
                let dateData = date.toString(withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSS")
                params["birthDate"] = dateData + "+0000"
                
                if(appParent().isUSMetrics){ //convertion of us metrics to normal (weight, heights sizes)
                    
                    //5 pounds 5 ounces
                    let poundsCount = Double(weightField.text!.components(separatedBy: " ")[0])!
                    let ouncesCount = Double(weightField.text!.components(separatedBy: " ")[2])!
                    
                    let weightCount = (poundsCount * 0.453592) + (ouncesCount * 0.0283495)
                    params["weight"] = weightCount
                    
                    //1.1 inches
                    let heightString = heightField.text!.components(separatedBy: " ")[0]
                    let heightDouble = Double(heightString)! * 2.54
                    params["height"] = heightDouble
                    
                }
                else{
                    
                    // 1.1 kg
                    let weightString = weightField.text!.components(separatedBy: " ")[0]
                    params["weight"] = Double(weightString)
                    
                    //1.1 cm
                    let heightString = heightField.text!.components(separatedBy: " ")[0]
                    params["height"] = Double(heightString)
                    
                }
                
                params["weightPlaceHolder"] = weightField.text
                params["heightPlaceHolder"] = heightField.text
                
                //                    for dict in feedingTypesArray{
                //                        if( dict["name"] == foodTypeField.textField.text ){
                //                            params["infantFeeding"] = dict["value"]
                //                        }
                //                    }
                
                params["infantFeeding"] = feedingTypeValue
                
                if (params["infantFeeding"] as! String == "DONE"){
                    
                    params["numberOfBreastFeedings"] = 0
                    params["sizeOfBreastFeedingsMin"] = 0
                    params["sizeOfBreastFeedingsMax"] = 0
                    
                    params["numberOfFormulaFeedings"] = 0
                    params["sizeOfFormulaFeedingsMin"] = 0
                    params["sizeOfFormulaFeedingsMax"] = 0
                    
                }
                    
                else if(params["infantFeeding"] as! String == "BREAST_FEEDING" ){
                    
                    if(numberOfBreastFeedingsField.text == "5+"){
                        params["numberOfBreastFeedings"] = 5
                    }
                    else{
                        params["numberOfBreastFeedings"] = Int(numberOfBreastFeedingsField.text!)
                    }
                    
                    params["sizeOfBreastFeedingsMin"] = breastFeedingSizeMin
                    params["sizeOfBreastFeedingsMax"] = breastFeedingSizeMax
                    
                    params["numberOfFormulaFeedings"] = 0
                    params["sizeOfFormulaFeedingsMin"] = 0
                    params["sizeOfFormulaFeedingsMax"] = 0
                    
                }
                    
                else if(params["infantFeeding"] as! String == "FORMULA_FEEDING" ){
                    
                    if(numberOfFormulaFeedingsField.text == "5+"){
                        params["numberOfFormulaFeedings"] = 5
                    }
                    else{
                        params["numberOfFormulaFeedings"] = Int(numberOfFormulaFeedingsField.text!)
                    }
                    
                    params["sizeOfFormulaFeedingsMin"] = formulaFeedingSizeMin
                    params["sizeOfFormulaFeedingsMax"] = formulaFeedingSizeMax
                    
                    params["numberOfBreastFeedings"] = 0
                    params["sizeOfBreastFeedingsMin"] = 0
                    params["sizeOfBreastFeedingsMax"] = 0
                    
                }
                    
                else if(params["infantFeeding"] as! String == "COMBINATION"){
                    
                    if(numberOfBreastFeedingsField.text == "5+"){
                        params["numberOfBreastFeedings"] = 5
                    }
                    else{
                        params["numberOfBreastFeedings"] = Int(numberOfBreastFeedingsField.text!)
                    }
                    
                    params["sizeOfBreastFeedingsMin"] = breastFeedingSizeMin
                    params["sizeOfBreastFeedingsMax"] = breastFeedingSizeMax
                    
                    
                    
                    if(numberOfFormulaFeedingsField.text == "5+"){
                        params["numberOfFormulaFeedings"] = 5
                    }
                    else{
                        params["numberOfFormulaFeedings"] = Int(numberOfFormulaFeedingsField.text!)
                    }
                    
                    params["sizeOfFormulaFeedingsMin"] = formulaFeedingSizeMin
                    params["sizeOfFormulaFeedingsMax"] = formulaFeedingSizeMax
                    
                }
                
                for allergy in allergiesArray {
                    
                    if let allergyItem:MultiSelectItem = allergy as? MultiSelectItem {
                        params[allergyItem.value as! String] = allergyItem.isSelected
                    }
                    
                }
                
                SVProgressHUD.show()
                
                if(appChild().id == -1){
                    
                    RequestHelper.sharedInstance.createChild(params: params) { (response) in
                        if(response["success"] as? Bool == true){
                            
                            self.editMode(isEdit: false)
                            self.navigationItem.rightBarButtonItem?.title = "Edit"
                            SVProgressHUD.dismiss()
                            
                        }
                        else{
                            SVProgressHUD.showError(withStatus: response["message"] as? String)
                        }
                    }
                    
                }
                else{
                    
                    RequestHelper.sharedInstance.updateChild(params: params) { (response) in
                        if(response["success"] as? Bool == true){
                            
                            self.editMode(isEdit: false)
                            self.navigationItem.rightBarButtonItem?.title = "Edit"
                            SVProgressHUD.dismiss()
                            
                            if (self.oldChildObject.isAllergicToAlcohol != appChild().isAllergicToAlcohol ||
                                self.oldChildObject.isAllergicToEggs != appChild().isAllergicToEggs ||
                                self.oldChildObject.isAllergicToFish != appChild().isAllergicToFish ||
                                self.oldChildObject.isAllergicToMilk != appChild().isAllergicToMilk ||
                                self.oldChildObject.isAllergicToMilkCMP != appChild().isAllergicToMilkCMP ||
                                self.oldChildObject.isAllergicToPeanuts != appChild().isAllergicToPeanuts ||
                                self.oldChildObject.isAllergicToPork != appChild().isAllergicToPork ||
                                self.oldChildObject.isAllergicToShellfish != appChild().isAllergicToShellfish ||
                                self.oldChildObject.isAllergicToSoy != appChild().isAllergicToSoy ||
                                self.oldChildObject.isAllergicToTreenuts != appChild().isAllergicToTreenuts ||
                                self.oldChildObject.isAllergicToWheat != appChild().isAllergicToWheat)
                            {
                                //an allergy changed... ask for impacting the meal plan
                                self.oldChildObject = appChild()
                                
//                                let alert = UIAlertController(title: "Impact Meal Plan", message: "Allergies have been edited, do you want to regenerate the meal plan?", preferredStyle: UIAlertController.Style.alert)
//                                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in
//
//                                    SVProgressHUD.show()
//                                    RequestHelper.sharedInstance.getMealPlan(forceRefresh: true) { (response) in
//                                        if(response["success"] as? Bool == true){
//                                            SVProgressHUD.dismiss()
//                                            GlobalMealPlanViewController?.shouldRefresh = true
//                                        }
//                                        else{
//                                            SVProgressHUD.showError(withStatus: response["message"] as? String)
//                                        }
//                                    }
//
//                                }))
//                                alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in   }))
//                                self.present(alert, animated: true, completion: nil)
                                
                                GlobalRecipesViewController?.shouldRefresh = true
                            }
                            else{
                                //no allergy changed... do nothing
                            }
                            
                        }
                        else{
                            SVProgressHUD.showError(withStatus: response["message"] as? String)
                        }
                    }
                    
                }
                
                
            }
            
            
        }
        
    }
    
}

