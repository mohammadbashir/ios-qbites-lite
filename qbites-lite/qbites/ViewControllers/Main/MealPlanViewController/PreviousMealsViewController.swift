//
//  PreviousMealsViewController.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 12/22/19.
//  Copyright © 2019 Mohammad Bashir sidani. All rights reserved.
//

//import Foundation
//import UIKit
//import SwipeCellKit
//import SVProgressHUD
//import SDWebImage
//
//class PreviousMealsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
//    
//    var weekPlanArray = [DailyPlan]()
//    
//    lazy var mealPlanTableView: UITableView = {
//        
//        let tableView = UITableView(frame: CGRect(), style: .grouped)
//        tableView.layer.cornerRadius = 10
//        tableView.tag = 0
//        
//        tableView.backgroundColor = .clear
//        tableView.dataSource = self
//        tableView.delegate = self
//        
//        //        tableView.isScrollEnabled = false
//        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        
////        tableView.addSubview(refreshControl)
//        
//        return tableView
//        
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        GlobalPreviousMealsViewController = self
//        
//        Utilities.sharedInstance.applyBlueGradient(view: self.view)
////        self.edgesForExtendedLayout = []
//        
//        self.view.addSubview(mealPlanTableView)
//        mealPlanTableView.register(SwipeTableViewCell.self, forCellReuseIdentifier: "cell")
//        
//        fetchMeals()
//    }
//    
//    override func viewSafeAreaInsetsDidChange() {
//        // ... your layout code here
//        layoutViews()
//    }
//    
//    func layoutViews(){
//        
//        mealPlanTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: Utilities.sharedInstance.SafeAreaTopInset() + (self.navigationController?.navigationBar.frame.size.height)!).isActive = true
//        mealPlanTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
//        mealPlanTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
//        mealPlanTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Utilities.sharedInstance.SafeAreaBottomInset()).isActive = true
//        
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        showNavigationBar()
//        makeNavigationTransparent()
//        self.navigationController?.navigationBar.tintColor = .white
//        
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        
//        if (weekPlanArray.count == 0){
//            let noDataLabel = UILabel()
//            noDataLabel.font = mainFont(size: 20)
//            noDataLabel.textColor = .white
//            noDataLabel.numberOfLines = 0
//            noDataLabel.textAlignment = .center
//            noDataLabel.text = "No Meals"
//            
//            if(appChild().id == -1){
//                noDataLabel.text = "Add your child in the family page first to use the meal plan"
//            }
//            
//            tableView.backgroundView = noDataLabel
//        }
//        else{
//            tableView.backgroundView = nil
//        }
//        
//        return weekPlanArray.count
//        
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        if(weekPlanArray.count > 0){
//            return weekPlanArray[section].mealsArray.count
//        }
//        else{
//            return 0
//        }
//        
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//        let meal = weekPlanArray[indexPath.section].mealsArray[indexPath.row]
//        
//        if(!meal.recipe.type.contains("snacks")){
//            return 180
//        }
//        else{ //else it is a snack
//            return 120
//        }
//        
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let meal = weekPlanArray[indexPath.section].mealsArray[indexPath.row]
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SwipeTableViewCell
//        cell.delegate = self
//        cell.selectionStyle = .none
//        cell.backgroundColor = UIColor.clear
//        
//        for subView in cell.subviews {
//            subView.removeFromSuperview()
//        }
//        
//        cell.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
//        
//        let cellView = UIImageView()
//        cellView.contentMode = .scaleAspectFill
//        cellView.layer.cornerRadius = 15
//        cellView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
//        cellView.clipsToBounds = true
//        cellView.translatesAutoresizingMaskIntoConstraints = false
//        cellView.isUserInteractionEnabled = true
//        cell.addSubview(cellView)
//        
//        cellView.image = UIImage(named: "messageBlur")
//        
//        cellView.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
//        cellView.widthAnchor.constraint(equalTo: cell.widthAnchor, multiplier: 1, constant: -10).isActive = true
//        cellView.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
//        cellView.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -15).isActive = true
//        
//        cell.layoutIfNeeded()
//        
//        let mealImageView = UIImageView()
//        mealImageView.backgroundColor = .lightGray
//        mealImageView.clipsToBounds = true
//        mealImageView.contentMode = .scaleAspectFill
//        mealImageView.translatesAutoresizingMaskIntoConstraints = false
//        cellView.addSubview(mealImageView)
//        
//        if(meal.recipe.imageURLsArray.count > 0){
//            mealImageView.sd_imageIndicator = SDWebImageActivityIndicator.white
//            mealImageView.sd_setImage(with: URL(string: CloudinaryURLByWidth(url: meal.recipe.imageURLsArray[0], width: 300) ), placeholderImage: UIImage())
//        }
//        
//        //        mealImageView.image = UIImage(named: mealImageNames[(5 * indexPath.section) + indexPath.row] + ".jpg")
//        
//        mealImageView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 7).isActive = true
//        mealImageView.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 7).isActive = true
//        mealImageView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -7).isActive = true
//        mealImageView.widthAnchor.constraint(equalTo: cellView.widthAnchor, multiplier: 0.3).isActive = true
//        
//        let mealLabel = UILabel()
//        mealLabel.textColor = mainLightBlueColor
//        mealLabel.font = mainFontBold(size: 16)
//        mealLabel.text = meal.recipe.name
//        //        mealLabel.text = "Grandmas old country home made Macarroni & Cheese with peas and carrots"
//        //        mealLabel.textAlignment = .center
//        //        mealLabel.backgroundColor = .lightGray
//        mealLabel.numberOfLines = 0
//        mealLabel.translatesAutoresizingMaskIntoConstraints = false
//        cellView.addSubview(mealLabel)
//        
//        mealLabel.topAnchor.constraint(equalTo: mealImageView.topAnchor, constant: 0).isActive = true
//        mealLabel.leftAnchor.constraint(equalTo: mealImageView.rightAnchor, constant: 7).isActive = true
//        mealLabel.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -7).isActive = true
//        mealLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
//        
//        let actionsViewheightConstant = CGFloat(30.0)
//        
//        let actionsView = UIView()
//        //        actionsView.backgroundColor = .lightGray
//        actionsView.isUserInteractionEnabled = true
//        actionsView.translatesAutoresizingMaskIntoConstraints = false
//        cellView.addSubview(actionsView)
//        
//        actionsView.leftAnchor.constraint(equalTo: mealImageView.rightAnchor, constant: 7).isActive = true
//        actionsView.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -7).isActive = true
//        actionsView.bottomAnchor.constraint(equalTo: mealImageView.bottomAnchor, constant: 0).isActive = true
//        actionsView.heightAnchor.constraint(equalToConstant: actionsViewheightConstant).isActive = true
//        
//        //time
//        //        let timeView = UIView()
//        //        timeView.backgroundColor = .green
//        //        timeView.translatesAutoresizingMaskIntoConstraints = false
//        //        actionsView.addSubview(timeView)
//        //
//        //        timeView.leftAnchor.constraint(equalTo: actionsView.leftAnchor, constant: 0).isActive = true
//        //        timeView.heightAnchor.constraint(equalTo: actionsView.heightAnchor, multiplier: 1).isActive = true
//        //        timeView.setContentHuggingPriority(UILayoutPriority.defaultHigh, for:.vertical)
//        
//        let timeImage = UIImageView()
//        timeImage.image = UIImage(named: "clock.png")?.mask(with: mainGreenColor)
//        timeImage.contentMode = .scaleAspectFit
//        timeImage.clipsToBounds = true
//        //        timeImage.backgroundColor = mainGreenColor
//        timeImage.translatesAutoresizingMaskIntoConstraints = false
//        actionsView.addSubview(timeImage)
//        
//        timeImage.leftAnchor.constraint(equalTo: actionsView.leftAnchor, constant: 0).isActive = true
//        timeImage.heightAnchor.constraint(equalTo: actionsView.heightAnchor, multiplier: 1.0).isActive = true
//        timeImage.widthAnchor.constraint(equalTo: timeImage.heightAnchor, multiplier: 1.0).isActive = true
//        
//        let timeLabel = UILabel()
//        timeLabel.font = mainFont(size: 12)
//        timeLabel.adjustsFontSizeToFitWidth = true
//        timeLabel.text = meal.recipe.preparationTimeDisplay
//        timeLabel.textColor = mainGreenColor
//        
//        timeLabel.translatesAutoresizingMaskIntoConstraints = false
//        //        actionsView.addSubview(timeLabel)
//        
//        let activeTimeLabel = UILabel()
//        activeTimeLabel.font = mainFont(size: 12)
//        activeTimeLabel.adjustsFontSizeToFitWidth = true
//        activeTimeLabel.text = "Act. " + meal.recipe.activeTimeDisplay
//        activeTimeLabel.textColor = mainGreenColor
//        
//        activeTimeLabel.translatesAutoresizingMaskIntoConstraints = false
//        //        actionsView.addSubview(activeTimeLabel)
//        
//        //        timeLabel.backgroundColor = .white
//        
//        if(meal.recipe.activeTimeDisplay != ""){
//            
//            actionsView.addSubview(timeLabel)
//            actionsView.addSubview(activeTimeLabel)
//            
//            timeLabel.leftAnchor.constraint(equalTo: timeImage.rightAnchor, constant: 3).isActive = true
//            timeLabel.rightAnchor.constraint(equalTo: actionsView.centerXAnchor, constant: (-actionsViewheightConstant - 1.5) ).isActive = true
//            timeLabel.heightAnchor.constraint(equalTo: actionsView.heightAnchor, multiplier: 0.5).isActive = true
//            timeLabel.topAnchor.constraint(equalTo: timeImage.topAnchor, constant: 0).isActive = true
//            
//            activeTimeLabel.leftAnchor.constraint(equalTo: timeLabel.leftAnchor, constant: 0).isActive = true
//            activeTimeLabel.rightAnchor.constraint(equalTo: timeLabel.rightAnchor, constant: 0).isActive = true
//            activeTimeLabel.heightAnchor.constraint(equalTo: timeLabel.heightAnchor, multiplier: 1.0).isActive = true
//            activeTimeLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 0).isActive = true
//            
//        }
//        else{
//            actionsView.addSubview(timeLabel)
//            
//            timeLabel.leftAnchor.constraint(equalTo: timeImage.rightAnchor, constant: 3).isActive = true
//            timeLabel.rightAnchor.constraint(equalTo: actionsView.centerXAnchor, constant: (-actionsViewheightConstant - 1.5) ).isActive = true
//            timeLabel.heightAnchor.constraint(equalTo: actionsView.heightAnchor, multiplier: 1.0).isActive = true
//            
//        }
//        
//        
//        
//        //
//        let qcalImage = UIImageView()
//        qcalImage.image = UIImage(named: "qcal.png")?.mask(with: .darkGray) // silver
//        
//        qcalImage.contentMode = .scaleAspectFit
//        qcalImage.clipsToBounds = true
//        //        timeImage.backgroundColor = .green
//        qcalImage.translatesAutoresizingMaskIntoConstraints = false
//        actionsView.addSubview(qcalImage)
//        
//        let qcalLabel = UILabel()
//        qcalLabel.font = mainFontBold(size: 12)
//        qcalLabel.text = "qCal"
//        qcalLabel.textColor = .darkGray
//        qcalLabel.translatesAutoresizingMaskIntoConstraints = false
//        actionsView.addSubview(qcalLabel)
//        
//        qcalImage.leftAnchor.constraint(equalTo: timeLabel.rightAnchor, constant: 3).isActive = true
//        qcalImage.heightAnchor.constraint(equalTo: actionsView.heightAnchor, multiplier: 1.0).isActive = true
//        qcalImage.widthAnchor.constraint(equalTo: qcalImage.heightAnchor, multiplier: 1.0).isActive = true
//        
//        qcalLabel.leftAnchor.constraint(equalTo: qcalImage.rightAnchor, constant: 1.5).isActive = true
//        qcalLabel.heightAnchor.constraint(equalTo: actionsView.heightAnchor, multiplier: 1.0).isActive = true
//        
//        //        qcalLabel.backgroundColor = .white
//        
//        
//        if(meal.recipe.ratingMedal == "GOLD"){
//            let goldColor = UIColor.init(red: 212/255, green: 175/255, blue: 55/255, alpha: 1.0)
//            qcalImage.image = UIImage(named: "qcal.png")?.mask(with: goldColor)
//            qcalLabel.textColor = goldColor
//        } else if(meal.recipe.ratingMedal == "SILVER"){
//            qcalImage.image = UIImage(named: "qcal.png")?.mask(with: .darkGray)
//            qcalLabel.textColor = .darkGray
//        }
//        else if(meal.recipe.ratingMedal == "BRONZE"){
//            qcalImage.image = UIImage(named: "qcal.png")?.mask(with: UIColor.init(red: 205/255, green: 127/255, blue: 50/255, alpha: 1.0))
//            qcalLabel.textColor = UIColor.init(red: 205/255, green: 127/255, blue: 50/255, alpha: 1.0)
//        }
//        else{
//            qcalImage.isHidden = true
//            qcalLabel.isHidden = true
//        }
//        
//        //        ratingButton.rightAnchor.constraint(equalTo: actionsView.rightAnchor, constant: 0).isActive = true
//        //        ratingButton.heightAnchor.constraint(equalTo: actionsView.heightAnchor, multiplier: 1).isActive = true
//        //        ratingButton.widthAnchor.constraint(equalTo: actionsView.heightAnchor, multiplier: 1).isActive = true
//        
//        
//        //        //rating
//        let ratingButton = UIButton()
//        ratingButton.isUserInteractionEnabled = true
//        //        ratingButton.backgroundColor = .red
//        ratingButton.addTarget(self, action: #selector(ratingPressed( sender:)),for: .touchUpInside)
//        ratingButton.translatesAutoresizingMaskIntoConstraints = false
//        ratingButton.setImage(UIImage(named:"rating")?.mask(with: mainLightBlueColor) , for: UIControl.State.normal)
//        ratingButton.tag = (indexPath.section * 1000) + indexPath.row
//        actionsView.addSubview(ratingButton)
//        
//        if(meal.reaction == "LOVE"){
//            ratingButton.setImage(UIImage(named: "heart-selected") , for: UIControl.State.normal)
//        }
//        else if(meal.reaction == "LIKE"){
//            ratingButton.setImage(UIImage(named: "like-selected") , for: UIControl.State.normal)
//        }
//        else if(meal.reaction == "DISLIKE"){
//            ratingButton.setImage(UIImage(named: "like-selected")?.sd_flippedImage(withHorizontal: false, vertical: true) , for: UIControl.State.normal)
//        }
//        else if(meal.reaction == "HATE"){
//            ratingButton.setImage(UIImage(named: "hate-selected") , for: UIControl.State.normal)
//        }
//        
//        ratingButton.rightAnchor.constraint(equalTo: actionsView.rightAnchor, constant: 0).isActive = true
//        ratingButton.heightAnchor.constraint(equalTo: actionsView.heightAnchor, multiplier: 1).isActive = true
//        ratingButton.widthAnchor.constraint(equalTo: actionsView.heightAnchor, multiplier: 1).isActive = true
//        
//        
//        let descriptionButton = UIButton()
//        descriptionButton.isUserInteractionEnabled = true
//        descriptionButton.translatesAutoresizingMaskIntoConstraints = false
//        descriptionButton.setImage(UIImage(named:"more-info")?.mask(with: mainLightBlueColor) , for: UIControl.State.normal)
//        descriptionButton.tag = (indexPath.section * 1000) + indexPath.row
//        descriptionButton.addTarget(self, action: #selector(openMealDescription( sender:)),for: .touchUpInside)
//        actionsView.addSubview(descriptionButton)
//        
//        descriptionButton.leftAnchor.constraint(equalTo: qcalLabel.rightAnchor, constant: 3).isActive = true
//        descriptionButton.rightAnchor.constraint(equalTo: ratingButton.leftAnchor, constant: -3).isActive = true
//        descriptionButton.heightAnchor.constraint(equalTo: actionsView.heightAnchor, constant: 0).isActive = true
//        //        descriptionButton.widthAnchor.constraint(equalTo: descriptionButton.heightAnchor, constant: 0).isActive = true
//        
//        
//        cellView.layoutIfNeeded()
//        
//        mealImageView.layer.cornerRadius = 15
//        
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
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        let meal = weekPlanArray[indexPath.section].mealsArray[indexPath.row]
//        
//        SVProgressHUD.show()
//        RequestHelper.sharedInstance.getRecipe(recipeId: meal.recipe.id) { (response) in
//            if(response["success"] as? Bool == true){
//                SVProgressHUD.dismiss()
//                
//                let mealVC = MealViewController()
//                meal.recipe = response["recipe"] as! Recipe
//                mealVC.meal = meal
//                self.navigationController?.pushViewController(mealVC, animated: true)
//            }
//            else{
//                SVProgressHUD.showError(withStatus: response["message"] as? String)
//            }
//        }
//        
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        let headerView = UIView()
//        //        headerView.backgroundColor = UIColor.lightGray
//        
//        let headerLabel = UILabel(frame: CGRect(x: 5, y: 5, width: 0, height: 0))
//        headerLabel.font = mainFontBold(size: 40)
//        headerLabel.textColor = UIColor.white
//        headerLabel.text = weekPlanArray[section].title
//        headerLabel.sizeToFit()
////        headerLabel.adjustsFontSizeToFitWidth = true
//        headerView.addSubview(headerLabel)
//        
//        return headerView
//    }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 50
//    }
//    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        
//        //        let dailyPlan = weekPlanArray[indexPath.section]
//        let meal = weekPlanArray[indexPath.section].mealsArray[indexPath.row]
//        
//        //        guard orientation == .right else { return nil }
//        
//        var actionsList = [SwipeAction]()
//        
////        let replaceAction = SwipeAction(style: .default, title: "Get New Suggestion") { action, indexPath in
////
////            SVProgressHUD.show()
////            RequestHelper.sharedInstance.replaceMeal(mealId: meal.id) { (response) in
////                if(response["success"] as? Bool == true){
////                    //                    SVProgressHUD.dismiss()
////                    self.fetchMeals()
////                    GlobalMealPlanViewController?.shouldRefresh = true
////                }
////                else{
////                    SVProgressHUD.showError(withStatus: response["message"] as? String)
////                    self.mealPlanTableView.reloadData()
////                }
////            }
////        }
////        replaceAction.backgroundColor = .red
//        
//        let skipAction = SwipeAction(style: .destructive, title: "Skip Meal") { action, indexPath in
//            
//            SVProgressHUD.show()
//            RequestHelper.sharedInstance.skipMeal(mealId: meal.id) { (response) in
//                if(response["success"] as? Bool == true){
//                    self.fetchMeals()
//                    GlobalMealPlanViewController?.shouldRefresh = true
//                }
//                else{
//                    SVProgressHUD.showError(withStatus: response["message"] as? String)
//                    self.mealPlanTableView.reloadData()
//                }
//            }
//            
//        }
//        skipAction.backgroundColor = mainYellowColor
//        //.yellow24115638
//        
//        let ateAction = SwipeAction(style: .default, title: "Consumed") { action, indexPath in
//            
//            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//            
//            let someAction = UIAlertAction(title: "Some", style: .default, handler: { action in
//                self.consumeMeal(mealId: meal.id, amount: 25)
//            })
//            alert.addAction(someAction)
//            
//            let halfAction = UIAlertAction(title: "About half", style: .default, handler: { action in
//                self.consumeMeal(mealId: meal.id, amount: 50)
//            })
//            alert.addAction(halfAction)
//            
//            let mostAction = UIAlertAction(title: "Most", style: .default, handler: { action in
//                self.consumeMeal(mealId: meal.id, amount: 75)
//            })
//            alert.addAction(mostAction)
//            
//            let allAction = UIAlertAction(title: "All", style: .default, handler: { action in
//                self.consumeMeal(mealId: meal.id, amount: 100)
//            })
//            alert.addAction(allAction)
//            
//            let moreAction = UIAlertAction(title: "More than suggested", style: .default, handler: { action in
//                self.consumeMeal(mealId: meal.id, amount: 125)
//            })
//            alert.addAction(moreAction)
//            
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
//                self.mealPlanTableView.reloadData()
//            }))
//            
//            self.present(alert, animated: true, completion: {
//                print("completion block")
//            })
//            
//        }
//        ateAction.backgroundColor = mainGreenColor
//        
//        let replaceWithAction = SwipeAction(style: .default, title: "Replace with") { action, indexPath in
//            
//            let searchVC = MealSearchViewController()
//            searchVC.view.tag = 0
//            searchVC.parentVC = "PreviousMeals"
//            searchVC.meal = meal
//            
//            self.present(searchVC, animated: true) {}
//            
//        }
//        replaceWithAction.backgroundColor = .lightGray//mainDarkGrayColor
//        
//        if orientation == .right{
//            actionsList = [ateAction, replaceWithAction]
//        }
//        else{
//            actionsList = [skipAction] //skipAction,
//        }
//        
//        return actionsList
//    }
//    
//    @objc func consumeMeal(mealId: Int, amount: Int){
//        
//        SVProgressHUD.show()
//        RequestHelper.sharedInstance.consumeMeal(mealId: mealId, amount: amount) { (response) in
//            if(response["success"] as? Bool == true){
//                self.fetchMeals()
//                GlobalMealPlanViewController?.shouldRefresh = true
//            }
//            else{
//                SVProgressHUD.showError(withStatus: response["message"] as? String)
//                self.mealPlanTableView.reloadData()
//            }
//        }
//        
//    }
//    
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//        var options = SwipeOptions()
//        options.expansionStyle = .fill
//        options.transitionStyle = .border
//        return options
//    }
//    
//    @objc func ratingPressed(sender: UIButton){
//        
//        let section = (sender.tag)/1000;
//        let row = (sender.tag)%1000;
//        
//        let meal = weekPlanArray[section].mealsArray[row]
//        
//        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        
//        let loveAction = UIAlertAction(title: "Love it!", style: .destructive, handler: { action in
//            self.rateRecepie(recepieId: meal.recipe.id, action: "LOVE")
//        })
//        loveAction.setValue(UIImage(named: "heart-selected"), forKey: "image")
//        alert.addAction(loveAction)
//        
//        let likeAction = UIAlertAction(title: "Like", style: .default, handler: { action in
//            self.rateRecepie(recepieId: meal.recipe.id, action: "LIKE")
//        })
//        likeAction.setValue(UIImage(named: "like-selected"), forKey: "image")
//        alert.addAction(likeAction)
//        
//        let dislikeAction = UIAlertAction(title: "Dislike", style: .default, handler: { action in
//            self.rateRecepie(recepieId: meal.recipe.id, action: "DISLIKE")
//        })
//        dislikeAction.setValue(UIImage(named: "like-selected")?.sd_flippedImage(withHorizontal: false, vertical: true), forKey: "image")
//        alert.addAction(dislikeAction)
//        
//        let hateAction = UIAlertAction(title: "Hate it!", style: .destructive, handler: { action in
//            self.rateRecepie(recepieId: meal.recipe.id, action: "HATE")
//        })
//        hateAction.setValue(UIImage(named: "hate-selected"), forKey: "image")
//        alert.addAction(hateAction)
//        
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
//            
//        }))
//        
//        self.present(alert, animated: true, completion: {
//            print("completion block")
//        })
//        
//    }
//    
//    @objc func rateRecepie(recepieId: Int, action: String){
//        
//        SVProgressHUD.show()
//        RequestHelper.sharedInstance.setRecepieReaction(recepieId: recepieId, action: action) { (response) in
//            if(response["success"] as? Bool == true){
//                self.fetchMeals()
//                GlobalMealPlanViewController?.shouldRefresh = true
//            }
//            else{
//                SVProgressHUD.showError(withStatus: response["message"] as? String)
//                self.mealPlanTableView.reloadData()
//            }
//        }
//        
//    }
//    
//    @objc func fetchMeals(){
//
//        SVProgressHUD.show()
//
//        RequestHelper.sharedInstance.getPreviousMeals { (response) in
//            if(response["success"] as? Bool == true){
//                SVProgressHUD.dismiss()
//
//                self.weekPlanArray = response["oldPlansArray"] as! [DailyPlan]
//                self.mealPlanTableView.reloadData()
//
//            }
//            else{
//                SVProgressHUD.showError(withStatus: response["message"] as? String)
//            }
//
//        }
//
//    }
//    
//    @objc func openMealDescription(sender: UIButton){
//        
//        let section = (sender.tag)/1000;
//        let row = (sender.tag)%1000;
//        
//        let meal = weekPlanArray[section].mealsArray[row]
//        
//        SVProgressHUD.show()
//        RequestHelper.sharedInstance.getRecipe(recipeId: meal.recipe.id) { (response) in
//            if(response["success"] as? Bool == true){
//                SVProgressHUD.dismiss()
//                
//                meal.recipe = response["recipe"] as! Recipe
//                
//                let mealDescriptionVC = MealDescriptionViewController()
//                mealDescriptionVC.meal = meal
//
//                self.navigationController?.pushViewController(mealDescriptionVC, animated: true)
//            }
//            else{
//                SVProgressHUD.showError(withStatus: response["message"] as? String)
//            }
//        }
//        
//    }
//    
//}
