//
//  SubscriptionViewController.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 4/11/20.
//  Copyright © 2020 Mohammad Bashir sidani. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

import SVProgressHUD
import CountryPicker
import SkyFloatingLabelTextField
import StoreKit

class SubscriptionViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
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
    
    let readyLabel: UILabel = {
        let label = UILabel()
        label.text = "Ready?"
        label.font = mainFontBold(size: 30)
        label.textColor = .black
        label.textAlignment = NSTextAlignment.left
        //        label.adjustsFontSizeToFitWidth = true;
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pageTitle: UILabel = {
        let label = UILabel()
        label.text = "Subscribe to qbites today and get access to all of these premium features, customized to your own child"
        label.numberOfLines = 0
        label.font = mainFontBold(size: 24)
        label.textColor = .black
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pageSecondaryTitle: UILabel = {
        let label = UILabel()
        label.text = "Dynamic real-time meal planning and diet assessment, unlimited meal suggestions, easy data entry to track your child’s foods consumed,  the ability to add your own recipes and store your own cookbook, and more! "
        label.numberOfLines = 0
        label.font = mainFont(size: 16)
        label.textColor = .black
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let monthlyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = mainGreenColor
//        button.setTitle("Try 7 days free, then 9.99$ a month", for: UIControl.State.normal)
        button.titleLabel?.font = mainFontBold(size: 14)
        button.titleLabel?.textColor = UIColor.white
        button.tag = 0
        button.addTarget(self, action: #selector(purchaseItem( sender:)),for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let yearlyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = mainGreenColor
//        button.setTitle("Try 7 days free, then 89.99$ a year", for: UIControl.State.normal)
        button.titleLabel?.font = mainFontBold(size: 14)
        button.titleLabel?.textColor = UIColor.white
        button.tag = 1
        button.addTarget(self, action: #selector(purchaseItem( sender:)),for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    let restorePurchuasesButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Restore Purchases", for: UIControl.State.normal)
        button.titleLabel?.font = mainFont(size: 16)
        button.setTitleColor(mainGreenColor, for: .normal)
        button.addTarget(self, action: #selector(restorePurchases( sender:)),for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
        
    }()
    
    let logoutButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Logout", for: UIControl.State.normal)
        button.titleLabel?.font = mainFont(size: 16)
        button.setTitleColor(mainGreenColor, for: .normal)
        button.addTarget(self, action: #selector(Logout( sender:)),for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
        
    }()
    
    var offerTrial = false
    var products: [SKProduct] = []
    
    var shouldRestore = true
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
////        if(offerTrial){
////            monthlyButton.setTitle("Try 7 days free, then 9.99$ a month", for: UIControl.State.normal)
////            yearlyButton.setTitle("Try 7 days free, then 89.99$ a year", for: UIControl.State.normal)
////        }
////        else{
////            monthlyButton.setTitle("Subscribe for 9.99$ a month", for: UIControl.State.normal)
////            yearlyButton.setTitle("Subscribe for 89.99$ a year", for: UIControl.State.normal)
////        }
//
////        getProducts()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GlobalSubscriptionViewController = self
        
        //        GlobalIAPStore.requestProducts{ [weak self] success, products in
        //            guard let self = self else { return }
        //            if success {
        //                self.products = products!
        //            }
        //        }
        
        view.backgroundColor = .white
        
        if #available(iOS 11, *) {
            mainScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(contentView)
        
        contentView.addSubview(logoView)
        logoView.addSubview(logoImage)
        
        contentView.addSubview(readyLabel)
        contentView.addSubview(pageTitle)
        contentView.addSubview(pageSecondaryTitle)
        contentView.addSubview(monthlyButton)
        contentView.addSubview(yearlyButton)
        
        contentView.addSubview(logoutButton)
        contentView.addSubview(restorePurchuasesButton)
        
        layoutViews()
        getProducts()
        
    }
    
    func getProducts(){
        SVProgressHUD.show()
        qbitesProducts.store.requestProducts { [weak self] success, products in
            SVProgressHUD.dismiss()
            guard let self = self else { return }
            guard success else {
                let alertController = UIAlertController(title: "Something's wrong with the connection, please try again", message: nil, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Retry", style: .default))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            self.products = products!
            
            DispatchQueue.main.async {
                if(self.offerTrial){
                    self.monthlyButton.setTitle("Try 7 days free, then $" + self.products[0].price.stringValue +  " a month", for: UIControl.State.normal)
                    self.yearlyButton.setTitle("Try 7 days free, then $" + self.products[1].price.stringValue +  " a year", for: UIControl.State.normal)
                }
                else{
                    self.monthlyButton.setTitle("Subscribe for $" + self.products[0].price.stringValue +  " a month", for: UIControl.State.normal)
                    self.yearlyButton.setTitle("Subscribe for $" + self.products[1].price.stringValue +  " a year", for: UIControl.State.normal)
                }
            }
            
        }
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
        
        readyLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        readyLabel.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant:25).isActive = true
        readyLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9).isActive = true
        readyLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        pageTitle.topAnchor.constraint(equalTo: readyLabel.bottomAnchor, constant: 20).isActive = true
        pageTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        pageTitle.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9).isActive = true
        
        pageSecondaryTitle.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: 30).isActive = true
        pageSecondaryTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        pageSecondaryTitle.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9).isActive = true
        
        monthlyButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        monthlyButton.topAnchor.constraint(equalTo: pageSecondaryTitle.bottomAnchor, constant:45).isActive = true
        monthlyButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9).isActive = true
        monthlyButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        yearlyButton.centerXAnchor.constraint(equalTo: monthlyButton.centerXAnchor, constant: 0).isActive = true
        yearlyButton.topAnchor.constraint(equalTo: monthlyButton.bottomAnchor, constant: 10).isActive = true
        yearlyButton.widthAnchor.constraint(equalTo: monthlyButton.widthAnchor, multiplier: 1).isActive = true
        yearlyButton.heightAnchor.constraint(equalTo: monthlyButton.heightAnchor, multiplier: 1).isActive = true
        
        restorePurchuasesButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        restorePurchuasesButton.bottomAnchor.constraint(equalTo: logoutButton.topAnchor, constant: 0).isActive = true
        restorePurchuasesButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
        restorePurchuasesButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        logoutButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
//        logoutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Utilities.sharedInstance.SafeAreaBottomInset() - 10).isActive = true
        logoutButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        restorePurchuasesButton.topAnchor.constraint(greaterThanOrEqualTo: yearlyButton.bottomAnchor, constant: 50).isActive = true
        
//        logoutButton.bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: view.bottomAnchor, multiplier: 1).isActive = true
        logoutButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        
        self.view.layoutIfNeeded()
        
        logoView.dropShadow()
        monthlyButton.layer.cornerRadius = 10
        yearlyButton.layer.cornerRadius = 10
        
    }
    
//    func privacyClicked(){
//
//        UIApplication.shared.open(URL(string: privacyURL)!)
//
//    }
//
    @objc func purchaseItem(sender: UIButton) {
        
        let index = sender.tag
        
        qbitesProducts.store.buyProduct(products[index], {_,_ in })
        
        //        GlobalIAPStore.buyProduct(products[sender.tag])
        
//        qbitesProducts.store.buyProduct(products[index]) { [weak self] success, productId in
//
//
//        }
    }
    
    @objc func restorePurchases(sender: UIButton) {
        qbitesProducts.store.restorePurchases()
        //        GlobalIAPStore.restorePurchases()
    }
    
    func purchaseRestored(){
        
//        if(shouldRestore){
            confirmSubscription()
//        }
        
//        self.dismiss(animated: true) {
//            GlobalMainViewController?.getSubscriptionStatus()
//        }
    }
    
    func purchaseSuccess() {
        
        confirmSubscription()
        
//                let alertController = UIAlertController(title: "You're all set!",
//                                                        message: "Subscription successful. Enjoy qbites!",
//                                                        preferredStyle: .alert)
//                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//                    self.dismiss(animated: true) {
//                        GlobalMainViewController?.getDailyInputStatus()
//                    }
//                }))
//                self.present(alertController, animated: true, completion: {  })
        
    }
    
    func purchuaseFail(error: String) {
        let alertController = UIAlertController(title: "Purchase unsuccessful", message: error, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
        }))
        self.present(alertController, animated: true, completion: {  })
    }
    
    func confirmSubscription(){
        
        if(!shouldRestore){return}
        
        shouldRestore = false
        
        SVProgressHUD.show()
        RequestHelper.sharedInstance.getSubscriptionInfo { (response) in
            self.shouldRestore = true
            
            if(response["success"] as? Bool == true){
                SVProgressHUD.dismiss()
                let isSubscribed  = response["isSubscribed"] as! Bool
//                let offerTrial  = !(response["usedTrial"] as! Bool)
                
                if(isSubscribed){
                    //continue normally here..
                    let alertController = UIAlertController(title: "You're all set!",
                                                            message: "Subscription successful. Enjoy qbites!",
                                                            preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        self.dismiss(animated: true) {
                            self.loadMainVC()
                        }
                    }))
                    self.present(alertController, animated: true, completion: {  })
                }
                else{
                    //pop up the subscription controller..
//                    let subscriptionVC = SubscriptionViewController()
//                    subscriptionVC.offerTrial = offerTrial
//                    subscriptionVC.modalPresentationStyle = .overFullScreen
//
//
//                    self.present(subscriptionVC, animated: true) {
//
//                    }
                    self.purchuaseFail(error: "")
                }
            }
            else{
                SVProgressHUD.dismiss()
                let alertController = UIAlertController(title: "Something's wrong with the connection, please try again",
                                                        message: nil,
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
                    self.confirmSubscription()
                }))
                self.present(alertController, animated: true, completion: { })
            }
        }
        
    }
    
    
    @objc func Logout(sender: UIButton){
        Utilities.sharedInstance.logout()
    }
    
    func loadMainVC(){
        SVProgressHUD.show()
        RequestHelper.sharedInstance.getFamily { (response) in
            SVProgressHUD.dismiss()
            if(response["success"] as! Bool == true){
                let mainNavigationController = UINavigationController.init(rootViewController: MainViewController())
                UIApplication.shared.keyWindow?.rootViewController = mainNavigationController
            }
            else{
                let alertController = UIAlertController(title: "Something's wrong with the connection, please try again",
                                                        message: nil,
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
                    self.loadMainVC()
                }))
                self.present(alertController, animated: true, completion: { })
            }
            
        }
    }
}
