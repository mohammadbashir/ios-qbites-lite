////
////  ThoughtCellView.swift
////  Showerthoughts
////
////  Created by Mohammad Bashir sidani on 4/14/20.
////  Copyright © 2020 Mohammad Bashir sidani. All rights reserved.
////
//
//import Foundation
//import UIKit
//import SVProgressHUD
//
//class MealLargeCellView: UIView {
//    
//    var thought = Thought()
//    var isAdCell = false
//    
//    let mainView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    
//    let borderView: UIView = {
//        let view = UIView()
//        view.layer.cornerRadius = 25
//        view.layer.borderColor = mainRedColor.cgColor
//        view.layer.borderWidth = 3
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    
//    let logo: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.image = UIImage(named: "icon")
//        imageView.backgroundColor = mainPurpleColor
//        imageView.contentMode = .scaleAspectFit
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
//    
//    let thoughtLabel: UILabel = {
//        let label = UILabel()
//        label.font = mainFontSemiBold(size: 25)
//        label.numberOfLines = 0
//        label.textAlignment = .center
//        label.textColor = .white
//        label.adjustsFontSizeToFitWidth = true
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    let menu: UIView = {
//        let view = UIView()
//        view.backgroundColor = mainYellowColor
//        view.layer.cornerRadius = menuHeight/2
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    
//    let loveButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "heart-off")?.mask(with: .white), for: .normal)
//        button.addTarget(self, action: #selector(lovePressed( sender:)),for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
//    let copyButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "copy")?.mask(with: .white), for: .normal)
//        button.addTarget(self, action: #selector(copyPressed( sender:)),for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
//    let saveButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "save")?.mask(with: .white), for: .normal)
//        button.addTarget(self, action: #selector(savePressed( sender:)),for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
//    let shareButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "share")?.mask(with: .white), for: .normal)
//        button.addTarget(self, action: #selector(sharePressed( sender:)),for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
//    func initwith(thought: Thought){
//        
//        self.translatesAutoresizingMaskIntoConstraints = false
//        
//        self.thought = thought
//        
//        self.addSubview(mainView)
//        mainView.addSubview(borderView)
//        self.addSubview(logo)
//        mainView.addSubview(thoughtLabel)
//        self.addSubview(menu)
//
//        menu.addSubview(loveButton)
//        menu.addSubview(copyButton)
//        menu.addSubview(saveButton)
//        menu.addSubview(shareButton)
//        
//        if(isAdCell){
//            menu.isHidden = true
//            logo.isHidden = true
//        }
//        else{
//            thoughtLabel.text = thought.label
//        }
//        
//        updateLoveButton()
//        
//        layoutViews()
//        
//    }
//    
//    func layoutViews(){
//        
//        logo.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
//        logo.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
//        logo.heightAnchor.constraint(equalToConstant: logoHeight).isActive = true
//        logo.widthAnchor.constraint(equalToConstant:logoHeight + 40).isActive = true
//        
//        mainView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
//        mainView.topAnchor.constraint(equalTo: self.topAnchor, constant: logoHeight/2 + 15).isActive = true
//        mainView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.95).isActive = true
//        mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -menuHeight/2 - 25).isActive = true
//        
//        borderView.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
//        borderView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
//        borderView.leftAnchor.constraint(equalTo: mainView.leftAnchor).isActive = true
//        borderView.rightAnchor.constraint(equalTo: mainView.rightAnchor).isActive = true
//        
//        thoughtLabel.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 10).isActive = true
//        thoughtLabel.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -10).isActive = true
//        thoughtLabel.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 0).isActive = true
//        thoughtLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -logoHeight/2).isActive = true
//        
//        menu.centerYAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 0).isActive = true
//        menu.centerXAnchor.constraint(equalTo: mainView.centerXAnchor, constant: 0).isActive = true
//        menu.widthAnchor.constraint(equalTo: mainView.widthAnchor, multiplier: 0.6).isActive = true
//        menu.heightAnchor.constraint(equalToConstant: menuHeight).isActive = true
//
//        loveButton.centerYAnchor.constraint(equalTo: menu.centerYAnchor, constant: 0).isActive = true
//        loveButton.heightAnchor.constraint(equalTo: menu.heightAnchor, multiplier: 0.8).isActive = true
//        loveButton.widthAnchor.constraint(equalTo: loveButton.heightAnchor, multiplier: 1.0).isActive = true
//
//        copyButton.centerYAnchor.constraint(equalTo: loveButton.centerYAnchor, constant: 0).isActive = true
//        copyButton.heightAnchor.constraint(equalTo: loveButton.heightAnchor, multiplier: 1.0).isActive = true
//        copyButton.widthAnchor.constraint(equalTo: loveButton.heightAnchor, multiplier: 1.0).isActive = true
//
//        saveButton.centerYAnchor.constraint(equalTo: loveButton.centerYAnchor, constant: 0).isActive = true
//        saveButton.heightAnchor.constraint(equalTo: loveButton.heightAnchor, multiplier: 1.0).isActive = true
//        saveButton.widthAnchor.constraint(equalTo: loveButton.heightAnchor, multiplier: 1.0).isActive = true
//
//        shareButton.centerYAnchor.constraint(equalTo: loveButton.centerYAnchor, constant: 0).isActive = true
//        shareButton.heightAnchor.constraint(equalTo: loveButton.heightAnchor, multiplier: 1.0).isActive = true
//        shareButton.widthAnchor.constraint(equalTo: loveButton.heightAnchor, multiplier: 1.0).isActive = true
//        
//        NSLayoutConstraint(item: loveButton, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: menu, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 0.25, constant: 0).isActive = true
//        NSLayoutConstraint(item: copyButton, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: menu, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 0.75, constant: 0).isActive = true
//        NSLayoutConstraint(item: saveButton, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: menu, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.25, constant: 0).isActive = true
//        NSLayoutConstraint(item: shareButton, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: menu, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.75, constant: 0).isActive = true
//        
//        self.layoutIfNeeded()
//        
//    }
//    
//    @objc func lovePressed(sender: UIButton){
//        
//        if let index = lovedThoguhts.firstIndex(where: {$0.id == thought.id}) {
//            lovedThoguhts.remove(at: index)
//        }
//        else{
//            
//            if(lovedThoguhts.count >= 10){
//                if IAPProducts.store.isProductPurchased(IAPProducts.goPro) {
//                    
//                } else if IAPHelper.canMakePayments() {
//                    mainVC.showBuyAlert()
//                    return
//                } else {
//                    mainVC.showBuyAlert()
//                    return
//                }
//            }
//            
//            lovedThoguhts.append(thought)
//        }
//        
//        updateLoveButton()
//        Utilities.sharedInstance.saveLovedThoughts()
//    }
//    
//    @objc func copyPressed(sender: UIButton){
//        UIPasteboard.general.string = thought.label
//        SVProgressHUD.showSuccess(withStatus: "Copied!")
//    }
//    
//    @objc func savePressed(sender: UIButton){
//        UIImageWriteToSavedPhotosAlbum(thoughtImage(), self, #selector(saveImageComplete(image:err:context:)), nil)
//    }
//    
//    @objc func sharePressed(sender: UIButton){
//        
//        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        
//        let someAction = UIAlertAction(title: "Share Photo", style: .default, handler: { action in
//            let imageShare = [ self.thoughtImage() ]
//            let activityViewController = UIActivityViewController(activityItems: imageShare , applicationActivities: nil)
//            activityViewController.popoverPresentationController?.sourceView = self.parentViewController!.view
//            self.parentViewController!.present(activityViewController, animated: true, completion: nil)
//        })
//        alert.addAction(someAction)
//        
//        let halfAction = UIAlertAction(title: "Share Text", style: .default, handler: { action in
//            let textShare = [ self.thought.label ]
//            let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
//            activityViewController.popoverPresentationController?.sourceView = self.parentViewController!.view
//            self.parentViewController!.present(activityViewController, animated: true, completion: nil)
//        })
//        alert.addAction(halfAction)
//        
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
//            
//        }))
//
//        self.parentViewController!.present(alert, animated: true, completion: {
//            
//        })
//        
//    }
//    
//    @objc func saveImageComplete(image:UIImage, err:NSError, context:UnsafeMutableRawPointer?) {
//        if err.localizedDescription == "" {
//            SVProgressHUD.showSuccess(withStatus: "Saved to camera roll!")
//        } else {
//            let ac = UIAlertController(title: "Save error", message: err.localizedDescription, preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            self.parentViewController!.present(ac, animated: true, completion: nil)
//        }
//    }
//    
//    func thoughtImage() -> UIImage {
//        
////        let picView = UIImageView()
////        picView.contentMode = .scaleAspectFit
////        picView.backgroundColor = mainPurpleColor
////        picView.frame.size = CGSize(width: self.frame.size.height, height: self.frame.size.height)
////
////        menu.isHidden = true
////        picView.image = self.asImage()
////        menu.isHidden = false
////
////        return picView.asImage()
//        
//        self.backgroundColor = mainPurpleColor
//        let image = self.asImage()
//        self.backgroundColor = .clear
//        
//        return image
//        
//    }
//    
//    func updateLoveButton(){
//        
//        if lovedThoguhts.contains(where: { $0.id == thought.id }) {
//            // found
//            loveButton.setImage(UIImage(named: "heart-on"), for: .normal)
//        } else {
//            // not
//            loveButton.setImage(UIImage(named: "heart-off")?.mask(with: .white), for: .normal)
//        }
//        
//    }
//    
//}
