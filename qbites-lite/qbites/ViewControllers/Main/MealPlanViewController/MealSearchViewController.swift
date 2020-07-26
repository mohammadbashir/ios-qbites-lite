//
//  MealSearchViewController.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 1/15/20.
//  Copyright © 2020 Mohammad Bashir sidani. All rights reserved.
//

import Foundation
import UIKit
import SwipeCellKit
import SVProgressHUD
import SDWebImage

class MealSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var meal = Meal()
    var parentVC = ""
    
    var recipesArray = [Recipe]()
    
    var foodTypeArray = ["SOLID", "BABY", "DRINK"]
    var foodType = 0
    
    let searchView: UIView = {
        let view = UIView()
        
        view.backgroundColor = mainLightGrayColor.withAlphaComponent(0.5)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let searchImage: UIImageView = {
        let image = UIImageView()
        
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "search")?.mask(with: .black)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    
    lazy var searchField: UITextField = {
        let field = UITextField()
        
        field.font = mainFont(size: 14)
        field.placeholder = "Search..."
        field.delegate = self
        field.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    
    let segmentedControl: UISegmentedControl = {
        
        let segmentedControl = UISegmentedControl()
        
        segmentedControl.backgroundColor = mainGreenColor
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        segmentedControl.insertSegment(withTitle: "Solid Food", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Baby Food", at: 1, animated: true)
        
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: mainGreenColor], for: UIControl.State.selected)
        
        segmentedControl.addTarget(self, action: #selector(segmentSelected(sender:)), for: .valueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentedControl
        
    }()
    
    lazy var mealPlanTableView: UITableView = {
        
        let tableView = UITableView(frame: CGRect(), style: .grouped)
        tableView.layer.cornerRadius = 10
        tableView.tag = 0
        
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
        
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(self.view.tag == 1){
            segmentedControl.insertSegment(withTitle: "Drinks", at: 2, animated: true)
        }
        segmentedControl.selectedSegmentIndex = 0
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utilities.sharedInstance.applyBlueGradient(view: self.view)
        
        
        
        view.addSubview(searchView)
        searchView.addSubview(searchImage)
        searchView.addSubview(searchField)
        
        view.addSubview(segmentedControl)
        view.addSubview(mealPlanTableView)
        
        mealPlanTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        layoutViews()
        
        searchRecipes(showLoader: true)
        
    }
    
    override func viewSafeAreaInsetsDidChange() {
        // ... your layout code here
        layoutViews()
    }
    
    func layoutViews(){
        
        searchView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        searchView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        searchView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        searchView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        searchImage.leftAnchor.constraint(equalTo: searchView.leftAnchor, constant: 15).isActive = true
        searchImage.centerYAnchor.constraint(equalTo: searchView.centerYAnchor, constant: 0).isActive = true
        searchImage.heightAnchor.constraint(equalTo: searchView.heightAnchor, multiplier: 0.6).isActive = true
        searchImage.widthAnchor.constraint(equalTo: searchImage.heightAnchor).isActive = true
        
        searchField.leftAnchor.constraint(equalTo: searchImage.rightAnchor, constant: 15).isActive = true
        searchField.heightAnchor.constraint(equalTo: searchView.heightAnchor, constant: 0).isActive = true
        searchField.rightAnchor.constraint(equalTo: searchView.rightAnchor, constant: -10).isActive = true
        
        segmentedControl.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 10).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        segmentedControl.widthAnchor.constraint(equalTo: searchView.widthAnchor, multiplier: 1.0).isActive = true
        
        mealPlanTableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 0).isActive = true
        mealPlanTableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        mealPlanTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Utilities.sharedInstance.SafeAreaBottomInset() ).isActive = true
        
        view.layoutIfNeeded()
        
        searchView.layer.cornerRadius = searchView.frame.size.height/2
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if (recipesArray.count == 0){
            let noDataLabel = UILabel()
            noDataLabel.font = mainFont(size: 20)
            noDataLabel.textColor = .black
            noDataLabel.numberOfLines = 0
            noDataLabel.textAlignment = .center
            noDataLabel.text = "No Results"
            
            if(appChild().id == -1){
                noDataLabel.text = "Add your child in the family page first to use the meal plan"
            }
            
            tableView.backgroundView = noDataLabel
        }
        else{
            tableView.backgroundView = nil
        }
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recipesArray.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let recipe = recipesArray[indexPath.row]
        
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
        
        cellView.image = UIImage(named: "messageBlur")
        
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
        
        if(recipe.imageURLsArray.count > 0){
            mealImageView.sd_imageIndicator = SDWebImageActivityIndicator.white
            mealImageView.sd_setImage(with: URL(string: CloudinaryURLByWidth(url: recipe.imageURLsArray[0], width: 300) ), placeholderImage: UIImage())
        }
        
        //        mealImageView.image = UIImage(named: mealImageNames[(5 * indexPath.section) + indexPath.row] + ".jpg")
        
        mealImageView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 7).isActive = true
        mealImageView.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 7).isActive = true
        mealImageView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -7).isActive = true
        mealImageView.widthAnchor.constraint(equalTo: cellView.widthAnchor, multiplier: 0.3).isActive = true
        
        let mealLabel = UILabel()
        mealLabel.textColor = .black
        mealLabel.font = mainFontBold(size: 16)
        mealLabel.text = recipe.name
        //        mealLabel.text = "Grandmas old country home made Macarroni & Cheese with peas and carrots"
        //        mealLabel.textAlignment = .center
        //        mealLabel.backgroundColor = .lightGray
        mealLabel.numberOfLines = 0
        mealLabel.translatesAutoresizingMaskIntoConstraints = false
        cellView.addSubview(mealLabel)
        
        mealLabel.topAnchor.constraint(equalTo: mealImageView.topAnchor, constant: 0).isActive = true
        mealLabel.leftAnchor.constraint(equalTo: mealImageView.rightAnchor, constant: 7).isActive = true
        mealLabel.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -7).isActive = true
        mealLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let actionsViewheightConstant = CGFloat(30.0)
        
        let actionsView = UIView()
        //        actionsView.backgroundColor = .lightGray
        actionsView.isUserInteractionEnabled = true
        actionsView.translatesAutoresizingMaskIntoConstraints = false
        cellView.addSubview(actionsView)
        
        actionsView.leftAnchor.constraint(equalTo: mealImageView.rightAnchor, constant: 7).isActive = true
        actionsView.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -7).isActive = true
        actionsView.bottomAnchor.constraint(equalTo: mealImageView.bottomAnchor, constant: 0).isActive = true
        actionsView.heightAnchor.constraint(equalToConstant: actionsViewheightConstant).isActive = true
        
        let timeImage = UIImageView()
        timeImage.image = UIImage(named: "clock.png")?.mask(with: mainGreenColor)
        timeImage.contentMode = .scaleAspectFit
        timeImage.clipsToBounds = true
        //        timeImage.backgroundColor = mainGreenColor
        timeImage.translatesAutoresizingMaskIntoConstraints = false
        actionsView.addSubview(timeImage)
        
        timeImage.leftAnchor.constraint(equalTo: actionsView.leftAnchor, constant: 0).isActive = true
        timeImage.heightAnchor.constraint(equalTo: actionsView.heightAnchor, multiplier: 1.0).isActive = true
        timeImage.widthAnchor.constraint(equalTo: timeImage.heightAnchor, multiplier: 1.0).isActive = true
        
        let timeLabel = UILabel()
        timeLabel.font = mainFont(size: 12)
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.text = recipe.preparationTimeDisplay
        timeLabel.textColor = mainGreenColor
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        //        actionsView.addSubview(timeLabel)
        
        let activeTimeLabel = UILabel()
        activeTimeLabel.font = mainFont(size: 12)
        activeTimeLabel.adjustsFontSizeToFitWidth = true
        activeTimeLabel.text = "Act. " + recipe.activeTimeDisplay
        activeTimeLabel.textColor = mainGreenColor
        
        activeTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        //        actionsView.addSubview(activeTimeLabel)
        
        //        timeLabel.backgroundColor = .white
        
        if(recipe.activeTimeDisplay != ""){
            
            actionsView.addSubview(timeLabel)
            actionsView.addSubview(activeTimeLabel)
            
            timeLabel.leftAnchor.constraint(equalTo: timeImage.rightAnchor, constant: 3).isActive = true
            timeLabel.rightAnchor.constraint(equalTo: actionsView.centerXAnchor, constant: (-actionsViewheightConstant - 1.5) ).isActive = true
            timeLabel.heightAnchor.constraint(equalTo: actionsView.heightAnchor, multiplier: 0.5).isActive = true
            timeLabel.topAnchor.constraint(equalTo: timeImage.topAnchor, constant: 0).isActive = true
            
            activeTimeLabel.leftAnchor.constraint(equalTo: timeLabel.leftAnchor, constant: 0).isActive = true
            activeTimeLabel.rightAnchor.constraint(equalTo: timeLabel.rightAnchor, constant: 0).isActive = true
            activeTimeLabel.heightAnchor.constraint(equalTo: timeLabel.heightAnchor, multiplier: 1.0).isActive = true
            activeTimeLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 0).isActive = true
            
        }
        else{
            actionsView.addSubview(timeLabel)
            
            timeLabel.leftAnchor.constraint(equalTo: timeImage.rightAnchor, constant: 3).isActive = true
            timeLabel.rightAnchor.constraint(equalTo: actionsView.centerXAnchor, constant: (-actionsViewheightConstant - 1.5) ).isActive = true
            timeLabel.heightAnchor.constraint(equalTo: actionsView.heightAnchor, multiplier: 1.0).isActive = true
            
        }
        
        
        
        //
        let qcalImage = UIImageView()
        qcalImage.image = UIImage(named: "qcal.png")?.mask(with: .darkGray) // silver
        
        qcalImage.contentMode = .scaleAspectFit
        qcalImage.clipsToBounds = true
        //        timeImage.backgroundColor = .green
        qcalImage.translatesAutoresizingMaskIntoConstraints = false
        actionsView.addSubview(qcalImage)
        
        let qcalLabel = UILabel()
        qcalLabel.font = mainFontBold(size: 12)
        qcalLabel.text = "qCal"
        qcalLabel.textColor = .darkGray
        qcalLabel.translatesAutoresizingMaskIntoConstraints = false
        actionsView.addSubview(qcalLabel)
        
        qcalImage.leftAnchor.constraint(equalTo: timeLabel.rightAnchor, constant: 3).isActive = true
        qcalImage.heightAnchor.constraint(equalTo: actionsView.heightAnchor, multiplier: 1.0).isActive = true
        qcalImage.widthAnchor.constraint(equalTo: qcalImage.heightAnchor, multiplier: 1.0).isActive = true
        
        qcalLabel.leftAnchor.constraint(equalTo: qcalImage.rightAnchor, constant: 1.5).isActive = true
        qcalLabel.heightAnchor.constraint(equalTo: actionsView.heightAnchor, multiplier: 1.0).isActive = true
        
        //        qcalLabel.backgroundColor = .white
        
        
        if(recipe.ratingMedal == "GOLD"){
            let goldColor = UIColor.init(red: 212/255, green: 175/255, blue: 55/255, alpha: 1.0)
            qcalImage.image = UIImage(named: "qcal.png")?.mask(with: goldColor)
            qcalLabel.textColor = goldColor
        } else if(recipe.ratingMedal == "SILVER"){
            qcalImage.image = UIImage(named: "qcal.png")?.mask(with: .darkGray)
            qcalLabel.textColor = .darkGray
        }
        else if(recipe.ratingMedal == "BRONZE"){
            qcalImage.image = UIImage(named: "qcal.png")?.mask(with: UIColor.init(red: 205/255, green: 127/255, blue: 50/255, alpha: 1.0))
            qcalLabel.textColor = UIColor.init(red: 205/255, green: 127/255, blue: 50/255, alpha: 1.0)
        }
        else{
            qcalImage.isHidden = true
            qcalLabel.isHidden = true
        }
        
        
        cellView.layoutIfNeeded()
        
        mealImageView.layer.cornerRadius = 15
        
        //        if(meal.status == "CONSUMED"){
        //            mealLabel.textColor = mainGreenColor
        //        }
        //        else if (meal.status == "SKIPPED"){
        //            mealLabel.textColor = mainYellowColor
        //        }
        //        else if(meal.status == "REPLACED_WITH"){
        //            mealLabel.textColor = .white
        //            cellView.backgroundColor = .lightGray //UIColor.darkGray.withAlphaComponent(0.8)
        //
        //            timeImage.isHidden = true
        //            timeLabel.isHidden = true
        //            qcalImage.isHidden = true
        //            qcalLabel.isHidden = true
        //            ratingButton.isHidden = true
        //            descriptionButton.isHidden = true
        //        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let recipe = recipesArray[indexPath.row]
        
        if(self.view.tag == 0){
            
            SVProgressHUD.show()
            RequestHelper.sharedInstance.replaceMealWith(mealId: meal.id, recipeId: recipe.id) { (response) in
                if(response["success"] as? Bool == true){
                    SVProgressHUD.dismiss()
                    self.dismiss(animated: true) {
                        if(self.parentVC == "MealPlan"){
                            GlobalMealPlanViewController?.fetchMeals(forceRefresh: false)
                        }
//                        else if (self.parentVC == "PreviousMeals"){
//                            GlobalPreviousMealsViewController?.fetchMeals()
//                        }
                        
                    }
                }
                else{
                    SVProgressHUD.showError(withStatus: response["message"] as? String)
                }
            }
            
        }
        else{
            let dict:[String: Any] = ["recipe": recipe]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "recipeSelected"), object: nil, userInfo: dict)
            self.dismiss(animated: true) {}
        }
        
        
        
    }
    
    @objc func segmentSelected(sender: UISegmentedControl){
        
        foodType = sender.selectedSegmentIndex
        searchRecipes(showLoader: true)
        
    }
    
    func searchRecipes(showLoader: Bool){
        
        if(showLoader){
            SVProgressHUD.show()
        }
        
        RequestHelper.sharedInstance.searchRecipes(keyword: searchField.text ?? "", foodType: foodTypeArray[foodType]) { (response) in
            if(response["success"] as? Bool == true){
                
                self.recipesArray = response["recipes"] as! [Recipe]
                self.mealPlanTableView.reloadData()
                
                
                if(showLoader){
                    SVProgressHUD.dismiss()
                }
                
                
            }
            else{
                SVProgressHUD.showError(withStatus: response["message"] as? String)
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder();
        return true;
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        searchRecipes(showLoader: false)
        
    }
    
}
