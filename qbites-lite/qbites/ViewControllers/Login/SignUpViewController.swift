//
//  SignUpViewController.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 10/9/19.
//  Copyright © 2019 Mohammad Bashir sidani. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

import SVProgressHUD
import CountryPicker
import SkyFloatingLabelTextField

class SignupViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, CountryPickerDelegate {
    
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
    
    let logoView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
//        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let logoImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "qbites")
        image.layer.cornerRadius = 25
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let loginTitle: UILabel = {
        let label = UILabel()
        label.text = "More About You"
        label.font = mainFontBold(size: 50)
        label.textColor = .black
        label.textAlignment = NSTextAlignment.center
        label.adjustsFontSizeToFitWidth = true;
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let maleButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.tag = 0
        button.addTarget(self, action: #selector(GenderPressed( sender:)),for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let maleImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "male")
        image.isUserInteractionEnabled = false
        
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let femaleButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.tag = 1
        button.addTarget(self, action: #selector(GenderPressed( sender:)),for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let femaleImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "female")
        image.isUserInteractionEnabled = false
        
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var countryPicker: CountryPicker = {

        let picker = CountryPicker()
        picker.exeptCountriesWithCodes = ["IL"] //exept country
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
    
    lazy var firstNameField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        Utilities.sharedInstance.styleSkyField(field: field)
        field.placeholder = "First Name"
        field.tag = 0
        field.delegate = self
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var lastNameField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        Utilities.sharedInstance.styleSkyField(field: field)
        field.placeholder = "Last Name"
        field.tag = 1
        field.delegate = self
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var emailField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        Utilities.sharedInstance.styleSkyField(field: field)
        field.placeholder = "Email Address"
        field.tag = 2
        field.delegate = self
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var passwordField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        Utilities.sharedInstance.styleSkyField(field: field)
        field.isSecureTextEntry = true
        field.placeholder = "Password"
        field.tag = 3
        field.delegate = self
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
//    lazy var nationalityField: SkyFloatingLabelTextField = {
//        let field = SkyFloatingLabelTextField()
//        Utilities.sharedInstance.styleSkyField(field: field)
//        field.placeholder = "Nationality"//.mask(with: mainLightGrayColor)
//        field.tag = 4
//        field.delegate = self
//
//        field.inputView = countryPicker
//        field.inputAccessoryView = numberToolbar
//
//        field.translatesAutoresizingMaskIntoConstraints = false
//        return field
//    }()
    
    let signUpButton: UIButton = {
        let button = UIButton()
//        button.setBackgroundImage(UIImage(named: "BlueButton") , for: UIControl.State.normal)
        button.backgroundColor = mainGreenColor
        let yourAttributes : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : mainFontBold(size: 16),
            NSAttributedString.Key.foregroundColor : UIColor.white]
        let attributeString = NSMutableAttributedString(string: "SIGN UP", attributes: yourAttributes)
        button.setAttributedTitle(attributeString, for: .normal)
        button.addTarget(self, action: #selector(nextPressed( sender:)),for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let privacyAndTermsField: UITextView = {
        let field = UITextView()
        
        let textAttributes : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : mainFont(size: 12),
            NSAttributedString.Key.foregroundColor : mainGreenColor]
        
        let buttonAttributes : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : mainFont(size: 12),
            NSAttributedString.Key.foregroundColor : mainGreenColor,
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
        
        let attributeString = NSMutableAttributedString()
        attributeString.append(NSAttributedString(string: "By signing up, you agree to the\n\n", attributes: textAttributes))
        attributeString.append(NSAttributedString(string: "Privacy Policy", attributes: buttonAttributes))
        attributeString.append(NSAttributedString(string: " and ", attributes: textAttributes))
        attributeString.append(NSAttributedString(string: "Terms of Services", attributes: buttonAttributes))
        
        field.attributedText = attributeString
        
        field.textAlignment = NSTextAlignment.center
        field.isEditable = false
        field.isSelectable = false
        
        field.backgroundColor = .clear
        
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
        
    }()
    
    var gender = ""
    var selectedCountryCode = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
            mainScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight - (self.view.frame.size.height - mainScrollView.frame.size.height), right: 0)
            mainScrollView.scrollIndicatorInsets = mainScrollView.contentInset
        }
    }
    
    @objc func keyboardWillHide(notification: Notification){
        mainScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        mainScrollView.scrollIndicatorInsets = mainScrollView.contentInset
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        Utilities.sharedInstance.applyBlueGradient(view: self.view)
        
        let item = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
        self.navigationController?.navigationBar.tintColor = UIColor.black;
        
        let img = UIImage()
        self.navigationController?.navigationBar.shadowImage = img
        self.navigationController?.navigationBar.setBackgroundImage(img, for: UIBarMetrics.default)
        
        self.view.backgroundColor = UIColor.white
        
        if #available(iOS 11, *) {
            mainScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(contentView)
        
        contentView.addSubview(logoView)
        logoView.addSubview(logoImage)
        
        contentView.addSubview(loginTitle)
        
        contentView.addSubview(maleButton)
        maleButton.addSubview(maleImage)
        
        contentView.addSubview(femaleButton)
        femaleButton.addSubview(femaleImage)
        
//        contentView.addSubview(nationalityField)
        contentView.addSubview(firstNameField)
        contentView.addSubview(lastNameField)
        contentView.addSubview(emailField)
        contentView.addSubview(passwordField)
        contentView.addSubview(signUpButton)
        contentView.addSubview(privacyAndTermsField)
        
        layoutViews()
        
        //Register clicks on privacy & terms text via gestures
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(textViewTapped( sender:)));
        gestureRecognizer.numberOfTapsRequired = 1;
        gestureRecognizer.numberOfTouchesRequired = 1;
        privacyAndTermsField.addGestureRecognizer(gestureRecognizer);
        
    }
    
    func layoutViews(){
        
        mainScrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainScrollView.topAnchor.constraint(equalTo: view.topAnchor, constant:0).isActive = true
        mainScrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mainScrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        contentView.topAnchor.constraint(equalTo: mainScrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: mainScrollView.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: mainScrollView.rightAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor).isActive = true
        
        logoView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        logoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant:45).isActive = true
        logoView.widthAnchor.constraint(equalToConstant: 95).isActive = true
        logoView.heightAnchor.constraint(equalToConstant: 95).isActive = true
        
        logoImage.centerXAnchor.constraint(equalTo: logoView.centerXAnchor, constant: 0).isActive = true
        logoImage.centerYAnchor.constraint(equalTo: logoView.centerYAnchor, constant: 0).isActive = true
        logoImage.widthAnchor.constraint(equalTo: logoView.widthAnchor, multiplier: 1).isActive = true
        logoImage.heightAnchor.constraint(equalTo: logoView.heightAnchor, multiplier: 1).isActive = true
        
        loginTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        loginTitle.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant:0).isActive = true
        loginTitle.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7).isActive = true
        loginTitle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        NSLayoutConstraint(item: maleButton, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 3.5/5.0, constant: 0.0).isActive = true
        maleButton.topAnchor.constraint(equalTo: loginTitle.topAnchor, constant:70).isActive = true
        maleButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        maleButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        maleImage.widthAnchor.constraint(equalTo: maleButton.widthAnchor, multiplier: 0.5).isActive = true
        maleImage.heightAnchor.constraint(equalTo: maleButton.heightAnchor, multiplier: 0.5).isActive = true
        maleImage.centerXAnchor.constraint(equalTo: maleButton.centerXAnchor, constant: 0).isActive = true
        maleImage.centerYAnchor.constraint(equalTo: maleButton.centerYAnchor, constant: 0).isActive = true
        
        NSLayoutConstraint(item: femaleButton, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 6.5/5.0, constant: 0.0).isActive = true
        femaleButton.topAnchor.constraint(equalTo: maleButton.topAnchor, constant:0).isActive = true
        femaleButton.widthAnchor.constraint(equalTo: maleButton.widthAnchor).isActive = true
        femaleButton.heightAnchor.constraint(equalTo: maleButton.heightAnchor).isActive = true
        
        femaleImage.widthAnchor.constraint(equalTo: maleImage.widthAnchor, multiplier: 1).isActive = true
        femaleImage.heightAnchor.constraint(equalTo: maleImage.heightAnchor, multiplier: 1).isActive = true
        femaleImage.centerXAnchor.constraint(equalTo: femaleButton.centerXAnchor, constant: 0).isActive = true
        femaleImage.centerYAnchor.constraint(equalTo: femaleButton.centerYAnchor, constant: 0).isActive = true
        
        firstNameField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        firstNameField.topAnchor.constraint(equalTo: maleButton.bottomAnchor, constant:23).isActive = true
        firstNameField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.65).isActive = true
        firstNameField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        lastNameField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        lastNameField.topAnchor.constraint(equalTo: firstNameField.bottomAnchor, constant:21).isActive = true
        lastNameField.widthAnchor.constraint(equalTo: firstNameField.widthAnchor, multiplier: 1.0).isActive = true
        lastNameField.heightAnchor.constraint(equalTo: firstNameField.heightAnchor).isActive = true
        
        emailField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        emailField.topAnchor.constraint(equalTo: lastNameField.bottomAnchor, constant:21).isActive = true
        emailField.widthAnchor.constraint(equalTo: firstNameField.widthAnchor, multiplier: 1.0).isActive = true
        emailField.heightAnchor.constraint(equalTo: firstNameField.heightAnchor).isActive = true
        
        passwordField.centerXAnchor.constraint(equalTo: emailField.centerXAnchor).isActive = true
        passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant:21).isActive = true
        passwordField.widthAnchor.constraint(equalTo: emailField.widthAnchor, multiplier: 1.0).isActive = true
        passwordField.heightAnchor.constraint(equalTo: emailField.heightAnchor).isActive = true
        
//        nationalityField.centerXAnchor.constraint(equalTo: passwordField.centerXAnchor).isActive = true
//        nationalityField.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant:21).isActive = true
//        nationalityField.widthAnchor.constraint(equalTo: passwordField.widthAnchor, multiplier: 1.0).isActive = true
//        nationalityField.heightAnchor.constraint(equalTo: passwordField.heightAnchor).isActive = true
        
        signUpButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        signUpButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant:30).isActive = true
        signUpButton.widthAnchor.constraint(equalTo: passwordField.widthAnchor, multiplier: 1.0).isActive = true
        signUpButton.heightAnchor.constraint(equalTo: passwordField.heightAnchor).isActive = true
        
        privacyAndTermsField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        privacyAndTermsField.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant:25).isActive = true
        privacyAndTermsField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
        privacyAndTermsField.heightAnchor.constraint(equalToConstant: 55).isActive = true
        privacyAndTermsField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        
        
        self.view.layoutIfNeeded()
        
        maleButton.layer.cornerRadius = maleButton.frame.size.width/2
        femaleButton.layer.cornerRadius = maleButton.frame.size.width/2
        
        signUpButton.layer.cornerRadius = signUpButton.frame.size.height/2
        
        logoView.dropShadow()
        maleButton.dropShadow()
        femaleButton.dropShadow()
        
    }
    
    @objc func textViewTapped(sender: UITapGestureRecognizer) {
        
        let word = UITextView.getWordAtPosition(position: sender.location(in: privacyAndTermsField), textView: privacyAndTermsField);
        
        if (word == "Privacy" || word == "Policy") {
            privacyClicked()
        }
        
        if (word == "Terms" || word == "of" || word == "Services") {
            termsClicked()
        }
    }
    
    func privacyClicked(){
        
        UIApplication.shared.open(URL(string: privacyURL)!)
        
    }
    
    func termsClicked(){
        
        UIApplication.shared.open(URL(string: termsURL)!)
    }
    
    @objc func DateToolBarCancelPressed(){
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField.tag == 0){
            lastNameField.becomeFirstResponder()
        }
        else if(textField.tag == 1){
            passwordField.becomeFirstResponder()
        }
        else if(textField.tag == 2){
            passwordField.becomeFirstResponder()
        }
//        else if(textField.tag == 3){
//            nationalityField.becomeFirstResponder()
//        }
        else if(textField.tag == 4){
            nextPressed(sender: UIButton())
        }
        
        textField.resignFirstResponder();
        return true;
    }
    
    @objc func GenderPressed(sender: UIButton){
        
        if(sender.tag == 0){
            gender = "male"
            
            maleImage.image = UIImage(named: "male")?.mask(with: .white)
            maleButton.backgroundColor = UIColor(rgb: 0x008CCF)
            
            femaleImage.image = UIImage(named: "female")
            femaleButton.backgroundColor = .white
        }
        else if (sender.tag == 1){
            gender = "female"
            
            femaleImage.image = UIImage(named: "female")?.mask(with: .white)
            femaleButton.backgroundColor = UIColor(rgb: 0xFE5C00)
            
            maleImage.image = UIImage(named: "male")
            maleButton.backgroundColor = .white
            
        }
        
    }
    
    @objc func nextPressed(sender: UIButton){
        
        self.dismissKeyboard()
        
//        if(gender == ""){
//            SVProgressHUD.showInfo(withStatus: "Gender is required")
//        }
//        else if (nationalityField.text == ""){
//            SVProgressHUD.showInfo(withStatus: "Nationality is required")
//        }
        if (firstNameField.text == ""){
            SVProgressHUD.showInfo(withStatus: "First name is required")
        }
        else if (lastNameField.text == ""){
            SVProgressHUD.showInfo(withStatus: "Last name is required")
        }
        else if (emailField.text == ""){
            SVProgressHUD.showInfo(withStatus: "Email is required")
        }
        else if (!Utilities.sharedInstance.isValidEmail(testStr: emailField.text!)){
            SVProgressHUD.showInfo(withStatus: "Please insert a valid Email")
        }
        else if (passwordField.text == ""){
            SVProgressHUD.showInfo(withStatus: "Password is required")
        }
        else if (passwordField.text!.count < 6){
            SVProgressHUD.showInfo(withStatus: "Password is too short")
        }
        else{
            //do the firebase new account here
            signup()
        }
    }
    
    func signup(){
        
        SVProgressHUD.show()
        
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { user, error in
            
            if error == nil {
                
                Auth.auth().currentUser?.getIDToken(completion: { (token, error) in
                    if(error == nil){
                        
                        var parentType = "FATHER"
                        if(self.gender == "female"){ parentType = "MOTHER" }
                        
                        RequestHelper.sharedInstance.signup(token: token!, firstName: self.firstNameField.text!, lastName: self.lastNameField.text!, name: self.firstNameField.text! + " " + self.lastNameField.text!, parentType: parentType, nationalityName: "", nationality2DigitCode: self.selectedCountryCode) { (response) in //nationalityName: self.nationalityField.text!
                            
                            if(response["success"] as? Bool == true){
                                
                                Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                                    // Notify the user that the mail has sent or couldn't because of an error.
                                })

                                
                                SVProgressHUD.showSuccess(withStatus: "Sign up successful! Verify your email and login!")
                                _ = self.navigationController?.popViewController(animated: true)
                                
                            }
                            else{
                                SVProgressHUD.showError(withStatus: response["message"] as? String)
                            }
                            
                        }
                        
                    }
                    else{
                        SVProgressHUD.showError(withStatus: error?.localizedDescription)
                    }
                    
//                    FirebaseIDToken = ""
                    Utilities.sharedInstance.clearUserDefaults()
                    try! Auth.auth().signOut()
                    
                })
                
            }
            else{
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
            
//            FirebaseIDToken = ""
            Utilities.sharedInstance.clearUserDefaults()
            try! Auth.auth().signOut()
            
        }
        
    }
    
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        
//        nationalityField.text = name
//        selectedCountryCode = countryCode
    }
    
}
