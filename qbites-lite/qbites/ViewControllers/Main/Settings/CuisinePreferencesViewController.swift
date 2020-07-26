//
//  CuisinePreferencesViewController.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 10/27/19.
//  Copyright © 2019 Mohammad Bashir sidani. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import SDWebImage

class CuisinePreferencesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var shouldShowAlertOnDismiss = false
    var askForPlanRefresh = false
    
    var cuisinesArray = [Cuisine]()
    var groupedCuisinesArray = [NSDictionary]()
    
    lazy var cuisinesTableView: UITableView = {
            
        let tableView = UITableView(frame: CGRect(), style: .grouped)
        tableView.backgroundColor = UIColor.green
        tableView.layer.cornerRadius = 10
        tableView.tag = 0
        
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utilities.sharedInstance.applyBlueGradient(view: self.view)
        
        self.view.addSubview(cuisinesTableView)
        cuisinesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        SVProgressHUD.show()
        
        RequestHelper.sharedInstance.getCuisines { (response) in
            if(response["success"] as? Bool == true){
                
                self.cuisinesArray = response["cuisinesArray"] as! [Cuisine]
                self.groupedCuisinesArray = response["groupedCuisinesArray"] as! [NSDictionary]
                self.cuisinesTableView.reloadData()
                SVProgressHUD.dismiss()
                
            }
            else{
                SVProgressHUD.showError(withStatus: response["message"] as? String)
            }
        }
        
//        if(appParent().didCheckCuisines == false){
//
//            shouldShowAlertOnDismiss = true
//
//            let params = ["id":appParent().id, "didCheckCuisines": true] as [String : Any]
//            RequestHelper.sharedInstance.updateParent(params: params) { (response) in
//                if(response["success"] as? Bool == true){
//
//                }
//                else{
//
//                }
//            }
//        }
        
        if(appChild().didCuisinePrefs == false){
            
            shouldShowAlertOnDismiss = true
            
            var params = [:] as [String : Any]
            params["id"] = appChild().id
            params["didCuisinePrefs"] = true
            RequestHelper.sharedInstance.updateChild(params: params) { (response) in
                if(response["success"] as? Bool == true){
                }
                else{
                }
            }
            
//            let params = ["id":appParent().id, "didCheckCuisines": true] as [String : Any]
//            RequestHelper.sharedInstance.updateParent(params: params) { (response) in
//                if(response["success"] as? Bool == true){
//
//                }
//                else{
//
//                }
//            }
        }
        
    }
    
    override func viewSafeAreaInsetsDidChange() {
        // ... your layout code here
        layoutViews()
    }
    
    func layoutViews(){
        
        cuisinesTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: Utilities.sharedInstance.SafeAreaTopInset() + (self.navigationController?.navigationBar.frame.size.height)!).isActive = true
        cuisinesTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        cuisinesTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        cuisinesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Utilities.sharedInstance.SafeAreaBottomInset()).isActive = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showNavigationBar()
        makeNavigationTransparent()
        self.navigationController?.navigationBar.tintColor = .black//mainLightBlueColor//.white
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            
            if(askForPlanRefresh){
                
//                let alert = UIAlertController(title: "Impact Meal Plan", message: "You changed your cuisine preferences, do you want to generate a new meal plan?", preferredStyle: UIAlertController.Style.alert)
//                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in
//
//                    SVProgressHUD.show()
//                    RequestHelper.sharedInstance.getMealPlan(forceRefresh: true) { (response) in
//                        if(response["success"] as? Bool == true){
//                            SVProgressHUD.dismiss()
//                            GlobalMealPlanViewController?.shouldRefresh = true
//                        }
//                        else{
//                            SVProgressHUD.showError(withStatus: response["message"] as? String)
//                        }
//                    }
//
//                }))
//                alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in   }))
//                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                
                GlobalRecipesViewController?.shouldRefresh = true
                
            }
            
            if(shouldShowAlertOnDismiss){
                
                let alert = UIAlertController(title: "Cuisine Preferences", message: "You can always view and change your cuisine preferences in the settings page", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in   }))
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                
            }
        
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupedCuisinesArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let cuisinesArray = groupedCuisinesArray[section]["cuisines"] as! NSArray
        
        return cuisinesArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
        
    }
            
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cuisinesArray = groupedCuisinesArray[indexPath.section]["cuisines"] as! NSArray
        let cuisine = cuisinesArray[indexPath.row] as! Cuisine
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        
        for subView in cell.subviews {
            subView.removeFromSuperview()
        }
        
        cell.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let cellView = UIImageView()
        cellView.contentMode = .scaleAspectFill
        cellView.layer.cornerRadius = 15
        cellView.backgroundColor = mainLightGrayColor.withAlphaComponent(0.5)
        cellView.clipsToBounds = true
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellView.isUserInteractionEnabled = true
        cell.addSubview(cellView)
        
        cellView.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        cellView.widthAnchor.constraint(equalTo: cell.widthAnchor, multiplier: 1, constant: -10).isActive = true
        cellView.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
        cellView.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -15).isActive = true
        
        cell.layoutIfNeeded()
        
        let mealImageView = UIImageView()
        mealImageView.backgroundColor = .lightGray
        mealImageView.clipsToBounds = true
        mealImageView.contentMode = .scaleAspectFill
        mealImageView.translatesAutoresizingMaskIntoConstraints = false
        cellView.addSubview(mealImageView)
        
        mealImageView.sd_imageIndicator = SDWebImageActivityIndicator.white
        mealImageView.sd_setImage(with: URL(string: CloudinaryURLByWidth(url: cuisine.imageURL, width: 200) ), placeholderImage: UIImage())
        
        mealImageView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 7).isActive = true
        mealImageView.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 7).isActive = true
        mealImageView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -7).isActive = true
        mealImageView.widthAnchor.constraint(equalTo: cellView.widthAnchor, multiplier: 0.3).isActive = true
        
        let mealLabel = UILabel()
        mealLabel.textColor = .black//mainLightBlueColor
        mealLabel.font = mainFontBold(size: 16)
        mealLabel.text = cuisine.name
        mealLabel.textAlignment = .center
//        mealLabel.backgroundColor = .lightGray
        mealLabel.numberOfLines = 0
        mealLabel.translatesAutoresizingMaskIntoConstraints = false
        cellView.addSubview(mealLabel)

        mealLabel.topAnchor.constraint(equalTo: mealImageView.topAnchor, constant: 0).isActive = true
        mealLabel.leftAnchor.constraint(equalTo: mealImageView.rightAnchor, constant: 7).isActive = true
        mealLabel.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -7).isActive = true
        mealLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let actionsView = UIView()
//        actionsView.backgroundColor = .lightGray
        actionsView.isUserInteractionEnabled = true
        actionsView.translatesAutoresizingMaskIntoConstraints = false
        cellView.addSubview(actionsView)
        
        actionsView.leftAnchor.constraint(equalTo: mealImageView.rightAnchor, constant: 7).isActive = true
        actionsView.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -7).isActive = true
        actionsView.bottomAnchor.constraint(equalTo: mealImageView.bottomAnchor, constant: 0).isActive = true
        actionsView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        let hateButton = UIButton()
        hateButton.tag = cuisine.id
        hateButton.addTarget(self, action: #selector(hateButtonPressed( sender:)),for: .touchUpInside)
        hateButton.setImage(UIImage(named: "hate-selected")?.mask(with: mainGrayColor) , for: UIControl.State.normal) //?.mask(with: .gray)
        hateButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        hateButton.translatesAutoresizingMaskIntoConstraints = false
        actionsView.addSubview(hateButton)
        
        hateButton.leftAnchor.constraint(equalTo: actionsView.leftAnchor, constant: 0).isActive = true
        hateButton.heightAnchor.constraint(equalTo: actionsView.heightAnchor, constant: 0).isActive = true
        hateButton.widthAnchor.constraint(equalTo: actionsView.widthAnchor, multiplier: 0.25).isActive = true
        
        let dislikeButton = UIButton()
        dislikeButton.tag = cuisine.id
        dislikeButton.addTarget(self, action: #selector(dislikeButtonPressed( sender:)),for: .touchUpInside)
        dislikeButton.setImage(UIImage(named: "like")?.mask(with: mainGrayColor).sd_flippedImage(withHorizontal: false, vertical: true) , for: UIControl.State.normal)
        dislikeButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        dislikeButton.translatesAutoresizingMaskIntoConstraints = false
        actionsView.addSubview(dislikeButton)

        dislikeButton.leftAnchor.constraint(equalTo: hateButton.rightAnchor, constant: 0).isActive = true
        dislikeButton.heightAnchor.constraint(equalTo: actionsView.heightAnchor, constant: 0).isActive = true
        dislikeButton.widthAnchor.constraint(equalTo: actionsView.widthAnchor, multiplier: 0.25).isActive = true
        
        let likeButton = UIButton()
        likeButton.tag = cuisine.id
        likeButton.addTarget(self, action: #selector(likeButtonPressed( sender:)),for: .touchUpInside)
        likeButton.setImage(UIImage(named: "like")?.mask(with: mainGrayColor), for: UIControl.State.normal)
        likeButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        actionsView.addSubview(likeButton)

        likeButton.leftAnchor.constraint(equalTo: dislikeButton.rightAnchor, constant: 0).isActive = true
        likeButton.heightAnchor.constraint(equalTo: actionsView.heightAnchor, constant: 0).isActive = true
        likeButton.widthAnchor.constraint(equalTo: actionsView.widthAnchor, multiplier: 0.25).isActive = true
        
        let loveButton = UIButton()
        loveButton.tag = cuisine.id
        loveButton.addTarget(self, action: #selector(loveButtonPressed( sender:)),for: .touchUpInside)
        loveButton.setImage(UIImage(named: "heart")?.mask(with: mainGrayColor), for: UIControl.State.normal)
        loveButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        loveButton.translatesAutoresizingMaskIntoConstraints = false
        actionsView.addSubview(loveButton)

        loveButton.leftAnchor.constraint(equalTo: likeButton.rightAnchor, constant: 0).isActive = true
        loveButton.heightAnchor.constraint(equalTo: actionsView.heightAnchor, constant: 0).isActive = true
        loveButton.widthAnchor.constraint(equalTo: actionsView.widthAnchor, multiplier: 0.25).isActive = true
        
        if(cuisine.reaction == "HATE"){
            hateButton.setImage(UIImage(named: "hate-selected"), for: UIControl.State.normal)
        }
        else if (cuisine.reaction == "DISLIKE"){
            dislikeButton.setImage(UIImage(named: "like-selected")?.sd_flippedImage(withHorizontal: false, vertical: true) , for: UIControl.State.normal)
        }
        else if (cuisine.reaction == "LIKE"){
            likeButton.setImage(UIImage(named: "like-selected"), for: UIControl.State.normal)
        }
        else if (cuisine.reaction == "LOVE"){
            loveButton.setImage(UIImage(named: "heart-selected"), for: UIControl.State.normal)
        }
        
        cellView.layoutIfNeeded()
        
        mealImageView.layer.cornerRadius = 15
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cuisinesTitle = groupedCuisinesArray[section]["key"] as! String
        
        let headerView = UIView()

        let headerLabel = UILabel()
        headerLabel.font = mainFontBold(size: 40)
        headerLabel.textColor = mainGreenColor
        headerLabel.text = cuisinesTitle
        headerLabel.sizeToFit()
        headerLabel.adjustsFontSizeToFitWidth = true
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(headerLabel)
        
        headerLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 1).isActive = true
        headerLabel.heightAnchor.constraint(equalTo: headerView.heightAnchor, multiplier: 1).isActive = true
            
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    

    @objc func hateButtonPressed(sender: UIButton){
        
        if let cuisine = cuisinesArray.first(where: {$0.id == sender.tag}) {
            
            if (cuisine.reaction == "HATE"){
                actionPressed(id: cuisine.id, action: "")
            }
            else{
                actionPressed(id: cuisine.id, action: "HATE")
            }
        }
        
    }
    
    @objc func dislikeButtonPressed(sender: UIButton){
        
        if let cuisine = cuisinesArray.first(where: {$0.id == sender.tag}) {
            
            if (cuisine.reaction == "DISLIKE"){
                actionPressed(id: cuisine.id, action: "")
            }
            else{
                actionPressed(id: cuisine.id, action: "DISLIKE")
            }
        }
        
    }
    
    @objc func likeButtonPressed(sender: UIButton){
        
        if let cuisine = cuisinesArray.first(where: {$0.id == sender.tag}) {
            
            if (cuisine.reaction == "LIKE"){
                actionPressed(id: cuisine.id, action: "")
            }
            else{
                actionPressed(id: cuisine.id, action: "LIKE")
            }
        }
        
    }
    
    @objc func loveButtonPressed(sender: UIButton){
        
        if let cuisine = cuisinesArray.first(where: {$0.id == sender.tag}) {
            
            if (cuisine.reaction == "LOVE"){
                actionPressed(id: cuisine.id, action: "")
            }
            else{
                actionPressed(id: cuisine.id, action: "LOVE")
            }
        }
        
    }
    
    func actionPressed(id: Int, action: String){
        
        SVProgressHUD.show()
        RequestHelper.sharedInstance.setCuisinePreference(id: id, action: action) { (response) in
            if(response["success"] as? Bool == true){
                SVProgressHUD.dismiss()
                
                for dict in self.groupedCuisinesArray {
                    
                    let cuisinesArray = dict["cuisines"] as! [Cuisine]
                    
                    if let cuisine = cuisinesArray.first(where: {$0.id == id}) {
                        cuisine.reaction = action
                    }
                    
                }
                
                if let cuisine = self.cuisinesArray.first(where: {$0.id == id}) {
                    cuisine.reaction = action
                }
                
                self.askForPlanRefresh = true
                self.cuisinesTableView.reloadData()
                
            }
            else{
                SVProgressHUD.showError(withStatus: response["message"] as? String)
            }
        }
        
    }
}
