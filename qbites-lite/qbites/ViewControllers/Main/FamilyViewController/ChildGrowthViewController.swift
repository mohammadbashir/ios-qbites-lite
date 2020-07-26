//
//  ChildGrowthViewController.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 4/25/20.
//  Copyright © 2020 Mohammad Bashir sidani. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import SkyFloatingLabelTextField

class ChildGrowthViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var date = Date()
    
    let heightUnitDict = ["US": "inch", "Normal": "cm"]
    let weightUnitDict = ["US": "Pound - Ounce", "Normal": "kg"]
    
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
        label.text = "Please indicate the updated weight and height for " + appChild().name
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var dateField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        Utilities.sharedInstance.styleSkyField(field: field, color: .black)
        field.lineColor = mainGreenColor
        field.selectedLineColor = mainGreenColor
        field.placeholder = "Date of measurment"
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
        button.setTitle("skip", for: .normal)
        button.setTitleColor(mainGreenColor, for: .normal)
        button.titleLabel?.font =  mainFont(size: 15)
        button.addTarget(self, action: #selector(cancelPressed( sender:)),for: .touchUpInside)
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
    
    @objc func ToolbarDonePressed(){
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utilities.sharedInstance.applyBlueGradient(view: self.view)
        
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(contentView)
        
        contentView.addSubview(childImage)
        contentView.addSubview(insertLabel)
        
        contentView.addSubview(dateField)
        contentView.addSubview(weightField)
        contentView.addSubview(heightField)
        
        contentView.addSubview(doneButton)
        contentView.addSubview(cancelButton)
        
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
        
        dateField.topAnchor.constraint(equalTo: insertLabel.bottomAnchor, constant: 23).isActive = true
        dateField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.65).isActive = true
        dateField.heightAnchor.constraint(equalToConstant: CGFloat(fieldsHeightConstant)).isActive = true
        dateField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        weightField.topAnchor.constraint(equalTo: dateField.bottomAnchor, constant: 23).isActive = true
        weightField.widthAnchor.constraint(equalTo: dateField.widthAnchor).isActive = true
        weightField.centerXAnchor.constraint(equalTo: dateField.centerXAnchor).isActive = true
        weightField.heightAnchor.constraint(equalTo: dateField.heightAnchor).isActive = true
        
        heightField.topAnchor.constraint(equalTo: weightField.bottomAnchor, constant: 23).isActive = true
        heightField.widthAnchor.constraint(equalTo: dateField.widthAnchor).isActive = true
        heightField.centerXAnchor.constraint(equalTo: dateField.centerXAnchor).isActive = true
        heightField.heightAnchor.constraint(equalTo: dateField.heightAnchor).isActive = true
        
        doneButton.topAnchor.constraint(equalTo: heightField.bottomAnchor, constant: 50).isActive = true
        doneButton.widthAnchor.constraint(equalTo: dateField.widthAnchor).isActive = true
        doneButton.centerXAnchor.constraint(equalTo: dateField.centerXAnchor).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: CGFloat(fieldsHeightConstant)).isActive = true
        
        cancelButton.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 7).isActive = true
        cancelButton.widthAnchor.constraint(equalTo: doneButton.widthAnchor).isActive = true
        cancelButton.centerXAnchor.constraint(equalTo: doneButton.centerXAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalTo: doneButton.heightAnchor, multiplier: 0.5).isActive = true
        
        contentView.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 10).isActive = true
        
        view.layoutIfNeeded()
        
        childImage.layer.cornerRadius = 15
        doneButton.layer.cornerRadius = 15
        
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
    
    
    //0->gender, 1->weight, 2->height, 3-> Food Type
    //4-> numberOfFeedingsField 5-> sizeOfFeedingsField 6-> dateField 7-> weightField 8-> heightField 9-> sizeOfFormulaFeedingsField
    //(4 6 8 are number of serings) (5 7 9 are size of servings)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        if(pickerView.tag == 1){
            
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
        
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if(pickerView.tag == 1){
            
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
        
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if(pickerView.tag == 1){
            
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
        
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        if(pickerView.tag == 1){
            
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
        
    }
    
    @objc func dateChanged(sender: UIDatePicker){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd yyyy"
        
        dateField.text = formatter.string(from: sender.date)
        
        date = sender.date
    }
    
    @objc func cancelPressed(sender: UIButton){
        self.dismiss(animated: true) { }
    }
    
    @objc func donePressed(sender: UIButton){
        
        if(weightField.text == "" || heightField.text == "" || dateField.text == ""){
            SVProgressHUD.showInfo(withStatus: "Plese fill all the fields before submitting!")
            return
        }
        
        var message = "Are you sure that on " + dateField.text! + ", " + appChild().name
        message = message + " was " + weightField.text! + " and " + heightField.text!
        message = message + "? Once added these values can't be edited"
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let someAction = UIAlertAction(title: "Yes", style: .default, handler: { action in
            //do the request here..
            //get the new child info here..
            //dismiss
            
            var params = [String: Any]()
            params["child"] = ["id": appChild().id]
            
            if(appParent().isUSMetrics){ //convertion of us metrics to normal (weight, heights sizes)

                //5 pounds 5 ounces
                let poundsCount = Double(self.weightField.text!.components(separatedBy: " ")[0])!
                let ouncesCount = Double(self.weightField.text!.components(separatedBy: " ")[2])!

                let weightCount = (poundsCount * 0.453592) + (ouncesCount * 0.0283495)
                params["weight"] = weightCount

                //1.1 inches
                let heightString = self.heightField.text!.components(separatedBy: " ")[0]
                let heightDouble = Double(heightString)! * 2.54
                params["height"] = heightDouble

            }
            else{

                // 1.1 kg
                let weightString = self.weightField.text!.components(separatedBy: " ")[0]
                params["weight"] = Double(weightString)

                //1.1 cm
                let heightString = self.heightField.text!.components(separatedBy: " ")[0]
                params["height"] = Double(heightString)

            }
            
            let date = self.dateField.text!.asDate
            let dateData = date.toString(withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSS")
            params["date"] = dateData + "+0000"
            
            SVProgressHUD.show()
            RequestHelper.sharedInstance.addChildGrowthInfo(params: params) { (response) in
                if(response["success"] as? Bool == true){
                    
                    RequestHelper.sharedInstance.getFamily { (response2) in
                        if(response2["success"] as? Bool == true){
                            
                            SVProgressHUD.dismiss()
                            self.dismiss(animated: true) {
                                //let the childVC update here
                                GlobalChildViewController?.updateFields()
                            }
                        }
                        else{
                            SVProgressHUD.showError(withStatus: response["message"] as? String)
                        }
                    }
                    
                    
                }
                else{
                    SVProgressHUD.showError(withStatus: response["message"] as? String)
                }
            }
            
            
        })
        alert.addAction(someAction)
        
        let halfAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
        })
        alert.addAction(halfAction)
        
        self.present(alert, animated: true) { }
        
    }
    
}
