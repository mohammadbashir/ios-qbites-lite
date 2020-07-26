//
//  DailyInputViewController.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 1/2/20.
//  Copyright © 2020 Mohammad Bashir sidani. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import SkyFloatingLabelTextField

class DailyInputViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var mealPlanId = 0
    var date = Date()
    
    
    lazy var feedingTypesArray = [
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
    
    let fieldsHeightConstant = 50.0
    
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
    
    let insertLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = mainGreenColor
        label.font = mainFont(size: 20)
        label.numberOfLines = 0
        label.setLineSpacing(lineSpacing: 15, lineHeightMultiple: 0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var numberOfBreastFeedingsField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        Utilities.sharedInstance.styleSkyField(field: field)
        field.placeholder = "No. of breastfeeding / day"
        //        field.tag = 4
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
        Utilities.sharedInstance.styleSkyField(field: field)
        field.placeholder = "Avg. amount of breastfeeding"
        //        field.tag = 4
        field.delegate = self
        //
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
        Utilities.sharedInstance.styleSkyField(field: field)
        field.placeholder = "No. of formula Feeding / day"
        //        field.tag = 4
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
        Utilities.sharedInstance.styleSkyField(field: field)
        field.placeholder = "Avg. amount of formula feeding"
        //        field.tag = 4
        field.delegate = self
        //
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
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 2
        button.layer.borderColor = mainGreenColor.cgColor
        button.setTitle("Done", for: .normal)
        button.addTarget(self, action: #selector(donePressed( sender:)),for: .touchUpInside)
        button.titleLabel?.font =  mainFontBold(size: 20)
        button.setTitleColor(mainGreenColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Did not breastfeed or give formula", for: .normal)
        button.setTitleColor(mainGreenColor, for: .normal)
        button.titleLabel?.font =  mainFont(size: 15)
        button.addTarget(self, action: #selector(cancelPressed( sender:)),for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let finishedButton: UIButton = {
        let button = UIButton()
        //        button.setTitle("Finsihed breast or formula feeding?", for: .normal)
        button.titleLabel?.font =  mainFont(size: 15)
        button.setTitleColor(mainGreenColor, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(finishedPressed( sender:)),for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        return button
    }()
    
    lazy var pickerToolbar: UIToolbar = {
        
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
    
    lazy var feedingTypeValue = appChild().infantFeeding
    var breastFeedingSizeMin = 0//appChild().sizeOfBreastFeedingsMin
    var breastFeedingSizeMax = 0//appChild().sizeOfBreastFeedingsMax
    var formulaFeedingSizeMin = 0//appChild().sizeOfFormulaFeedingsMin
    var formulaFeedingSizeMax = 0//appChild().sizeOfFormulaFeedingsMax
    
    var numberOfBreastFeedingsFieldTopAnchor:NSLayoutConstraint!
    var numberOfFormulaFeedingsFieldTopAnchor:NSLayoutConstraint!
    var doneButtonTopAnchor: NSLayoutConstraint!
    
    @objc func ToolbarDonePressed(){
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var insertSentence = "Please indicate the"
        
        if (feedingTypeValue == feedingTypesArray[1]["value"]!){ //breast
            insertSentence = insertSentence + " breast feeding amount for "
        }
        else if (feedingTypeValue == feedingTypesArray[2]["value"]!){ //formula
            insertSentence = insertSentence + " bottle feeding amount for "
        }
        else if (feedingTypeValue == feedingTypesArray[3]["value"]!){ // breast and formula
            insertSentence = insertSentence + " breast feeding and/or bottle feeding amounts for "
        }
        
        insertSentence = insertSentence + date.toString(withFormat: "EEEE")
        
        insertLabel.text = insertSentence
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utilities.sharedInstance.applyBlueGradient(view: self.view)
        
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(contentView)
        
        contentView.addSubview(childImage)
        contentView.addSubview(insertLabel)
        
        contentView.addSubview(numberOfBreastFeedingsField)
        contentView.addSubview(sizeOfBreastFeedingsField)
        contentView.addSubview(numberOfFormulaFeedingsField)
        contentView.addSubview(sizeOfFormulaFeedingsField)
        
        contentView.addSubview(doneButton)
        contentView.addSubview(cancelButton)
        contentView.addSubview(finishedButton)
        
        if (feedingTypeValue == feedingTypesArray[1]["value"]!){ //breast
            finishedButton.setTitle("Finsihed breast feeding?", for: .normal)
        }
        else if (feedingTypeValue == feedingTypesArray[2]["value"]!){ //formula
            finishedButton.setTitle("Finsihed formula feeding?", for: .normal)
        }
        else if (feedingTypeValue == feedingTypesArray[3]["value"]!){ // breast and formula
            finishedButton.setTitle("Finsihed breast or formula feeding?", for: .normal)
        }
        
        layoutViews()
        
    }
    
    override func viewSafeAreaInsetsDidChange() {
        // ... your layout code here
        layoutViews()
    }
    
    func layoutViews(){
        
        mainScrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainScrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true //Utilities.sharedInstance.SafeAreaTopInset() + (self.navigationController?.navigationBar.frame.size.height ?? 0)
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
        
        insertLabel.topAnchor.constraint(equalTo: childImage.bottomAnchor, constant: 20).isActive = true
        insertLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        insertLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9).isActive = true
        
        //        numberOfBreastFeedingsField.topAnchor.constraint(equalTo: foodTypeField.bottomAnchor, constant: 23).isActive = true
        numberOfBreastFeedingsField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.65).isActive = true
        numberOfBreastFeedingsField.heightAnchor.constraint(equalToConstant: CGFloat(fieldsHeightConstant)).isActive = true
        numberOfBreastFeedingsField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        sizeOfBreastFeedingsField.topAnchor.constraint(equalTo: numberOfBreastFeedingsField.bottomAnchor, constant: 23).isActive = true
        sizeOfBreastFeedingsField.widthAnchor.constraint(equalTo: numberOfBreastFeedingsField.widthAnchor).isActive = true
        sizeOfBreastFeedingsField.centerXAnchor.constraint(equalTo: numberOfBreastFeedingsField.centerXAnchor).isActive = true
        sizeOfBreastFeedingsField.heightAnchor.constraint(equalTo: numberOfBreastFeedingsField.heightAnchor).isActive = true
        
        //        numberOfFormulaFeedingsField.topAnchor.constraint(equalTo: sizeOfBreastFeedingsField.bottomAnchor, constant: 23).isActive = true
        numberOfFormulaFeedingsField.widthAnchor.constraint(equalTo: numberOfBreastFeedingsField.widthAnchor).isActive = true
        numberOfFormulaFeedingsField.centerXAnchor.constraint(equalTo: numberOfBreastFeedingsField.centerXAnchor).isActive = true
        numberOfFormulaFeedingsField.heightAnchor.constraint(equalTo: numberOfBreastFeedingsField.heightAnchor).isActive = true
        
        sizeOfFormulaFeedingsField.topAnchor.constraint(equalTo: numberOfFormulaFeedingsField.bottomAnchor, constant: 23).isActive = true
        sizeOfFormulaFeedingsField.widthAnchor.constraint(equalTo: numberOfBreastFeedingsField.widthAnchor).isActive = true
        sizeOfFormulaFeedingsField.centerXAnchor.constraint(equalTo: numberOfBreastFeedingsField.centerXAnchor).isActive = true
        sizeOfFormulaFeedingsField.heightAnchor.constraint(equalTo: numberOfBreastFeedingsField.heightAnchor).isActive = true
        
        doneButton.widthAnchor.constraint(equalTo: numberOfBreastFeedingsField.widthAnchor).isActive = true
        doneButton.centerXAnchor.constraint(equalTo: numberOfBreastFeedingsField.centerXAnchor).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: CGFloat(fieldsHeightConstant)).isActive = true
        
        cancelButton.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 7).isActive = true
        cancelButton.widthAnchor.constraint(equalTo: doneButton.widthAnchor).isActive = true
        cancelButton.centerXAnchor.constraint(equalTo: doneButton.centerXAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalTo: doneButton.heightAnchor, multiplier: 0.5).isActive = true
        
        finishedButton.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 50).isActive = true
        finishedButton.widthAnchor.constraint(equalTo: doneButton.widthAnchor).isActive = true
        finishedButton.centerXAnchor.constraint(equalTo: doneButton.centerXAnchor).isActive = true
        finishedButton.heightAnchor.constraint(equalTo: doneButton.heightAnchor, multiplier: 0.5).isActive = true
        
        updateDynamicFields()
        
        contentView.bottomAnchor.constraint(equalTo: finishedButton.bottomAnchor, constant: 10).isActive = true
        
        view.layoutIfNeeded()
        
        childImage.layer.cornerRadius = 15
        doneButton.layer.cornerRadius = 15
        
    }
    
    func updateDynamicFields(){
        
        if(numberOfBreastFeedingsFieldTopAnchor != nil){
            numberOfBreastFeedingsFieldTopAnchor.isActive = false
        }
        if(numberOfFormulaFeedingsFieldTopAnchor != nil){
            numberOfFormulaFeedingsFieldTopAnchor.isActive = false
        }
        if(doneButtonTopAnchor != nil){
            doneButtonTopAnchor.isActive = false
        }
        
        if (feedingTypeValue == feedingTypesArray[1]["value"]!){ //breast
            
            numberOfBreastFeedingsField.isHidden = false
            sizeOfBreastFeedingsField.isHidden = false
            
            numberOfFormulaFeedingsField.isHidden = true
            sizeOfFormulaFeedingsField.isHidden = true
            
            numberOfBreastFeedingsFieldTopAnchor = numberOfBreastFeedingsField.topAnchor.constraint(equalTo: insertLabel.bottomAnchor, constant: 23)
            doneButtonTopAnchor = doneButton.topAnchor.constraint(equalTo: sizeOfBreastFeedingsField.bottomAnchor, constant: 40)
            
        }
            
        else if (feedingTypeValue == feedingTypesArray[2]["value"]!){ //formula
            
            numberOfBreastFeedingsField.isHidden = true
            sizeOfBreastFeedingsField.isHidden = true
            
            numberOfFormulaFeedingsField.isHidden = false
            sizeOfFormulaFeedingsField.isHidden = false
            
            numberOfFormulaFeedingsFieldTopAnchor = numberOfFormulaFeedingsField.topAnchor.constraint(equalTo: insertLabel.bottomAnchor, constant: 23)
            doneButtonTopAnchor = doneButton.topAnchor.constraint(equalTo: sizeOfFormulaFeedingsField.bottomAnchor, constant: 40)
            
        }
        else if (feedingTypeValue == feedingTypesArray[3]["value"]!){ // breast and formula
            
            numberOfBreastFeedingsField.isHidden = false
            sizeOfBreastFeedingsField.isHidden = false
            
            numberOfFormulaFeedingsField.isHidden = false
            sizeOfFormulaFeedingsField.isHidden = false
            
            numberOfBreastFeedingsFieldTopAnchor = numberOfBreastFeedingsField.topAnchor.constraint(equalTo: insertLabel.bottomAnchor, constant: 23)
            numberOfFormulaFeedingsFieldTopAnchor = numberOfFormulaFeedingsField.topAnchor.constraint(equalTo: sizeOfBreastFeedingsField.bottomAnchor, constant: 23)
            doneButtonTopAnchor = doneButton.topAnchor.constraint(equalTo: sizeOfFormulaFeedingsField.bottomAnchor, constant: 40)
            
        }
        else { //none
            
            numberOfBreastFeedingsField.isHidden = true
            sizeOfBreastFeedingsField.isHidden = true
            
            numberOfFormulaFeedingsField.isHidden = true
            sizeOfFormulaFeedingsField.isHidden = true
            
            doneButtonTopAnchor = doneButton.topAnchor.constraint(equalTo: insertLabel.bottomAnchor, constant: 40)
            
        }
        
        if(numberOfBreastFeedingsFieldTopAnchor != nil){
            numberOfBreastFeedingsFieldTopAnchor.isActive = true
        }
        if(numberOfFormulaFeedingsFieldTopAnchor != nil){
            numberOfFormulaFeedingsFieldTopAnchor.isActive = true
        }
        if(doneButtonTopAnchor != nil){
            doneButtonTopAnchor.isActive = true
        }
        
        self.view.layoutIfNeeded()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showNavigationBar()
        makeNavigationTransparent()
        self.navigationController?.navigationBar.tintColor = mainGreenColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow( notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide( notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
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
    
    @objc func DonePressed(sender: UIButton){
        self.dismiss(animated: true) {}
    }
    
    @objc func finishedPressed(sender: UIButton){
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        var message = ""
        
        if (feedingTypeValue == feedingTypesArray[1]["value"]!){ //breast
            message = "Finished breast feeding?"
            alert.addAction(UIAlertAction(title: "Done breast feeding", style: .default, handler: { action in
                self.updateChild(value: self.feedingTypesArray[4]["value"]!)
            }))
        }
        else if (feedingTypeValue == feedingTypesArray[2]["value"]!){ //formula
            message = "Finished formula feeding?"
            alert.addAction(UIAlertAction(title: "Done formula feeding", style: .default, handler: { action in
                self.updateChild(value: self.feedingTypesArray[4]["value"]!)
            }))
        }
        else if (feedingTypeValue == feedingTypesArray[3]["value"]!){ // breast and formula
            message = "Finished breast or formula feeding?"
            alert.addAction(UIAlertAction(title: "Done breast feeding", style: .default, handler: { action in
                self.updateChild(value: self.feedingTypesArray[2]["value"]!)
            }))
            alert.addAction(UIAlertAction(title: "Done formula feeding", style: .default, handler: { action in
                self.updateChild(value: self.feedingTypesArray[1]["value"]!)
            }))
            alert.addAction(UIAlertAction(title: "Done breast and formula feeding", style: .default, handler: { action in
                self.updateChild(value: self.feedingTypesArray[4]["value"]!)
            }))
        }
        
        alert.message = message
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func updateChild(value: String){
        
        var params = [:] as [String : Any]
        
        if (appChild().id != -1){
            params["id"] = appChild().id
        }
        
        params["infantFeeding"] = value
        
        SVProgressHUD.show()
        RequestHelper.sharedInstance.updateChild(params: params) { (response) in
            if(response["success"] as? Bool == true){
                
                if (appChild().infantFeeding == self.feedingTypesArray[4]["value"]!){ //DONE
                    self.dismiss(animated: true) {}
                }
                else{
                    self.feedingTypeValue = appChild().infantFeeding
                    self.updateDynamicFields()
                }
                
                SVProgressHUD.dismiss()
                
            }
            else{
                SVProgressHUD.showError(withStatus: response["message"] as? String)
            }
        }
    }
    
    //0->gender, 1->weight, 2->height, 3-> Food Type
    //4-> numberOfFeedingsField 5-> sizeOfFeedingsField 6-> numberOfBreastFeedingsField 7-> sizeOfBreastFeedingsField 8-> numberOfFormulaFeedingsField 9-> sizeOfFormulaFeedingsField
    //(4 6 8 are number of serings) (5 7 9 are size of servings)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        if(pickerView.tag == 6 || pickerView.tag == 7 || pickerView.tag == 8 || pickerView.tag == 9){
            return 1
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if(pickerView.tag == 4 || pickerView.tag == 6 || pickerView.tag == 8){
            return numberOfFeedingsArray.count
        }
        else if(pickerView.tag == 5 || pickerView.tag == 7 || pickerView.tag == 9){
            return sizeOfFeedingsArray.count
        }
        
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if(pickerView.tag == 4 || pickerView.tag == 6 || pickerView.tag == 8){
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
        
        
        if(pickerView.tag == 6){
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
    
    func setDailyInput(skipped: Bool){
        var params = [String: Any]()
        
        var numberOfBreastFeedings = 0
        if(numberOfBreastFeedingsField.text == "5+"){
            numberOfBreastFeedings = 5
        }
        else if (numberOfBreastFeedingsField.text != ""){
            numberOfBreastFeedings = Int(numberOfBreastFeedingsField.text!)!
        }
        
        var numberOfFormulaFeedings = 0
        if(numberOfFormulaFeedingsField.text == "5+"){
            numberOfFormulaFeedings = 5
        }
        else if (numberOfFormulaFeedingsField.text != ""){
            numberOfFormulaFeedings = Int(numberOfFormulaFeedingsField.text!)!
        }
        
        params["mealPlan"] = ["id": mealPlanId]
        params["numberOfBreastFeedings"] = numberOfBreastFeedings
        params["sizeOfBreastFeedingsAvg"] = (breastFeedingSizeMin + breastFeedingSizeMax)/2
        params["numberOfFormulaFeedings"] = numberOfFormulaFeedings
        params["sizeOfFormulaFeedingsAvg"] = (formulaFeedingSizeMin + formulaFeedingSizeMax)/2
        params["skipped"] = skipped
        
        SVProgressHUD.show()
        RequestHelper.sharedInstance.setDailyInput(params: params) { (response) in
            
            if(response["success"] as? Bool == true){
                
                SVProgressHUD.dismiss()
                self.dismiss(animated: true) {}
                
            }
            else{
                SVProgressHUD.showError(withStatus: response["message"] as? String)
            }
            
        }
        
        
    }
    
    @objc func cancelPressed(sender: UIButton){
        setDailyInput(skipped: true)
    }
    
    @objc func donePressed(sender: UIButton){
        
        if(numberOfBreastFeedingsField.text == "" && sizeOfBreastFeedingsField.text == "" && numberOfFormulaFeedingsField.text == "" && sizeOfFormulaFeedingsField.text == "" ){
            SVProgressHUD.showInfo(withStatus: "Please fill at least one field")
            return
        }
        
        setDailyInput(skipped: false)
    }
    
}
