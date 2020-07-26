//
//  RecipeRankingsViewController.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 2/12/20.
//  Copyright © 2020 Mohammad Bashir sidani. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import SDWebImage
import SkyFloatingLabelTextField
import Sheeeeeeeeet

class RecipeRankingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var mealsArray = [Meal]()
    var cuisinesArray = [Cuisine]()
    var selectedCuisinesArray = [Cuisine]()
    
    var rankingDuration = "WEEKLY" //"TOTAL"
    
    let addRecipeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = mainGreenColor
        button.setTitle("Add Recipe", for: UIControl.State.normal)
        button.titleLabel?.font = mainFontBold(size: 16)
        button.titleLabel?.textColor = UIColor.white
        button.addTarget(self, action: #selector(addRecipePressed( sender:)),for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = mainFontBold(size: 28)
        label.numberOfLines = 0
        label.setLineSpacing(lineSpacing: 15, lineHeightMultiple: 0)
        label.text = "Top recipe rankings"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let segmentedControl: UISegmentedControl = {
        
        let segmentedControl = UISegmentedControl()
        
        segmentedControl.backgroundColor = mainGreenColor
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        segmentedControl.insertSegment(withTitle: "This week", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "All time", at: 1, animated: true)
        
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: mainGreenColor], for: UIControl.State.selected)
        
        segmentedControl.addTarget(self, action: #selector(segmentSelected(sender:)), for: .valueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentedControl
        
    }()
    
    lazy var cuisinesField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextFieldWithIcon()
        Utilities.sharedInstance.styleSkyField(field: field, color: .black)
        field.lineColor = mainGreenColor
        field.placeholder = "All cuisines"
        field.title = ""
        field.iconType = .image
        field.iconImage = UIImage(named:"filter")?.mask(with: .black)
        field.textAlignment = .center
        field.tag = 1
        field.delegate = self
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var recipesTableView: UITableView = {
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []
//        Utilities.sharedInstance.applyBlueGradient(view: self.view)
        
        view.addSubview(addRecipeButton)
        view.addSubview(titleLabel)
        view.addSubview(segmentedControl)
        view.addSubview(cuisinesField)
        view.addSubview(recipesTableView)
        recipesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        segmentedControl.selectedSegmentIndex = 0
//        getRankings()
        
    }
    
    var didLoadRankings = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(!didLoadRankings){
            getRankings()
            didLoadRankings = true
        }
        
        
        //listen to observers
        NotificationCenter.default.addObserver(self, selector: #selector(multipleCuisinesSelected(_:)), name: NSNotification.Name(rawValue: "multipleCuisinesSelected"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //remove observers
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func getRankings(){
        
        var cuisineIds = ""
        for cuisine in selectedCuisinesArray {
            cuisineIds = cuisineIds + "," + String(cuisine.id)
        }
        
        if cuisineIds != "" {
            cuisineIds.remove(at: cuisineIds.startIndex)
        }
        
        SVProgressHUD.show()
        RequestHelper.sharedInstance.getMealRankings(cuisines: cuisineIds, rankingDuration: rankingDuration) { (response) in
            if(response["success"] as? Bool == true){
                SVProgressHUD.dismiss()
                self.mealsArray = response["meals"] as? [Meal] ?? [Meal]()
                self.recipesTableView.reloadData()
            }
            else{
                SVProgressHUD.showError(withStatus: response["message"] as? String)
            }
        }
        
    }
    
    override func viewSafeAreaInsetsDidChange() {
        // ... your layout code here
        layoutViews()
    }
    
    func layoutViews(){
        
        addRecipeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        addRecipeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        addRecipeButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier:0.9, constant: 0).isActive = true
        addRecipeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: addRecipeButton.bottomAnchor, constant: 15).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: addRecipeButton.centerXAnchor, constant: 0).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: addRecipeButton.widthAnchor, constant: 0).isActive = true
        
        segmentedControl.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: addRecipeButton.centerXAnchor, constant: 0).isActive = true
        segmentedControl.widthAnchor.constraint(equalTo: addRecipeButton.widthAnchor, multiplier: 1).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        cuisinesField.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 7).isActive = true
        cuisinesField.centerXAnchor.constraint(equalTo: addRecipeButton.centerXAnchor, constant: 0).isActive = true
        cuisinesField.widthAnchor.constraint(equalTo: addRecipeButton.widthAnchor, multiplier: 1).isActive = true
//        cuisinesField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        recipesTableView.topAnchor.constraint(equalTo: cuisinesField.bottomAnchor, constant: 7).isActive = true
        recipesTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        recipesTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        recipesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        view.layoutIfNeeded()
        
        addRecipeButton.layer.cornerRadius = addRecipeButton.frame.size.height/2
    }
    
    @objc func addRecipePressed(sender: UIButton){
        self.navigationController?.pushViewController(AddRecepieViewController(), animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mealsArray.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let meal = mealsArray[indexPath.row]
        
        if(!meal.recipe.type.contains("snacks")){
            return 180
        }
        else{ //else it is a snack
            return 120
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let meal = mealsArray[indexPath.row]
        
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
        
        if(meal.recipe.imageURLsArray.count > 0){
            mealImageView.sd_imageIndicator = SDWebImageActivityIndicator.white
            mealImageView.sd_setImage(with: URL(string: CloudinaryURLByWidth(url: meal.recipe.imageURLsArray[0], width: 300) ), placeholderImage: UIImage())
        }
        
        //        mealImageView.image = UIImage(named: mealImageNames[(5 * indexPath.section) + indexPath.row] + ".jpg")
        
        mealImageView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 7).isActive = true
        mealImageView.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 7).isActive = true
        mealImageView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -7).isActive = true
        mealImageView.widthAnchor.constraint(equalTo: cellView.widthAnchor, multiplier: 0.3).isActive = true
        
        var mealRank = 0
        var mealString = ""
        
        if(segmentedControl.selectedSegmentIndex == 0){
            
            if(meal.weekOrder != 0 && meal.previousWeekOrder != 0){
                mealRank = meal.previousWeekOrder - meal.weekOrder
            }
            
            if (mealRank > 0){
                mealString = " (+" + String(mealRank) + ")"
            }
            else if (mealRank < 0) {
                mealString = " (" + String(mealRank) + ")"
            }
            
        }
        
        let mealLabel = UILabel()
        mealLabel.textColor = .black
        mealLabel.font = mainFontBold(size: 16)
        let stringValue = "#" + String(indexPath.row + 1) + mealString + "\n\n" + meal.recipe.name
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
        
        if(segmentedControl.selectedSegmentIndex == 0){
            
            if(mealString != ""){
                if(mealRank > 0){
                    attributedString.setColor(color: mainGreenColor, forText: mealString)
                }
                else{
                    attributedString.setColor(color: UIColor.red, forText: mealString)
                }
            }
            
        }
        
        mealLabel.attributedText = attributedString
        
        
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
        
        //time
        //        let timeView = UIView()
        //        timeView.backgroundColor = .green
        //        timeView.translatesAutoresizingMaskIntoConstraints = false
        //        actionsView.addSubview(timeView)
        //
        //        timeView.leftAnchor.constraint(equalTo: actionsView.leftAnchor, constant: 0).isActive = true
        //        timeView.heightAnchor.constraint(equalTo: actionsView.heightAnchor, multiplier: 1).isActive = true
        //        timeView.setContentHuggingPriority(UILayoutPriority.defaultHigh, for:.vertical)
        
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
        timeLabel.text = meal.recipe.preparationTimeDisplay
        timeLabel.textColor = mainGreenColor
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        //        actionsView.addSubview(timeLabel)
        
        let activeTimeLabel = UILabel()
        activeTimeLabel.font = mainFont(size: 12)
        activeTimeLabel.adjustsFontSizeToFitWidth = true
        activeTimeLabel.text = "Act. " + meal.recipe.activeTimeDisplay
        activeTimeLabel.textColor = mainGreenColor
        
        activeTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        //        actionsView.addSubview(activeTimeLabel)
        
        //        timeLabel.backgroundColor = .white
        
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
        
        let meal = mealsArray[indexPath.row]
        
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
    
    @objc func ratingPressed(sender: UIButton){
        
        //        let section = (sender.tag)/1000;
        let row = (sender.tag)%1000;
        
        let meal = mealsArray[row]
        
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
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }
    
    @objc func openMealDescription(sender: UIButton){
        
        //        let section = (sender.tag)/1000;
        let row = (sender.tag)%1000;
        
        let meal = mealsArray[row]
        
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
    
    @objc func rateRecepie(recepieId: Int, action: String){
        
        SVProgressHUD.show()
        RequestHelper.sharedInstance.setRecepieReaction(recepieId: recepieId, action: action) { (response) in
            if(response["success"] as? Bool == true){
                self.getRankings()
                GlobalMealPlanViewController?.shouldRefresh = true
                SVProgressHUD.dismiss()
            }
            else{
                SVProgressHUD.showError(withStatus: response["message"] as? String)
                self.recipesTableView.reloadData()
            }
        }
        
    }
    
    @objc func segmentSelected(sender: UISegmentedControl){
        
        let index = sender.selectedSegmentIndex

        if(index == 0){
            rankingDuration = "WEEKLY"
        }
        else if(index == 1){
            rankingDuration = "TOTAL"
        }
        
        getRankings()
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField.tag == 1){
            
            if(cuisinesArray.count == 0){
                RequestHelper.sharedInstance.searchCuisines(keyword: "") { (response) in
                    if(response["success"] as? Bool == true){
                        
                        self.cuisinesArray = response["cuisines"] as! [Cuisine]
                        SVProgressHUD.dismiss()
                        self.cuisinesPressed(sender: textField)
                    }
                    else{
                        SVProgressHUD.showError(withStatus: response["message"] as? String)
                    }
                }
            }
            else{
                cuisinesPressed(sender: textField)
            }
            
            return false
        }

        return true
    }
    
    func cuisinesPressed(sender: UITextField){

        let cuisinesMSVC = CuisineMultiselectViewController()
        cuisinesMSVC.selectedCuisinesArray = selectedCuisinesArray
        let navVC = UINavigationController(rootViewController: cuisinesMSVC)
        
        self.present(navVC, animated: true) {}
        
    }
    
    
    @objc func multipleCuisinesSelected(_ notification: NSNotification) {
        
        if let dict = notification.userInfo as NSDictionary? {
            if let cuisines = dict["cuisines"] as? [Cuisine]{
                selectedCuisinesArray = cuisines
            }
            
            var cuisinesText = ""
            for cuisine in selectedCuisinesArray {
                cuisinesText = cuisinesText + ", " + cuisine.name
            }
            
            if cuisinesText != "" {
                cuisinesText.remove(at: cuisinesText.startIndex)
                cuisinesText.remove(at: cuisinesText.startIndex)
            }
            
            cuisinesField.text = cuisinesText
        }
        
        getRankings()
    }
    
}
