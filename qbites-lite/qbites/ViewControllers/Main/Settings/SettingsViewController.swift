//
//  SettingsViewController.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 10/10/19.
//  Copyright © 2019 Mohammad Bashir sidani. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import Firebase
import FirebaseAuth
import WebKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    let logoutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = mainOrangeColor
        button.setTitle("Logout", for: UIControl.State.normal)
        button.titleLabel?.font = mainFontBold(size: 16)
        button.titleLabel?.textColor = UIColor.white
        button.addTarget(self, action: #selector(LogoutPressed( sender:)),for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let mainScrollView: UIScrollView = {
        
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
        
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var personalTableView: UITableView = {
        
        let tableView = UITableView()
        //        tableView.backgroundColor = UIColor.green
        tableView.layer.cornerRadius = 10
        tableView.tag = 0
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
        
    }()
    
    lazy var informationTableView: UITableView = {
        
        let tableView = UITableView()
        //        tableView.backgroundColor = UIColor.green
        tableView.layer.cornerRadius = 10
        tableView.tag = 1
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
        
    }()
    
    var personalTableHeightConstraint: NSLayoutConstraint!
    var informationTableHeightConstraint: NSLayoutConstraint!
    var informationCellHeight = 48
    
    var SectionHeaderHeight = 38
    
    let informationCells = ["Privacy Policy", "Terms & Conditions", "About Us", "Contact Us", "FAQ"]
    
    //test
    let personalContainerView = UIView()
    let informationContainerView = UIView()
    
    //textfields
    var oldPasswordField = UITextField()
    var newPasswordField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []
        //        self.view.backgroundColor = UIColor.white
        
        //        self.navigationController?.navigationBar.topItem?.title = ""
        
        self.view.addSubview(logoutButton)
        
        if #available(iOS 11, *) {
            mainScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.view.addSubview(mainScrollView)
        mainScrollView.addSubview(contentView)
        
        contentView.addSubview(personalTableView)
        //        personalTableView.tableHeaderView = personalHeaderView
        //        personalHeaderView.addSubview(personalHeaderLabel)
        
        contentView.addSubview(informationTableView)
        //        informationTableView.tableHeaderView = informationHeaderView
        //        informationHeaderView.addSubview(informationHeaderLabel)
        
        //        layoutViews()
        
    }
    
    override func viewSafeAreaInsetsDidChange() {
        // ... your layout code here
        layoutViews()
    }
    
    func layoutViews(){
        
        logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        logoutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        logoutButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier:0.9, constant: 0).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        mainScrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        mainScrollView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
        mainScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        mainScrollView.bottomAnchor.constraint(equalTo: logoutButton.topAnchor, constant: 0).isActive = true
        
        contentView.topAnchor.constraint(equalTo: mainScrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: mainScrollView.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: mainScrollView.rightAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor).isActive = true
        
        personalTableView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 33).isActive = true
        personalTableView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        personalTableView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9).isActive = true
        
        personalTableHeightConstraint = NSLayoutConstraint(item: personalTableView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 10000)//.isActive = true
        NSLayoutConstraint.activate([personalTableHeightConstraint])
        
        //        personalHeaderView.widthAnchor.constraint(equalTo: personalTableView.widthAnchor, multiplier: 1.0).isActive = true
        //        personalHeaderView.heightAnchor.constraint(equalToConstant: CGFloat(SectionHeaderHeight)).isActive = true//38
        //
        //        personalHeaderLabel.leftAnchor.constraint(equalTo: personalHeaderView.leftAnchor, constant: 15).isActive = true
        //        personalHeaderLabel.bottomAnchor.constraint(equalTo: personalHeaderView.bottomAnchor, constant: -10).isActive = true
        
        
        informationTableView.topAnchor.constraint(equalTo: personalTableView.bottomAnchor, constant: 33).isActive = true
        //        informationTableView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 33).isActive = true
        informationTableView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        informationTableView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9).isActive = true
        
        informationTableHeightConstraint = NSLayoutConstraint(item: informationTableView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 10000)//.isActive = true
        NSLayoutConstraint.activate([informationTableHeightConstraint])
        informationTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        
        //        informationHeaderView.widthAnchor.constraint(equalTo: informationTableView.widthAnchor, multiplier: 1.0).isActive = true
        //        informationHeaderView.heightAnchor.constraint(equalToConstant: CGFloat(SectionHeaderHeight)).isActive = true//38
        
        //        informationHeaderLabel.leftAnchor.constraint(equalTo: informationHeaderView.leftAnchor, constant: 15).isActive = true
        //        informationHeaderLabel.bottomAnchor.constraint(equalTo: informationHeaderView.bottomAnchor, constant: -10).isActive = true
        
        self.view.layoutIfNeeded()
        
        logoutButton.layer.cornerRadius = logoutButton.frame.size.height/2
        
        personalTableHeightConstraint = NSLayoutConstraint(item: personalTableView, attribute: .height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: calculateTableSize(table: personalTableView))
        NSLayoutConstraint.activate([personalTableHeightConstraint])
        //
        informationTableHeightConstraint = NSLayoutConstraint(item: informationTableView, attribute: .height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: calculateTableSize(table: informationTableView))
        NSLayoutConstraint.activate([informationTableHeightConstraint])
        
        self.view.layoutIfNeeded()
        
        personalContainerView.frame = personalTableView.frame
        personalContainerView.backgroundColor = UIColor.white
        personalContainerView.layer.cornerRadius = personalTableView.layer.cornerRadius
        personalContainerView.layer.shadowColor = UIColor.black.cgColor
        personalContainerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        personalContainerView.layer.shadowOpacity = 0.1
        personalContainerView.layer.shadowRadius = 10
        contentView.insertSubview(personalContainerView, belowSubview: personalTableView)
        
        informationContainerView.frame = informationTableView.frame
        informationContainerView.backgroundColor = UIColor.white
        informationContainerView.layer.cornerRadius = informationTableView.layer.cornerRadius
        informationContainerView.layer.shadowColor = UIColor.black.cgColor
        informationContainerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        informationContainerView.layer.shadowOpacity = 0.1
        //        settingsContainerView.layer.shadowRadius = 10
        contentView.insertSubview(informationContainerView, belowSubview: informationTableView)
        
    }
    
    @objc func LogoutPressed(sender: UIButton){
        
        let actionSheetController = UIAlertController(title: "Are you sure you want to logout?", message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        actionSheetController.addAction(cancelActionButton)
        
        let LogoutAlertButton = UIAlertAction(title: "Logout", style: .destructive) { action -> Void in
            
            //Logout Code Here
            Utilities.sharedInstance.logout()
        }
        actionSheetController.addAction(LogoutAlertButton)
        
        self.present(actionSheetController, animated: true, completion: nil)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(tableView.tag == 0){
            return 4
        }
        else{
            return informationCells.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(tableView.tag == 0){
            
            if(indexPath.row == 0){
                self.navigationController?.pushViewController(CuisinePreferencesViewController(), animated: true)
            }
            else if(indexPath.row == 1){
                SVProgressHUD.show()
                
                Auth.auth().sendPasswordReset(withEmail: appUser().email ) { error in
                    if(error != nil){
                        SVProgressHUD.showError(withStatus: error?.localizedDescription)
                    }
                    else{
                        SVProgressHUD.showSuccess(withStatus: "Email sent to: " + appUser().email + "!")
                    }
                }
            }
            else if(indexPath.row == 2){
                
                if(appChild().id == -1){
                    SVProgressHUD.showInfo(withStatus: "Please add your child first")
                }
                else{
                    
                    SVProgressHUD.show()
                    RequestHelper.sharedInstance.getMealPlan(forceRefresh: true) { (response) in
                        if(response["success"] as? Bool == true){
                            SVProgressHUD.dismiss()
                            
                            GlobalMealPlanViewController?.shouldRefresh = true
                            
                        }
                        else{
                            SVProgressHUD.showError(withStatus: response["message"] as? String)
                        }
                    }
                    
                }
                
            }
            else{
                
            }
        }
        else if (tableView.tag == 1){
            
//            if(indexPath.row == 0){
//                UIApplication.shared.open(URL(string: privacyURL)!)
//            }
//            else if(indexPath.row == 1){
//                UIApplication.shared.open(URL(string: termsURL)!)
//            }
//            else if(indexPath.row == 2){
//                UIApplication.shared.open(URL(string: termsURL)!)
//            }
//            else if(indexPath.row == 3){
//                UIApplication.shared.open(URL(string: termsURL)!)
//            }
            
            var urlString = ""
            if(indexPath.row == 0){
                urlString = privacyURL
            }
            else if(indexPath.row == 1){
                urlString = termsURL
            }
            else if(indexPath.row == 2){
                urlString = aboutUsURL
            }
            else if(indexPath.row == 3){
                urlString = contatUsURL
            }
            else if(indexPath.row == 4){
                urlString = faqURL
            }
            
            let webVC = WebViewController()
//            WKWebView.loadRequest(webVC.webView)(NSURLRequest(url: NSURL(string: urlString)! as URL) as URLRequest)
            webVC.webView.load(NSURLRequest(url: NSURL(string: urlString)! as URL) as URLRequest)
            self.present(webVC, animated: true) {}
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        
        if(tableView.tag == 0){
            
            if(indexPath.row == 0){
                
                let title = UILabel()
                title.text = "Cuisine Preferences"
                title.textColor = UIColor.black
                title.font = mainFont(size: 16)
                title.translatesAutoresizingMaskIntoConstraints = false
                
                cell.addSubview(title)
                
                title.heightAnchor.constraint(equalTo: cell.heightAnchor, multiplier: 1.0).isActive = true
                title.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 15).isActive = true
                
                let arrow = UIImageView()
                arrow.image = UIImage(named: "rightArrow")
                arrow.contentMode = UIView.ContentMode.scaleAspectFit
                arrow.translatesAutoresizingMaskIntoConstraints = false
                
                cell.addSubview(arrow)
                
                arrow.centerYAnchor.constraint(equalTo: cell.centerYAnchor, constant: 0).isActive = true
                arrow.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -15).isActive = true
                arrow.widthAnchor.constraint(equalToConstant: 14).isActive = true
                arrow.heightAnchor.constraint(equalTo: arrow.widthAnchor, multiplier: 1.0).isActive = true
                
                let bottomBorder = UIView()
                bottomBorder.backgroundColor = mainLightGrayColor
                bottomBorder.translatesAutoresizingMaskIntoConstraints = false
                
                cell.addSubview(bottomBorder)
                
                bottomBorder.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: 0).isActive = true
                bottomBorder.leftAnchor.constraint(equalTo: title.leftAnchor, constant: 0).isActive = true
                bottomBorder.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: 0).isActive = true
                bottomBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true
                
            }
            else if(indexPath.row == 1){
                
                let title = UILabel()
                title.text = "Change Password"
                title.textColor = UIColor.black
                title.font = mainFont(size: 16)
                title.translatesAutoresizingMaskIntoConstraints = false
                
                cell.addSubview(title)
                
                title.heightAnchor.constraint(equalTo: cell.heightAnchor, multiplier: 1.0).isActive = true
                title.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 15).isActive = true
                
                let arrow = UIImageView()
                arrow.image = UIImage(named: "rightArrow")
                arrow.contentMode = UIView.ContentMode.scaleAspectFit
                arrow.translatesAutoresizingMaskIntoConstraints = false
                
                cell.addSubview(arrow)
                
                arrow.centerYAnchor.constraint(equalTo: cell.centerYAnchor, constant: 0).isActive = true
                arrow.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -15).isActive = true
                arrow.widthAnchor.constraint(equalToConstant: 14).isActive = true
                arrow.heightAnchor.constraint(equalTo: arrow.widthAnchor, multiplier: 1.0).isActive = true
                
                let bottomBorder = UIView()
                bottomBorder.backgroundColor = mainLightGrayColor
                bottomBorder.translatesAutoresizingMaskIntoConstraints = false
                
                cell.addSubview(bottomBorder)
                
                bottomBorder.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: 0).isActive = true
                bottomBorder.leftAnchor.constraint(equalTo: title.leftAnchor, constant: 0).isActive = true
                bottomBorder.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: 0).isActive = true
                bottomBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true
                
            }
            else if(indexPath.row == 2){
                
                let title = UILabel()
                title.text = "Regenerate upcoming meals"//"Regenerate Meal Plan"
                title.textColor = UIColor.black
                title.font = mainFont(size: 16)
                title.translatesAutoresizingMaskIntoConstraints = false
                
                cell.addSubview(title)
                
                title.heightAnchor.constraint(equalTo: cell.heightAnchor, multiplier: 1.0).isActive = true
                title.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 15).isActive = true
                
                let arrow = UIImageView()
                arrow.image = UIImage(named: "rightArrow")
                arrow.contentMode = UIView.ContentMode.scaleAspectFit
                arrow.translatesAutoresizingMaskIntoConstraints = false
                
                cell.addSubview(arrow)
                
                arrow.centerYAnchor.constraint(equalTo: cell.centerYAnchor, constant: 0).isActive = true
                arrow.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -15).isActive = true
                arrow.widthAnchor.constraint(equalToConstant: 14).isActive = true
                arrow.heightAnchor.constraint(equalTo: arrow.widthAnchor, multiplier: 1.0).isActive = true
                
                let bottomBorder = UIView()
                bottomBorder.backgroundColor = mainLightGrayColor
                bottomBorder.translatesAutoresizingMaskIntoConstraints = false
                
                cell.addSubview(bottomBorder)
                
                bottomBorder.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: 0).isActive = true
                bottomBorder.leftAnchor.constraint(equalTo: title.leftAnchor, constant: 0).isActive = true
                bottomBorder.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: 0).isActive = true
                bottomBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true
                
            }
//            else if (indexPath.row == 3){
//
//                let USMetricsSwitch = UISwitch()
//                USMetricsSwitch.tag = indexPath.row
//                USMetricsSwitch.translatesAutoresizingMaskIntoConstraints = false
//                cell.addSubview(USMetricsSwitch)
//
//                USMetricsSwitch.centerYAnchor.constraint(equalTo: cell.centerYAnchor, constant: 1.0).isActive = true
//                USMetricsSwitch.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -15).isActive = true
//
//                UNUserNotificationCenter.current().getNotificationSettings { (settings) in
//                    if settings.authorizationStatus == .authorized {
//                        // Notifications are allowed
//                        DispatchQueue.main.async {
//                            USMetricsSwitch.setOn(appParent().isUSMetrics, animated: false)
//                        }
//
//                    }
//                    else {
//
//                    }
//
//                }
//                //
//                USMetricsSwitch.addTarget(self, action: #selector(USMetricsSwitchValueDidChange( sender:)), for: .valueChanged)
//
//                let label = UILabel()
//                label.textColor = UIColor.black
//                label.font = mainFont(size: 16)
//                label.text = "Use US units"
//                label.adjustsFontSizeToFitWidth = true
//                label.translatesAutoresizingMaskIntoConstraints = false
//                cell.addSubview(label)
//
//                label.centerYAnchor.constraint(equalTo: USMetricsSwitch.centerYAnchor, constant: 0).isActive = true
//                label.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 15).isActive = true
//                label.rightAnchor.constraint(equalTo: USMetricsSwitch.leftAnchor, constant: -10).isActive = true
//                label.heightAnchor.constraint(equalTo: cell.heightAnchor, multiplier: 1.0).isActive = true
//
//                let bottomBorder = UIView()
//                bottomBorder.backgroundColor = mainLightGrayColor
//                bottomBorder.translatesAutoresizingMaskIntoConstraints = false
//
//                cell.addSubview(bottomBorder)
//
//                bottomBorder.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: 0).isActive = true
//                bottomBorder.leftAnchor.constraint(equalTo: label.leftAnchor, constant: 0).isActive = true
//                bottomBorder.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: 0).isActive = true
//                bottomBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true
//
//            }
            else if (indexPath.row == 3){
                
                let notificationSwitch = UISwitch()
                notificationSwitch.tag = indexPath.row
                notificationSwitch.translatesAutoresizingMaskIntoConstraints = false
                cell.addSubview(notificationSwitch)
                
                notificationSwitch.centerYAnchor.constraint(equalTo: cell.centerYAnchor, constant: 1.0).isActive = true
                notificationSwitch.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -15).isActive = true
                
                UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                    if settings.authorizationStatus == .authorized {
                        // Notifications are allowed
                        DispatchQueue.main.async {
                            notificationSwitch.setOn(appUser().notificationsAllowed, animated: false)
                        }
                        
                    }
                    else {
                        
                    }
                    
                }
                //
                notificationSwitch.addTarget(self, action: #selector(notificationSwitchValueDidChange( sender:)), for: .valueChanged)
                
                let label = UILabel()
                label.textColor = UIColor.black
                label.font = mainFont(size: 16)
                label.text = "Notifications"
                label.adjustsFontSizeToFitWidth = true
                label.translatesAutoresizingMaskIntoConstraints = false
                cell.addSubview(label)
                
                label.centerYAnchor.constraint(equalTo: notificationSwitch.centerYAnchor, constant: 0).isActive = true
                label.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 15).isActive = true
                label.rightAnchor.constraint(equalTo: notificationSwitch.leftAnchor, constant: -10).isActive = true
                label.heightAnchor.constraint(equalTo: cell.heightAnchor, multiplier: 1.0).isActive = true
                
            }
        }
        else{
            
            let title = UILabel()
            title.text = informationCells[indexPath.row]
            title.textColor = UIColor.black
            title.font = mainFont(size: 16)
            title.translatesAutoresizingMaskIntoConstraints = false
            
            cell.addSubview(title)
            
            title.heightAnchor.constraint(equalTo: cell.heightAnchor, multiplier: 1.0).isActive = true
            title.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 15).isActive = true
            
            let arrow = UIImageView()
            arrow.image = UIImage(named: "rightArrow")
            arrow.contentMode = UIView.ContentMode.scaleAspectFit
            arrow.translatesAutoresizingMaskIntoConstraints = false
            
            cell.addSubview(arrow)
            
            arrow.centerYAnchor.constraint(equalTo: cell.centerYAnchor, constant: 0).isActive = true
            arrow.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -15).isActive = true
            arrow.widthAnchor.constraint(equalToConstant: 14).isActive = true
            arrow.heightAnchor.constraint(equalTo: arrow.widthAnchor, multiplier: 1.0).isActive = true
            
            if(indexPath.row < informationCells.count - 1){
                
                let bottomBorder = UIView()
                bottomBorder.backgroundColor = mainLightGrayColor
                bottomBorder.translatesAutoresizingMaskIntoConstraints = false
                
                cell.addSubview(bottomBorder)
                
                bottomBorder.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: 0).isActive = true
                bottomBorder.leftAnchor.constraint(equalTo: title.leftAnchor, constant: 0).isActive = true
                bottomBorder.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: 0).isActive = true
                bottomBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true
            }
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return CGFloat(informationCellHeight)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView()
        sectionView.backgroundColor = mainGreenColor
        
        let title = UILabel()
        title.textColor = UIColor.white
        title.font = mainFont(size: 14)
        //
        title.translatesAutoresizingMaskIntoConstraints = false
        
        sectionView.addSubview(title)
        
        title.leftAnchor.constraint(equalTo: sectionView.leftAnchor, constant: 15).isActive = true
        title.heightAnchor.constraint(equalTo: sectionView.heightAnchor, multiplier: 1).isActive = true
        
        if(tableView.tag == 0){
            title.text = "PERSONAL SETTINGS"
        }
        else{
            title.text = "ADDITIONAL INFORMATION"
        }
        
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(SectionHeaderHeight)
    }
    
    func calculateTableSize(table: UITableView) -> CGFloat{
        
        var size = CGFloat(0)
        
        size = CGFloat(CGFloat(SectionHeaderHeight) + CGFloat(table.numberOfRows(inSection: 0)) * CGFloat(informationCellHeight))
        
        return size
    }
    
    @objc func notificationSwitchValueDidChange (sender: UISwitch){
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                
                SVProgressHUD.show()
                RequestHelper.sharedInstance.updateUserNotificationSettings(isNotificationEnabled: sender.isOn) { (response) in
                    if(response["success"] as? Bool == true){
                        SVProgressHUD.dismiss()
                        self.personalTableView.reloadData()
                    }
                    else{
                        SVProgressHUD.showError(withStatus: response["message"] as? String)
                    }
                }
                
            }
            else {
                
                DispatchQueue.main.async {
                    sender.setOn(false, animated: true)
                    
                    // create the alert
                    let alert = UIAlertController(title: nil, message: "You need to enable notifications in the settings page.", preferredStyle: UIAlertController.Style.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { action in
                        
                        // do something like...
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                        
                    }))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            }
            
        }
        
    }
    
    @objc func USMetricsSwitchValueDidChange (sender: UISwitch){
        
        
        var params = [:] as [String : Any]
        params["id"] = appParent().id
        params["isUSMetrics"] = sender.isOn
        
        SVProgressHUD.show()
        RequestHelper.sharedInstance.updateParent(params: params) { (response) in
            if(response["success"] as? Bool == true){
                SVProgressHUD.dismiss()
                self.personalTableView.reloadData()
            }
            else{
                SVProgressHUD.showError(withStatus: response["message"] as? String)
            }
        }
        
    }
    
    
}

