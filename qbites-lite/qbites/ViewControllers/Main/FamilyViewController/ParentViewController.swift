//
//  ParentViewController.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 11/2/19.
//  Copyright © 2019 Mohammad Bashir sidani. All rights reserved.
//

import Foundation
import UIKit
import CountryPicker
import SVProgressHUD
import SkyFloatingLabelTextField

class ParentViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, CountryPickerDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    lazy var selectedCountryCode = appParent().nationality2DigitCode
    
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
    
    let parentImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
//        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var countryPicker: CountryPicker = {

        let picker = CountryPicker()
        picker.exeptCountriesWithCodes = ["IL"] //except country
        picker.countryPickerDelegate = self
        picker.showPhoneNumbers = false

        return picker

    }()

    let numberToolbar: UIToolbar = {

        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()

        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(ToolbarDonePressed))
        //        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(DateToolBarCancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        return toolBar

    }()
    
    @objc func ToolbarDonePressed(){
        self.view.endEditing(true)
    }
    
    lazy var genderPickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    lazy var parentField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        Utilities.sharedInstance.styleSkyField(field: field, color: .black)
        field.lineColor = mainGreenColor
        field.selectedLineColor = mainGreenColor
        field.placeholder = "Parent"
        field.tag = 0
        field.delegate = self
        
        field.inputView = genderPickerView
        field.inputAccessoryView = numberToolbar
        
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var firstName: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        Utilities.sharedInstance.styleSkyField(field: field, color: .black)
        field.lineColor = mainGreenColor
        field.selectedLineColor = mainGreenColor
        field.placeholder = "First Name"
        field.tag = 1
        field.delegate = self
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var lastName: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        Utilities.sharedInstance.styleSkyField(field: field, color: .black)
        field.lineColor = mainGreenColor
        field.selectedLineColor = mainGreenColor
        field.placeholder = "Last Name"
        field.tag = 2
        field.delegate = self
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
//    lazy var nationalityField: SkyFloatingLabelTextField = {
//        let field = SkyFloatingLabelTextField()
//        Utilities.sharedInstance.styleSkyField(field: field, color: .black)
//        field.lineColor = mainGreenColor
//        field.selectedLineColor = mainGreenColor
//        field.placeholder = "Nationality"
//        field.tag = 3
//        field.delegate = self
//
//        field.inputView = countryPicker
//        field.inputAccessoryView = numberToolbar
//
//        field.translatesAutoresizingMaskIntoConstraints = false
//        return field
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(EditSavePressed))
        editMode(isEdit: false)
        
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(contentView)
        
        contentView.addSubview(parentImage)
        contentView.addSubview(parentField)
        contentView.addSubview(firstName)
        contentView.addSubview(lastName)
//        contentView.addSubview(nationalityField)
        
        if(appParent().parentType == "FATHER"){
            parentImage.image = UIImage(named: "father")
        }
        else{
            parentImage.image = UIImage(named: "mother")
        }
        
        firstName.text = appParent().firstName
        lastName.text = appParent().lastName
        
        if(appParent().parentType == "FATHER"){
            parentField.text = "Dad"
        }
        else{
            parentField.text = "Mom"
        }
//        nationalityField.text = appParent().nationalityName
        
    }
    
    override func viewSafeAreaInsetsDidChange() {
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
        
        parentImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        parentImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        parentImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4).isActive = true
        parentImage.heightAnchor.constraint(equalTo: parentImage.widthAnchor, multiplier: 1).isActive = true
        
        firstName.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        firstName.topAnchor.constraint(equalTo: parentImage.bottomAnchor, constant:23).isActive = true
        firstName.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.65).isActive = true
        firstName.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        lastName.topAnchor.constraint(equalTo: firstName.bottomAnchor, constant:23).isActive = true
        lastName.centerXAnchor.constraint(equalTo: firstName.centerXAnchor).isActive = true
        lastName.widthAnchor.constraint(equalTo: firstName.widthAnchor, multiplier: 1).isActive = true
        lastName.heightAnchor.constraint(equalTo: firstName.heightAnchor).isActive = true
        
        parentField.topAnchor.constraint(equalTo: lastName.bottomAnchor, constant: 23).isActive = true
        parentField.centerXAnchor.constraint(equalTo: firstName.centerXAnchor).isActive = true
        parentField.widthAnchor.constraint(equalTo: firstName.widthAnchor).isActive = true
        parentField.heightAnchor.constraint(equalTo: firstName.heightAnchor).isActive = true
        
//        nationalityField.topAnchor.constraint(equalTo: parentField.bottomAnchor, constant: 23).isActive = true
//        nationalityField.centerXAnchor.constraint(equalTo: firstName.centerXAnchor).isActive = true
//        nationalityField.widthAnchor.constraint(equalTo: firstName.widthAnchor).isActive = true
//        nationalityField.heightAnchor.constraint(equalTo: firstName.heightAnchor).isActive = true
        
        contentView.bottomAnchor.constraint(equalTo: parentField.bottomAnchor, constant: 10).isActive = true
        
        view.layoutIfNeeded()
        
        parentImage.layer.cornerRadius = 15
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showNavigationBar()
        makeNavigationTransparent()
        self.navigationController?.navigationBar.tintColor = .black//mainLightBlueColor//.white
        
    }
    
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
//        nationalityField.text = name
//        selectedCountryCode = countryCode
    }
    
    let parentRoles = ["Dad", "Mom"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return parentRoles.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return parentRoles[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        parentField.text = parentRoles[row]
        
        if(parentRoles[row] == "Dad"){
            parentImage.image = UIImage(named: "father")
        }
        else{
            parentImage.image = UIImage(named: "mother")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    @objc func EditSavePressed(){
        
        if(self.navigationItem.rightBarButtonItem?.title == "Edit"){
            self.navigationItem.rightBarButtonItem?.title = "Save"
            editMode(isEdit: true)
        }
        else if (self.navigationItem.rightBarButtonItem?.title == "Save"){
            
            if(firstName.text == ""){
                SVProgressHUD.showInfo(withStatus: "First name cannot be empty")
            }
            else if (firstName.text!.count < 3){
                SVProgressHUD.showInfo(withStatus: "First name is too short")
            }
            else if(lastName.text == ""){
                SVProgressHUD.showInfo(withStatus: "Last name cannot be empty")
            }
            else if (lastName.text!.count < 3){
                SVProgressHUD.showInfo(withStatus: "Last name is too short")
            }
            else if(parentField.text == ""){
                SVProgressHUD.showInfo(withStatus: "Parent role is required")
            }
//            else if(nationalityField.text == "" || selectedCountryCode == ""){
//                SVProgressHUD.showInfo(withStatus: "Nationality is required")
//            }
            else{
                
                var params = [:] as [String : Any]
                params["id"] = appParent().id
                params["firstName"] = firstName.text
                params["lastName"] = lastName.text
                params["name"] = firstName.text! + " " + lastName.text!
                
                if(parentField.text == "Dad"){
                    params["parentType"] = "FATHER"
                }
                else{
                    params["parentType"] = "MOTHER"
                }
                
                
//                params["nationalityName"] = nationalityField.text
                params["nationality2DigitCode"] = selectedCountryCode
                
                SVProgressHUD.show()
                RequestHelper.sharedInstance.updateParent(params: params) { (response) in
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
            

        }
        
    }
    
    func editMode(isEdit: Bool){
        
        self.view.endEditing(true)
        
        firstName.isUserInteractionEnabled = isEdit
        lastName.isUserInteractionEnabled = isEdit
        parentField.isUserInteractionEnabled = isEdit
//        nationalityField.isUserInteractionEnabled = isEdit
        
    }
}
