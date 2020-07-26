//
//  LoginViewController.swift
//
//  Created by Mohammad Bashir sidani on 09/10/18.
//  Copyright © 2019 Mohammad Bashir sidani. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import AVFoundation
import CoreLocation
import Firebase
import FirebaseAuth
import SkyFloatingLabelTextField

class LoginViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
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
        label.text = "Welcome to qbites lite" //"WELCOME TO QBITES!"
        label.font = mainFontBold(size: 50)
        label.textColor = .black
        label.textAlignment = NSTextAlignment.center
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var emailField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        Utilities.sharedInstance.styleSkyField(field: field)
        field.placeholder = "Email Address"
        field.inputAccessoryView = doneToolbar
        field.translatesAutoresizingMaskIntoConstraints = false
        field.tag = 0
        field.delegate = self

        return field
    }()
    
    lazy var passwordField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        Utilities.sharedInstance.styleSkyField(field: field)
        field.placeholder = "Password"
        field.isSecureTextEntry = true
        field.inputAccessoryView = doneToolbar
        field.tag = 1
        field.delegate = self
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        //        button.setBackgroundImage(UIImage(named: "BlueButton") , for: UIControl.State.normal)
        button.backgroundColor = mainGreenColor
        let yourAttributes : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : mainFontBold(size: 16),
            NSAttributedString.Key.foregroundColor : UIColor.white]
        let attributeString = NSMutableAttributedString(string: "LOGIN", attributes: yourAttributes)
        button.setAttributedTitle(attributeString, for: .normal)
        button.addTarget(self, action: #selector(LoginPressed( sender:)),for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        return button
    }()
    
    let forgetPasswordButton: UIButton = {
        let button = UIButton()
        let yourAttributes : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : mainFont(size: 12),
            NSAttributedString.Key.foregroundColor : mainGreenColor,
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
        let attributeString = NSMutableAttributedString(string: "Forgot Password?", attributes: yourAttributes)
        button.setAttributedTitle(attributeString, for: .normal)
        button.addTarget(self, action: #selector(ForgotPassword( sender:)),for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let signupButton: UIButton = {
        let button = UIButton()
        let yourAttributes : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : mainFont(size: 12),
            NSAttributedString.Key.foregroundColor : mainGreenColor,
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
        let attributeString = NSMutableAttributedString(string: "New Here? Sign up", attributes: yourAttributes)
        button.setAttributedTitle(attributeString, for: .normal)
        button.addTarget(self, action: #selector(SignUp( sender:)),for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let doneToolbar: UIToolbar = {
        
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
    
    @objc func ToolbarDonePressed(sender: UIButton){
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideNavigationBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow( notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide( notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        showNavigationBar()
        
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
        contentView.addSubview(emailField)
        contentView.addSubview(passwordField)
        
        contentView.addSubview(signupButton)
        contentView.addSubview(forgetPasswordButton)
        
        //        view.addSubview(facebookButton)
        //        view.addSubview(googleButton)
        contentView.addSubview(loginButton)
        
    }
    
    override func viewSafeAreaInsetsDidChange() {
        // ... your layout code here
        layoutViews()
    }
    
    func layoutViews(){
        
//        [][1] 
        
        mainScrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainScrollView.topAnchor.constraint(equalTo: view.topAnchor, constant:0).isActive = true
        mainScrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mainScrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        contentView.topAnchor.constraint(equalTo: mainScrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: mainScrollView.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: mainScrollView.rightAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor).isActive = true
        
        logoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 45).isActive = true
        logoView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        logoView.widthAnchor.constraint(equalToConstant: 95).isActive = true
        logoView.heightAnchor.constraint(equalToConstant: 95).isActive = true
        
        logoImage.centerXAnchor.constraint(equalTo: logoView.centerXAnchor, constant: 0).isActive = true
        logoImage.centerYAnchor.constraint(equalTo: logoView.centerYAnchor, constant: 0).isActive = true
        logoImage.widthAnchor.constraint(equalTo: logoView.widthAnchor, multiplier: 1).isActive = true
        logoImage.heightAnchor.constraint(equalTo: logoView.heightAnchor, multiplier: 1).isActive = true
        
        loginTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        loginTitle.bottomAnchor.constraint(equalTo: logoImage.bottomAnchor, constant:70).isActive = true
        loginTitle.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8).isActive = true
        loginTitle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        emailField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        emailField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.70).isActive = true
        emailField.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        emailField.topAnchor.constraint(equalTo: loginTitle.bottomAnchor, constant:70).isActive = true

        passwordField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant:20).isActive = true
        passwordField.widthAnchor.constraint(equalTo: emailField.widthAnchor, multiplier: 1.0).isActive = true
        passwordField.heightAnchor.constraint(equalTo: emailField.heightAnchor).isActive = true
        
        loginButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        loginButton.bottomAnchor.constraint(equalTo: forgetPasswordButton.topAnchor, constant:-50).isActive = true
        loginButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        forgetPasswordButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        forgetPasswordButton.bottomAnchor.constraint(equalTo: signupButton.topAnchor, constant:-25).isActive = true
        
        signupButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        signupButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        
        self.view.layoutIfNeeded()
        
        signupButton.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: mainScrollView.frame.size.height - Utilities.sharedInstance.SafeAreaBottomInset() - 10).isActive = true
        
        emailField.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: mainScrollView.frame.size.height/2 - 10).isActive = true
        
        loginButton.layer.cornerRadius = loginButton.frame.size.height/2
        
        logoView.dropShadow()
        
    }
    
    @objc func LoginPressed(sender: UIButton){
        self.view.endEditing(true)
        
        if (emailField.text == ""){
            SVProgressHUD.showInfo(withStatus: "Email is required")
        }
        else if (!Utilities.sharedInstance.isValidEmail(testStr: emailField.text!)){
            SVProgressHUD.showInfo(withStatus: "Please insert a valid Email")
        }
        else if (passwordField.text == ""){
            SVProgressHUD.showInfo(withStatus: "Password is required")
        }
        else {
            login()
        }
        
    }
    
    func login(){
        
        SVProgressHUD.show()

        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (result, error) in
            if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            } else {

                if Auth.auth().currentUser != nil {
                    
                    if(!Auth.auth().currentUser!.isEmailVerified){
                        //user email is not verified, block him with a info message to verify their email
                        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                        })
                        try! Auth.auth().signOut()
                        Utilities.sharedInstance.clearUserDefaults()
                        SVProgressHUD.showInfo(withStatus: "Email not verified, check your inbox to verify your email first and try again!")
                        //Utilities.sharedInstance.logout(message: "Email not verified, please verify your email first and try again!")
                        return
                    }
                    
                    Auth.auth().currentUser?.getIDToken(completion: { (token, error) in
                        if(error == nil){
                            //                            FirebaseIDToken = token!
                            let user = appUser()
                            user.firebaseToken = token!
                            saveAppUser(user: user)
                            
                            Utilities.sharedInstance.populateDefaultUserDefaultsValues()

                            RequestHelper.sharedInstance.login { (response) in
                                if(response["success"] as? Bool == true){
                                    //                                    SVProgressHUD.dismiss()
                                    //
                                    //                                    let mainNavigationController = UINavigationController.init(rootViewController: MainViewController())
                                    //                                    UIApplication.shared.delegate?.window??.rootViewController = mainNavigationController

                                    RequestHelper.sharedInstance.getFamily { (response2) in
                                        if(response2["success"] as? Bool == true){
                                            SVProgressHUD.dismiss()

//                                            let mainNavigationController = UINavigationController.init(rootViewController: MainViewController())
//                                            UIApplication.shared.delegate?.window??.rootViewController = mainNavigationController
                                            Utilities.sharedInstance.handleSubscription()
                                        }
                                        else{
                                            SVProgressHUD.showError(withStatus: response2["message"] as? String)
                                        }
                                    }

                                }
                                else{
                                    SVProgressHUD.showError(withStatus: response["message"] as? String)
                                }
                            }

                        }
                        else{
                            SVProgressHUD.showError(withStatus: error as? String)
                        }
                    })
                }

            }
        }
        
    }
    
    @objc func ForgotPassword(sender: UIButton){
        
        if (emailField.text == ""){
            SVProgressHUD.showInfo(withStatus: "Insert your email first")
        }
        else if (!Utilities.sharedInstance.isValidEmail(testStr: emailField.text!)){
            SVProgressHUD.showInfo(withStatus: "Please insert a valid Email")
        }
        else {

            SVProgressHUD.show()

            Auth.auth().sendPasswordReset(withEmail: emailField.text!) { error in
                if(error != nil){
                    SVProgressHUD.showError(withStatus: error?.localizedDescription)
                }
                else{
                    SVProgressHUD.showSuccess(withStatus: "Check your inbox!")
                }
            }
        }
        
    }
    
    @objc func SignUp(sender: UIButton){
        navigationController?.pushViewController(SignupViewController(), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField.tag == 0){
            passwordField.becomeFirstResponder()
        }
        else if(textField.tag == 1){
            LoginPressed(sender: UIButton())
        }

        textField.resignFirstResponder();
        
        
        return true;
    }
    
}

