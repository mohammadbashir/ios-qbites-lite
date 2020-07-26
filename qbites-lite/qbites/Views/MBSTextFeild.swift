//
//  MBSTextFeild.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 10/9/19.
//  Copyright © 2019 Mohammad Bashir sidani. All rights reserved.
//

import Foundation
import UIKit

class MBSTextField: UIView {
    
    let textImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = ContentMode.scaleAspectFit
        //        imageView.backgroundColor = UIColor.green
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.font = mainFont(size: 14)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwordButton: UIButton = {
        let button = UIButton()
        //        button.backgroundColor = UIColor.blue
        button.setImage(UIImage(named: "PasswordUnveil") , for: UIControl.State.normal)
        button.addTarget(self, action: #selector(UnSecureTextEntry( sender:)),for: .touchDown)
        button.addTarget(self, action: #selector(SecureTextEntry( sender:)),for: .touchUpInside)
        button.addTarget(self, action: #selector(SecureTextEntry( sender:)),for: .touchUpOutside)
        button.addTarget(self, action: #selector(SecureTextEntry( sender:)),for: .touchDragOutside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let bottomBorder: UIView = {
        let view = UIView()
        view.backgroundColor = mainUltraLightGrayColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var inputType = String()
    
    func initwith(inputType: String, logo:UIImage, placeholder: String){
        
        self.inputType = inputType
        
        self.addSubview(textImage)
        textImage.image = logo
        
        if(inputType == "Field" || inputType == "Password"){
            self.addSubview(textField)
        }
        
        if(inputType == "Password"){
            self.addSubview(passwordButton)
            textField.isSecureTextEntry = true
        }
        
        self.addSubview(bottomBorder)
        
        layoutViews()
        
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: mainGrayColor])
        
    }
    
    func layoutViews(){
        
        textImage.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        textImage.topAnchor.constraint(equalTo: self.topAnchor, constant:0).isActive = true
        textImage.widthAnchor.constraint(equalToConstant: 15).isActive = true
        textImage.heightAnchor.constraint(equalTo: self.heightAnchor, constant:0).isActive = true
        
        if(inputType == "Field" || inputType == "Password"){
            textField.leftAnchor.constraint(equalTo: textImage.rightAnchor, constant: 10).isActive = true
            textField.topAnchor.constraint(equalTo: self.topAnchor, constant:0).isActive = true
            textField.rightAnchor.constraint(equalTo: self.rightAnchor, constant:0).isActive = true
            textField.heightAnchor.constraint(equalTo: self.heightAnchor, constant:0).isActive = true
        }
        
        if(inputType == "Password"){
            passwordButton.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            passwordButton.topAnchor.constraint(equalTo: self.topAnchor, constant:0).isActive = true
            passwordButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
            passwordButton.heightAnchor.constraint(equalTo: self.heightAnchor, constant:0).isActive = true
        }
        
        bottomBorder.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        bottomBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant:0).isActive = true
        bottomBorder.widthAnchor.constraint(equalTo: self.widthAnchor, constant:0).isActive = true
        bottomBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    @objc func SecureTextEntry(sender: UIButton){
        textField.isSecureTextEntry = true
    }
    
    @objc func UnSecureTextEntry(sender: UIButton){
        textField.isSecureTextEntry = false
    }
    
}
