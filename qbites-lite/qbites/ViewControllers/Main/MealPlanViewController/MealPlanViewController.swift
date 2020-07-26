//
//  MealPlanViewController.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 10/19/19.
//  Copyright © 2019 Mohammad Bashir sidani. All rights reserved.
//

import Foundation
import UIKit
import SwipeCellKit
import SVProgressHUD
import SDWebImage
import RLBAlertsPickers
import StoreKit

class MealPlanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    
    var mealPlanArray = [DailyPlan]()
    var previousMealsArray = [DailyPlan]()
    var historyArray = [DailyPlan]()
    var selectionType = "PLAN" //- "PREVIOUS", "HISTORY"
    var shouldRefresh = false
    var fetchAll = true
    
    lazy var mealsTableView: UITableView = {
        
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
    
    let cuisinesPreferencesButton: UIButton = {
        
        let button = UIButton()
        button.backgroundColor = mainLightBlueColor
        button.addTarget(self, action: #selector(openCuisinePreferences( sender:)),for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    let cuisinesPreferencesImage: UIImageView = {
        
        let image = UIImageView()
        image.image = UIImage(named: "infoIcon")?.mask(with: .white)
        image.contentMode = .scaleAspectFit
        
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
        
    }()
    
    let cuisinesPreferencesLabel: UILabel = {

        let label = UILabel()
        label.font = mainFont(size: 14)
        label.textColor = .white
        label.textAlignment = .left
        label.text = "Click here to Insert your cuisine preferences"
        label.clipsToBounds = true
        label.numberOfLines = 2

        label.setLineSpacing(lineSpacing: 5, lineHeightMultiple: 0)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let previousMealsButton: UIButton = {

        let button = UIButton()
        button.backgroundColor = mainYellowColor
        button.addTarget(self, action: #selector(openPreviousMeals( sender:)),for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let previousMealsImage: UIImageView = {

        let image = UIImageView()
        image.image = UIImage(named: "warningIcon")?.mask(with: .white)
        image.contentMode = .scaleAspectFit

        image.translatesAutoresizingMaskIntoConstraints = false
        return image

    }()

    let previousMealsLabel: UILabel = {

        let label = UILabel()
        label.font = mainFont(size: 14)
        label.textColor = .white
        label.textAlignment = .left
        label.text = "Click here to log in your previous meals"
        label.clipsToBounds = true
        label.numberOfLines = 2

        label.setLineSpacing(lineSpacing: 5, lineHeightMultiple: 0)

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let segmentedControl: UISegmentedControl = {
        
        let segmentedControl = UISegmentedControl()
        
        segmentedControl.backgroundColor = mainGreenColor
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        segmentedControl.insertSegment(withTitle: "History (7 Days)", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Previous Meals", at: 1, animated: true)
        segmentedControl.insertSegment(withTitle: "Meal Plan", at: 2, animated: true)
        
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: mainGreenColor], for: UIControl.State.selected)
        
        segmentedControl.addTarget(self, action: #selector(segmentSelected(sender:)), for: .valueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentedControl
        
    }()
    
    var cookBookButton: UIButton = {
        
        let button = UIButton()
        button.backgroundColor  = mainGreenColor
        button.setImage(UIImage(named: "book")?.mask(with: UIColor.white), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        button.addTarget(self, action: #selector(openCookBook( sender:)),for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var cuisinesPreferencesButtonTopAnchor:NSLayoutConstraint!
    var previousMealsButtonTopAnchor:NSLayoutConstraint!
    var segmentedControlTopAnchor:NSLayoutConstraint!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        GlobalMealPlanViewController = self
        self.edgesForExtendedLayout = []
        
        self.view.addSubview(cuisinesPreferencesButton)
        cuisinesPreferencesButton.addSubview(cuisinesPreferencesImage)
        cuisinesPreferencesButton.addSubview(cuisinesPreferencesLabel)
        
        self.view.addSubview(previousMealsButton)
        previousMealsButton.addSubview(previousMealsImage)
        previousMealsButton.addSubview(previousMealsLabel)
        
        self.view.addSubview(segmentedControl)
        self.view.addSubview(mealsTableView)
        
        self.view.addSubview(cookBookButton)
        
        mealsTableView.register(SwipeTableViewCell.self, forCellReuseIdentifier: "cell")
        
        cuisinesPreferencesButton.isHidden = true
        previousMealsButton.isHidden = true
        cookBookButton.isHidden = true
        
        segmentedControl.selectedSegmentIndex = 2
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateDynamicFields()
        
        if(mealPlanArray.count == 0 || shouldRefresh == true){
            shouldRefresh = false
            mealsTableView.reloadData()
            fetchMeals(forceRefresh: false)
        }
        
    }
    
    override func viewSafeAreaInsetsDidChange() {
        // ... your layout code here
        layoutViews()
    }
    
    func layoutViews(){
        
        cuisinesPreferencesButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Utilities.sharedInstance.SafeAreaTopInset() + 7).isActive = true
        cuisinesPreferencesButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        cuisinesPreferencesButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        cuisinesPreferencesButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        cuisinesPreferencesImage.heightAnchor.constraint(equalTo: cuisinesPreferencesButton.heightAnchor, multiplier: 1).isActive = true
        cuisinesPreferencesImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        cuisinesPreferencesImage.leftAnchor.constraint(equalTo: cuisinesPreferencesButton.leftAnchor, constant: 10).isActive = true
        
        cuisinesPreferencesLabel.leftAnchor.constraint(equalTo: cuisinesPreferencesImage.rightAnchor, constant: 10).isActive = true
        cuisinesPreferencesLabel.rightAnchor.constraint(equalTo: cuisinesPreferencesButton.rightAnchor, constant: -10).isActive = true
        cuisinesPreferencesLabel.heightAnchor.constraint(equalTo: cuisinesPreferencesButton.heightAnchor, multiplier: 1).isActive = true
        
        previousMealsButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        previousMealsButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        previousMealsButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        previousMealsImage.heightAnchor.constraint(equalTo: previousMealsButton.heightAnchor, multiplier: 1).isActive = true
        previousMealsImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        previousMealsImage.leftAnchor.constraint(equalTo: previousMealsButton.leftAnchor, constant: 10).isActive = true

        previousMealsLabel.leftAnchor.constraint(equalTo: previousMealsImage.rightAnchor, constant: 10).isActive = true
        previousMealsLabel.rightAnchor.constraint(equalTo: previousMealsButton.rightAnchor, constant: -10).isActive = true
        previousMealsLabel.heightAnchor.constraint(equalTo: previousMealsButton.heightAnchor, multiplier: 1).isActive = true
        
        segmentedControl.leftAnchor.constraint(equalTo: previousMealsButton.leftAnchor, constant: 0).isActive = true
        segmentedControl.rightAnchor.constraint(equalTo: previousMealsButton.rightAnchor, constant: 0).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        mealsTableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10).isActive = true
        mealsTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        mealsTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        mealsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        cookBookButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        cookBookButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        cookBookButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        cookBookButton.heightAnchor.constraint(equalTo: cookBookButton.widthAnchor).isActive = true
        
        self.view.layoutIfNeeded()
        cuisinesPreferencesButton.layer.cornerRadius = 10
        previousMealsButton.layer.cornerRadius = 10
        
        cookBookButton.layer.cornerRadius = cookBookButton.frame.size.width/2
        
    }
    
    func updateDynamicFields(){
        
        if(previousMealsButtonTopAnchor != nil){
            previousMealsButtonTopAnchor.isActive = false
        }
        if(segmentedControlTopAnchor != nil){
            segmentedControlTopAnchor.isActive = false
        }
        
        if(appChild().id == -1){
            
            cuisinesPreferencesButton.isHidden = true
            previousMealsButton.isHidden = true
            cookBookButton.isHidden = true
            segmentedControl.isHidden = true
            
            segmentedControlTopAnchor = segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: Utilities.sharedInstance.SafeAreaTopInset() + 7)
            
        }
        else{
            segmentedControl.isHidden = false
            cookBookButton.isHidden = false
            
            if((appChild().didCuisinePrefs == false) && previousMealsArray.count > 0){
                //show both
                
                cuisinesPreferencesButton.isHidden = false
                previousMealsButton.isHidden = false
                
                previousMealsButtonTopAnchor = previousMealsButton.topAnchor.constraint(equalTo: cuisinesPreferencesButton.bottomAnchor, constant: 7)
                
                segmentedControlTopAnchor = segmentedControl.topAnchor.constraint(equalTo: previousMealsButton.bottomAnchor, constant: 7)
                
            }
            else if((appChild().didCuisinePrefs == false) && previousMealsArray.count <= 0){
                //show cuisines only
                
                cuisinesPreferencesButton.isHidden = false
                previousMealsButton.isHidden = true
                
                segmentedControlTopAnchor = segmentedControl.topAnchor.constraint(equalTo: cuisinesPreferencesButton.bottomAnchor, constant: 7)
            }
            else if ((appChild().didCuisinePrefs == true) && previousMealsArray.count > 0){
                //show previous only
                
                cuisinesPreferencesButton.isHidden = true
                previousMealsButton.isHidden = false
                
                previousMealsButtonTopAnchor = previousMealsButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Utilities.sharedInstance.SafeAreaTopInset() + 7)
                
                segmentedControlTopAnchor = segmentedControl.topAnchor.constraint(equalTo: previousMealsButton.bottomAnchor, constant: 7)
                
            }
            else if ((appChild().didCuisinePrefs == true) && previousMealsArray.count <= 0){
                //show none
                
                cuisinesPreferencesButton.isHidden = true
                previousMealsButton.isHidden = true
                
                segmentedControlTopAnchor = segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: Utilities.sharedInstance.SafeAreaTopInset() + 7)
            }
            
            
//            if(mealPlanArray.count == 0 || shouldRefresh == true){
//                shouldRefresh = false
//                fetchMeals(forceRefresh: false)
//            }
            
        }

        if(previousMealsButtonTopAnchor != nil){
            previousMealsButtonTopAnchor.isActive = true
        }
        if(segmentedControlTopAnchor != nil){
            segmentedControlTopAnchor.isActive = true
        }

        self.view.layoutIfNeeded()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var currentArray = [DailyPlan]()
        let backView = UIView()
        
        let noDataLabel = UILabel()
        noDataLabel.font = mainFont(size: 20)
        noDataLabel.textColor = mainGreenColor
        noDataLabel.numberOfLines = 0
        noDataLabel.textAlignment = .center
        
        noDataLabel.translatesAutoresizingMaskIntoConstraints = false
        backView.addSubview(noDataLabel)
        
        noDataLabel.widthAnchor.constraint(equalTo: backView.widthAnchor, multiplier: 0.95).isActive = true
        noDataLabel.centerXAnchor.constraint(equalTo: backView.centerXAnchor, constant: 0).isActive = true
        noDataLabel.centerYAnchor.constraint(equalTo: backView.centerYAnchor, constant: 0).isActive = true
        
        if(selectionType == "HISTORY"){
            currentArray = historyArray
            noDataLabel.text = "No History"
        }
        else if(selectionType == "PREVIOUS"){
            currentArray = previousMealsArray
            noDataLabel.text = "No Previous Meals"
        }
        else if(selectionType == "PLAN"){
            currentArray = mealPlanArray
            noDataLabel.text = "No Meals"
        }
        
        if (currentArray.count == 0){
            
            if(appChild().id == -1){
                noDataLabel.text = "Add your child in the family page first"
            }
            else if(appChild().id != -1  && appChild().isIntroducedToSolidFoods == false){
                noDataLabel.text = "Meal Plan is only available when your child is introduced to solid foods"

                let enableSolidFoodsButton = UIButton()
                enableSolidFoodsButton.layer.cornerRadius = 10
                enableSolidFoodsButton.layer.borderColor = mainGreenColor.cgColor
                enableSolidFoodsButton.layer.borderWidth = 2.0
                enableSolidFoodsButton.addTarget(self, action: #selector(enableSolidFoodPressed( sender:)),for: .touchUpInside)
                
                let yourAttributes : [NSAttributedString.Key: Any] = [
                    NSAttributedString.Key.font : mainFontBold(size: 16),
                    NSAttributedString.Key.foregroundColor : mainGreenColor]
                let attributeString = NSMutableAttributedString(string: "Enable Solid Foods", attributes: yourAttributes)
                enableSolidFoodsButton.setAttributedTitle(attributeString, for: .normal)
                
                enableSolidFoodsButton.translatesAutoresizingMaskIntoConstraints = false
                backView.addSubview(enableSolidFoodsButton)

                enableSolidFoodsButton.widthAnchor.constraint(equalTo: backView.widthAnchor, multiplier: 0.8).isActive = true
                enableSolidFoodsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
                enableSolidFoodsButton.centerXAnchor.constraint(equalTo: backView.centerXAnchor, constant: 0).isActive = true
                enableSolidFoodsButton.topAnchor.constraint(equalTo: noDataLabel.bottomAnchor, constant: 30).isActive = true
                
                

            }
            
            tableView.backgroundView = backView
            
        }
        else{
            tableView.backgroundView = nil
        }
        
        return currentArray.count

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let currentArray = getSelectedMealPlan()
        
        if(currentArray.count > 0){
            return currentArray[section].mealsArray.count
        }
        else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let meal = getMeal(section: indexPath.section, row: indexPath.row)
        
        if(!meal.recipe.type.contains("snacks")){
            return 180
        }
        else{
            return 120
        }
        
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let meal = getMeal(section: indexPath.section, row: indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
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
        
        if(meal.recipe.imageURLsArray.count > 0){
            mealImageView.sd_imageIndicator = SDWebImageActivityIndicator.white
            mealImageView.sd_setImage(with: URL(string: CloudinaryURLByWidth(url: meal.recipe.imageURLsArray[0], width: 300) ), placeholderImage: UIImage())
        }
        
        mealImageView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 7).isActive = true
        mealImageView.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 7).isActive = true
        mealImageView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -7).isActive = true
        mealImageView.widthAnchor.constraint(equalTo: cellView.widthAnchor, multiplier: 0.3).isActive = true
        
        let mealLabel = UILabel()
        mealLabel.textColor = .black
        mealLabel.font = mainFontBold(size: 16)
        mealLabel.text = meal.recipe.name
        mealLabel.numberOfLines = 0
        mealLabel.translatesAutoresizingMaskIntoConstraints = false
        cellView.addSubview(mealLabel)

        mealLabel.topAnchor.constraint(equalTo: mealImageView.topAnchor, constant: 0).isActive = true
        mealLabel.leftAnchor.constraint(equalTo: mealImageView.rightAnchor, constant: 7).isActive = true
        mealLabel.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -7).isActive = true
        mealLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let actionsViewheightConstant = CGFloat(30.0)
        
        let actionsView = UIView()
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
        timeImage.translatesAutoresizingMaskIntoConstraints = false
        actionsView.addSubview(timeImage)
        
        timeImage.leftAnchor.constraint(equalTo: actionsView.leftAnchor, constant: 0).isActive = true
        timeImage.heightAnchor.constraint(equalTo: actionsView.heightAnchor, multiplier: 1.0).isActive = true
        timeImage.widthAnchor.constraint(equalTo: timeImage.heightAnchor, multiplier: 1.0).isActive = true

        let timeLabel = UILabel()
        timeLabel.font = mainFont(size: 12)
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.text = meal.recipe.preparationTimeDisplay
        timeLabel.textColor = mainGreenColor
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let activeTimeLabel = UILabel()
        activeTimeLabel.font = mainFont(size: 12)
        activeTimeLabel.adjustsFontSizeToFitWidth = true
        activeTimeLabel.text = "Act. " + meal.recipe.activeTimeDisplay
        activeTimeLabel.textColor = mainGreenColor
        
        activeTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if(meal.recipe.activeTimeDisplay != ""){
            
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
        
        if(meal.recipe.ratingMedal == "GOLD"){
            let goldColor = UIColor.init(red: 212/255, green: 175/255, blue: 55/255, alpha: 1.0)
            qcalImage.image = UIImage(named: "qcal.png")?.mask(with: goldColor)
            qcalLabel.textColor = goldColor
        } else if(meal.recipe.ratingMedal == "SILVER"){
            qcalImage.image = UIImage(named: "qcal.png")?.mask(with: .darkGray)
            qcalLabel.textColor = .darkGray
        }
        else if(meal.recipe.ratingMedal == "BRONZE"){
            qcalImage.image = UIImage(named: "qcal.png")?.mask(with: UIColor.init(red: 205/255, green: 127/255, blue: 50/255, alpha: 1.0))
            qcalLabel.textColor = UIColor.init(red: 205/255, green: 127/255, blue: 50/255, alpha: 1.0)
        }
        else{
            qcalImage.isHidden = true
            qcalLabel.isHidden = true
        }

//        ratingButton.rightAnchor.constraint(equalTo: actionsView.rightAnchor, constant: 0).isActive = true
//        ratingButton.heightAnchor.constraint(equalTo: actionsView.heightAnchor, multiplier: 1).isActive = true
//        ratingButton.widthAnchor.constraint(equalTo: actionsView.heightAnchor, multiplier: 1).isActive = true
        

//        //rating
        let ratingButton = UIButton()
        ratingButton.isUserInteractionEnabled = true
//        ratingButton.backgroundColor = .red
        ratingButton.addTarget(self, action: #selector(ratingPressed( sender:)),for: .touchUpInside)
        ratingButton.translatesAutoresizingMaskIntoConstraints = false
        ratingButton.setImage(UIImage(named:"rating")?.mask(with: mainLightBlueColor) , for: UIControl.State.normal)
        ratingButton.tag = (indexPath.section * 1000) + indexPath.row
        actionsView.addSubview(ratingButton)
        
        if(meal.reaction == "LOVE"){
            ratingButton.setImage(UIImage(named: "heart-selected") , for: UIControl.State.normal)
        }
        else if(meal.reaction == "LIKE"){
            ratingButton.setImage(UIImage(named: "like-selected") , for: UIControl.State.normal)
        }
        else if(meal.reaction == "DISLIKE"){
            ratingButton.setImage(UIImage(named: "like-selected")?.sd_flippedImage(withHorizontal: false, vertical: true) , for: UIControl.State.normal)
        }
        else if(meal.reaction == "HATE"){
            ratingButton.setImage(UIImage(named: "hate-selected") , for: UIControl.State.normal)
        }

        ratingButton.rightAnchor.constraint(equalTo: actionsView.rightAnchor, constant: 0).isActive = true
        ratingButton.heightAnchor.constraint(equalTo: actionsView.heightAnchor, multiplier: 1).isActive = true
        ratingButton.widthAnchor.constraint(equalTo: actionsView.heightAnchor, multiplier: 1).isActive = true
        
        
        let descriptionButton = UIButton()
        descriptionButton.isUserInteractionEnabled = true
        descriptionButton.translatesAutoresizingMaskIntoConstraints = false
        descriptionButton.setImage(UIImage(named:"more-info")?.mask(with: mainLightBlueColor) , for: UIControl.State.normal)
        descriptionButton.tag = (indexPath.section * 1000) + indexPath.row
        descriptionButton.addTarget(self, action: #selector(openMealDescription( sender:)),for: .touchUpInside)
        actionsView.addSubview(descriptionButton)
        
        descriptionButton.leftAnchor.constraint(equalTo: qcalLabel.rightAnchor, constant: 3).isActive = true
        descriptionButton.rightAnchor.constraint(equalTo: ratingButton.leftAnchor, constant: -3).isActive = true
        descriptionButton.heightAnchor.constraint(equalTo: actionsView.heightAnchor, constant: 0).isActive = true
//        descriptionButton.widthAnchor.constraint(equalTo: descriptionButton.heightAnchor, constant: 0).isActive = true
        
        
        cellView.layoutIfNeeded()
        
        mealImageView.layer.cornerRadius = 15
        
        if(meal.status == "CONSUMED"){
            mealLabel.textColor = mainGreenColor
        }
        else if (meal.status == "SKIPPED"){
            mealLabel.textColor = mainYellowColor
        }
        else if(meal.status == "REPLACED_WITH"){
            mealLabel.textColor = .white
            cellView.backgroundColor = .lightGray //UIColor.darkGray.withAlphaComponent(0.8)

            timeImage.isHidden = true
            timeLabel.isHidden = true
            qcalImage.isHidden = true
            qcalLabel.isHidden = true
            ratingButton.isHidden = true
            descriptionButton.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let meal = getMeal(section: indexPath.section, row: indexPath.row)
        
        SVProgressHUD.show()
        RequestHelper.sharedInstance.getRecipe(recipeId: meal.recipe.id) { (response) in
            if(response["success"] as? Bool == true){
                SVProgressHUD.dismiss()
                
                let mealVC = MealViewController()
                meal.recipe = response["recipe"] as! Recipe
                mealVC.meal = meal
                self.navigationController?.pushViewController(mealVC, animated: true)
            }
            else{
                SVProgressHUD.showError(withStatus: response["message"] as? String)
            }
        }

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var title = ""
        
        if(selectionType == "HISTORY"){
            title = historyArray[section].title
        }
        else if(selectionType == "PREVIOUS"){
            title = previousMealsArray[section].title
        }
        else if(selectionType == "PLAN"){
            title = mealPlanArray[section].title
        }
        
        let headerView = UIView()

        let headerLabel = UILabel(frame: CGRect(x: 5, y: 5, width: 0, height: 0))
        headerLabel.font = mainFontBold(size: 40)
        headerLabel.textColor = mainGreenColor//UIColor.black
        headerLabel.text = title
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
            
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        let meal = getMeal(section: indexPath.section, row: indexPath.row)
        
        let replaceAction = SwipeAction(style: .default, title: "Get New Suggestion") { action, indexPath in
            
            SVProgressHUD.show()
            RequestHelper.sharedInstance.replaceMeal(mealId: meal.id) { (response) in
                if(response["success"] as? Bool == true){
//                    SVProgressHUD.dismiss()
                    self.fetchMeals(forceRefresh: false)
                }
                else{
                    SVProgressHUD.showError(withStatus: response["message"] as? String)
                    self.mealsTableView.reloadData()
                }
            }
        }
        replaceAction.backgroundColor = .lightGray
        
        let skipAction = SwipeAction(style: .destructive, title: "Skip Meal") { action, indexPath in
            
            SVProgressHUD.show()
            RequestHelper.sharedInstance.skipMeal(mealId: meal.id) { (response) in
                if(response["success"] as? Bool == true){
                    self.fetchMeals(forceRefresh: false)
                }
                else{
                    SVProgressHUD.showError(withStatus: response["message"] as? String)
                    self.mealsTableView.reloadData()
                }
            }
            
        }
        skipAction.backgroundColor = mainYellowColor
        
        let ateAction = SwipeAction(style: .default, title: "Consumed") { action, indexPath in
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let someAction = UIAlertAction(title: "Some", style: .default, handler: { action in
                self.consumeMeal(mealId: meal.id, amount: 25)
            })
            alert.addAction(someAction)
            
            let halfAction = UIAlertAction(title: "About half", style: .default, handler: { action in
                self.consumeMeal(mealId: meal.id, amount: 50)
            })
            alert.addAction(halfAction)
            
            let mostAction = UIAlertAction(title: "Most", style: .default, handler: { action in
                self.consumeMeal(mealId: meal.id, amount: 75)
            })
            alert.addAction(mostAction)
            
            let allAction = UIAlertAction(title: "All", style: .default, handler: { action in
                self.consumeMeal(mealId: meal.id, amount: 100)
            })
            alert.addAction(allAction)
            
            let moreAction = UIAlertAction(title: "More than suggested", style: .default, handler: { action in
                self.consumeMeal(mealId: meal.id, amount: 125)
            })
            alert.addAction(moreAction)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                self.mealsTableView.reloadData()
            }))

            self.present(alert, animated: true, completion: { })

        }
        ateAction.backgroundColor = mainGreenColor
        
        let replaceWithAction = SwipeAction(style: .default, title: "Replace recipe") { action, indexPath in
            
            let searchVC = MealSearchViewController()
            searchVC.view.tag = 0
            searchVC.parentVC = "MealPlan"
            searchVC.meal = meal
            
            self.present(searchVC, animated: true) {}
            
        }
        replaceWithAction.backgroundColor = mainLightBlueColor//mainDarkGrayColor
        
        var actionsList = [SwipeAction]()
        
        if(selectionType == "HISTORY"){
            
        }
        else if(selectionType == "PREVIOUS"){
            if orientation == .right{
                actionsList = [ateAction, replaceWithAction]
            }
            else{
                actionsList = [skipAction] //skipAction,
            }
        }
        else if(selectionType == "PLAN"){
            
            if orientation == .right{
                if(indexPath.section == 0){
                    actionsList.append(ateAction)
                }
                actionsList.append(replaceWithAction)
            }
            else{
                actionsList = [skipAction, replaceAction]
            }
            
        }

        return actionsList
    }
    
    @objc func consumeMeal(mealId: Int, amount: Int){
        
        SVProgressHUD.show()
        RequestHelper.sharedInstance.consumeMeal(mealId: mealId, amount: amount) { (response) in
            if(response["success"] as? Bool == true){
                self.fetchMeals(forceRefresh: false)
                
                
                let numberOfConumes = UserDefaults.standard.integer(forKey: "consumes")
                
                if(numberOfConumes <= 100){
                    UserDefaults.standard.set(numberOfConumes + 1, forKey: "consumes")
                }
                else{
                    UserDefaults.standard.set(0, forKey: "consumes")
                    SKStoreReviewController.requestReview()
                }
                
            }
            else{
                SVProgressHUD.showError(withStatus: response["message"] as? String)
                self.mealsTableView.reloadData()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .fill
        options.transitionStyle = .border
        return options
    }
    
    @objc func ratingPressed(sender: UIButton){
        
        let section = (sender.tag)/1000;
        let row = (sender.tag)%1000;
        
        let meal = getMeal(section: section, row: row)
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let loveAction = UIAlertAction(title: "Love it!", style: .destructive, handler: { action in
            self.rateRecepie(recepieId: meal.recipe.id, action: "LOVE")
        })
        loveAction.setValue(UIImage(named: "heart-selected"), forKey: "image")
        alert.addAction(loveAction)
        
        let likeAction = UIAlertAction(title: "Like", style: .default, handler: { action in
            self.rateRecepie(recepieId: meal.recipe.id, action: "LIKE")
        })
        likeAction.setValue(UIImage(named: "like-selected"), forKey: "image")
        alert.addAction(likeAction)
        
        let dislikeAction = UIAlertAction(title: "Dislike", style: .default, handler: { action in
            self.rateRecepie(recepieId: meal.recipe.id, action: "DISLIKE")
        })
        dislikeAction.setValue(UIImage(named: "like-selected")?.sd_flippedImage(withHorizontal: false, vertical: true), forKey: "image")
        alert.addAction(dislikeAction)
        
        let hateAction = UIAlertAction(title: "Hate it!", style: .destructive, handler: { action in
            self.rateRecepie(recepieId: meal.recipe.id, action: "HATE")
        })
        hateAction.setValue(UIImage(named: "hate-selected"), forKey: "image")
        alert.addAction(hateAction)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
        }))

        self.present(alert, animated: true, completion: { })
        
    }
    
    @objc func rateRecepie(recepieId: Int, action: String){
        
        SVProgressHUD.show()
        RequestHelper.sharedInstance.setRecepieReaction(recepieId: recepieId, action: action) { (response) in
            if(response["success"] as? Bool == true){
                self.fetchMeals(forceRefresh: false)
            }
            else{
                SVProgressHUD.showError(withStatus: response["message"] as? String)
                self.mealsTableView.reloadData()
            }
        }
        
    }
    
    @objc func openCuisinePreferences(sender: UIButton){
        self.navigationController?.pushViewController(CuisinePreferencesViewController(), animated: true)
    }
    
    @objc func openPreviousMeals(sender: UIButton){
        
        if(selectionType == "HISTORY"){
            segmentedControl.selectedSegmentIndex = 0
            selectionType = "PREVIOUS"
            fetchMeals(forceRefresh: false)
        }
        else if(selectionType == "PREVIOUS"){
            
        }
        else if(selectionType == "PLAN"){
            segmentedControl.selectedSegmentIndex = 0
            selectionType = "PREVIOUS"
            fetchMeals(forceRefresh: false)
        }
    }
    
    @objc func openCookBook(sender: UIButton){
        
        if( selectionType == "HISTORY" || selectionType == "PREVIOUS" ){
            
            SVProgressHUD.show()
            RequestHelper.sharedInstance.getLast5MealPlans { (response) in
                if(response["success"] as? Bool == true){

                    let addPreviousMealVC = AddPreviousMealViewController()
                    addPreviousMealVC.previousPlans = response["MealPlansArray"] as! [DailyPlan]
                    
                    let navVC = UINavigationController(rootViewController: addPreviousMealVC)
                    
                    self.present(navVC, animated: true) {}
                    
                    SVProgressHUD.dismiss()

                }
                else{
                    SVProgressHUD.showError(withStatus: response["message"] as? String)
                }

            }
            
        }
        else if(selectionType == "PLAN"){
            
            self.navigationController?.pushViewController(CookBookViewController(), animated: true)
            
        }
        
    }
    
    @objc func fetchMeals(forceRefresh: Bool){
        
        if(appChild().id == -1){
            return
        }
        else if(appChild().id != -1  && appChild().isIntroducedToSolidFoods == false){
            return
        }
        
        if(selectionType == "HISTORY"){
            
            SVProgressHUD.show()
            RequestHelper.sharedInstance.getPreviousMeals(includeAll: true) { (response) in
                if(response["success"] as? Bool == true){

                    self.historyArray = response["previousMealsArray"] as! [DailyPlan]
                    self.mealsTableView.reloadData()
                    
                    self.shouldRefresh = false
                    self.updateDynamicFields()
                    
                    SVProgressHUD.dismiss()

                }
                else{
                    SVProgressHUD.showError(withStatus: response["message"] as? String)
                }

            }
            
        }
        else if(selectionType == "PREVIOUS"){
            
            SVProgressHUD.show()
            RequestHelper.sharedInstance.getPreviousMeals(includeAll: false) { (response) in
                if(response["success"] as? Bool == true){

                    self.previousMealsArray = response["previousMealsArray"] as! [DailyPlan]
                    self.mealsTableView.reloadData()
                    
                    self.shouldRefresh = false
                    self.updateDynamicFields()
                    
                    SVProgressHUD.dismiss()

                }
                else{
                    SVProgressHUD.showError(withStatus: response["message"] as? String)
                }

            }
            
        }
        else if(selectionType == "PLAN"){
            
            SVProgressHUD.show()
            RequestHelper.sharedInstance.getMealPlan(forceRefresh: forceRefresh) { (response) in
                if(response["success"] as? Bool == true){
                    
                    self.mealPlanArray = response["weekPlansArray"] as! [DailyPlan]
                    self.mealsTableView.reloadData()
                    
                    self.shouldRefresh = false
                    self.updateDynamicFields()
                    
                    SVProgressHUD.dismiss()
                    
                }
                else{
                    SVProgressHUD.showError(withStatus: response["message"] as? String)
                }
                
            }
            
            if(fetchAll){
                
                fetchAll = false
                
                RequestHelper.sharedInstance.getPreviousMeals(includeAll: false) { (response) in
                    if(response["success"] as? Bool == true){

                        self.previousMealsArray = response["previousMealsArray"] as! [DailyPlan]
                        
                        self.updateDynamicFields()
                        self.shouldRefresh = false

                    }
                    else{
                        SVProgressHUD.showError(withStatus: response["message"] as? String)
                    }

                }
                
            }
            
        }
        
        
        
    }
    
    @objc func openMealDescription(sender: UIButton){
        
        let section = (sender.tag)/1000;
        let row = (sender.tag)%1000;
        
        let meal = getMeal(section: section, row: row)
        
        SVProgressHUD.show()
        RequestHelper.sharedInstance.getRecipe(recipeId: meal.recipe.id) { (response) in
            if(response["success"] as? Bool == true){
                SVProgressHUD.dismiss()
                
                meal.recipe = response["recipe"] as! Recipe
                
                let mealDescriptionVC = MealDescriptionViewController()
                mealDescriptionVC.meal = meal

                self.navigationController?.pushViewController(mealDescriptionVC, animated: true)
            }
            else{
                SVProgressHUD.showError(withStatus: response["message"] as? String)
            }
        }
        
    }
    
    @objc func segmentSelected(sender: UISegmentedControl){
        
        let index = sender.selectedSegmentIndex
        
        if(index == 0){
            cookBookButton.setImage(UIImage(named: "addRecipe")?.mask(with: UIColor.white), for: .normal)
            selectionType = "HISTORY"
        }
        else if (index == 1){
            cookBookButton.setImage(UIImage(named: "addRecipe")?.mask(with: UIColor.white), for: .normal)
            selectionType = "PREVIOUS"
        }
        else{
            cookBookButton.setImage(UIImage(named: "book")?.mask(with: UIColor.white), for: .normal)
            selectionType = "PLAN"
        }
        
        fetchMeals(forceRefresh: false)
        
    }
    
    func getSelectedMealPlan() -> [DailyPlan] {
        
        if(segmentedControl.selectedSegmentIndex == 0){
            return historyArray
        }
        else if(segmentedControl.selectedSegmentIndex == 1){
            return previousMealsArray
        }
        else if(segmentedControl.selectedSegmentIndex == 2){
            return mealPlanArray
        }
        
        return [DailyPlan]()
    
    }
    
    func getMeal(section: Int, row: Int) -> Meal {
        
        let meal = getSelectedMealPlan()[section].mealsArray[row]
        return meal
        
    }
    
    @objc func enableSolidFoodPressed(sender: UIButton){
        let alertController = UIAlertController(title: "Enable solid foods?",
                                                message: "The World Health Organization recommends starting solid foods at 6 months. If your child is showing signs of being ready for solid food introduction, and you’ve discussed food introduction with your pediatrician, please enable solid foods for access to qbites meal plans.\nEnabling solid foods means that you already introduced " + appChild().name + " to solid foods as part of the daily diet. This will let the app generate meal plans for " + appChild().name + ". This process cannot be reversed.",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Enable", style: .destructive, handler: { action in
            var params = [:] as [String : Any]
            params["id"] = appChild().id
            params["isIntroducedToSolidFoods"] = true
            SVProgressHUD.show()
            RequestHelper.sharedInstance.updateChild(params: params) { (response) in
                if(response["success"] as? Bool == true){
                    SVProgressHUD.dismiss()
                    self.fetchMeals(forceRefresh: false)
                }
                else{
                    SVProgressHUD.showError(withStatus: response["message"] as? String)
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "More Info", style: .default, handler: { action in
            let webVC = WebViewController()
            webVC.webView.load(NSURLRequest(url: NSURL(string: ComplementaryFeedingURL)! as URL) as URLRequest)
//            UIWebView.loadRequest(webVC.webView)(NSURLRequest(url: NSURL(string: ComplementaryFeedingURL)! as URL) as URLRequest)
            self.present(webVC, animated: true) {
//                webVC.boxView.isHidden = true
                webVC.boxView.removeFromSuperview()
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
