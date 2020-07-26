//
//  RecipesViewController.swift
//  qbites Lite
//
//  Created by Mohammad Bashir sidani on 5/31/20.
//  Copyright © 2020 Mohammad Bashir sidani. All rights reserved.
//

import UIKit
import Foundation
import SVProgressHUD
import UserNotifications
import StoreKit
import Firebase
import SDWebImage

class RecipesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var shouldRefresh = true
    
    var cellId = "Cell"
    
    lazy var flowLayout:UICollectionViewFlowLayout = {
        let f = UICollectionViewFlowLayout()
        f.minimumInteritemSpacing = 0
        f.minimumLineSpacing = 0
        f.scrollDirection = UICollectionView.ScrollDirection.horizontal
        return f
    }()
    
    lazy var filterButton: UIButton = {
        
        let button = UIButton()
//        button.backgroundColor = mainLightGrayColor.withAlphaComponent(0.5)
        button.backgroundColor = mainBlueColor
        
        button.titleLabel?.font = mainFontBold(size: 14)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Filters", for: UIControl.State.normal)
        
        button.addTarget(self, action: #selector(filterButtonPressed( sender:)),for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.isHidden = true
        return button
    }()
    
    lazy var recipesCollection: UICollectionView = {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.flowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.setCollectionViewLayout(self.flowLayout, animated: true)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        cv.isPagingEnabled = true
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GlobalRecipesViewController = self
        
        self.edgesForExtendedLayout = []
        view.backgroundColor = .white
        
        view.addSubview(filterButton)
//        view.addSubview(clearFilterButton)
        view.addSubview(recipesCollection)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(shouldRefresh){
            totalPagesNumber = 0
            currentPageNumber = 0
            getRacipes()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutViews()
//        getRacipes()
    }
    
    func layoutViews(){
        
        filterButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Utilities.sharedInstance.SafeAreaTopInset() + 7).isActive = true
        filterButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5).isActive = true
        filterButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: -10).isActive = true
        filterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
//        clearFilterButton.topAnchor.constraint(equalTo: filterButton.topAnchor, constant: 0).isActive = true
//        clearFilterButton.heightAnchor.constraint(equalTo: filterButton.heightAnchor).isActive = true
//        clearFilterButton.leftAnchor.constraint(equalTo: filterButton.rightAnchor, constant: 5).isActive = true
//        clearFilterButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5).isActive = true
        
        recipesCollection.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 7).isActive = true
        recipesCollection.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
        recipesCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -7).isActive = true
        
//        flowLayout.itemSize = CGSize(width: view.frame.size.width, height: (view.frame.size.height - Utilities.sharedInstance.SafeAreaTopInset() - 10 - 50))
        
        view.layoutIfNeeded()
        
        flowLayout.itemSize = CGSize(width: view.frame.size.width, height: recipesCollection.frame.size.height)
        
        filterButton.layer.cornerRadius = filterButton.frame.size.height/2
//        clearFilterButton.layer.cornerRadius = clearFilterButton.frame.size.height/2
    }
    
    var mealsArray = [Meal]()
    var cuisinesArray = [Cuisine]()
    var selectedCuisinesArray = [Cuisine]()
    var rankingDuration = "WEEKLY" //"TOTAL"
    
    
    var currentPageNumber = 0
    var totalPagesNumber = 0
    var size = 5
    var isFetchingData = false
    
    func getRacipes(){
        
        if(appChild().id != -1){
            
            isFetchingData = true
            
            if(shouldRefresh){
                SVProgressHUD.show()
            }
            
            RequestHelper.sharedInstance.searchRecipes2(page: currentPageNumber, size: size) { (response) in
                if(response["success"] as? Bool == true){
                    
                    SVProgressHUD.dismiss()
                    
                    self.currentPageNumber = response["number"] as! Int
                    self.totalPagesNumber = response["totalPages"] as! Int
                    
                    if(self.shouldRefresh){
                        self.mealsArray = response["meals"] as? [Meal] ?? [Meal]()
                        self.recipesCollection.reloadData()
                        
                        self.recipesCollection.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: .left, animated: false)
                        
                    }
                    else{
                        self.mealsArray.append(contentsOf: response["meals"] as? [Meal] ?? [Meal]())
                        self.recipesCollection.reloadData()
                    }
                    
                    
                    
                    if(self.mealsArray.count == 0){
                        self.filterButton.isHidden = true
                    }
                    else{
                        self.filterButton.isHidden = false
                    }
                    
                    self.shouldRefresh = false
                    
                }
                else{
                    SVProgressHUD.showError(withStatus: response["message"] as? String)
                }
                
                self.isFetchingData = false
            }
            
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return thoughtsArray.count
        if (mealsArray.count == 0) {
            if(appChild().id == -1){
                recipesCollection.setEmptyMessage("Add your child in the family page first")
            }
            else{
                recipesCollection.setEmptyMessage("No Recipes Found")
            }
            
        } else {
            recipesCollection.restore()
        }
        
        return mealsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let meal = mealsArray[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        for vw in cell.subviews {
            vw.removeFromSuperview()
        }
        
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
        cellView.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: 0).isActive = true
        
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

//        mealImageView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 7).isActive = true
        mealImageView.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 7).isActive = true
        mealImageView.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -7).isActive = true
        mealImageView.heightAnchor.constraint(equalTo: cellView.heightAnchor, multiplier: 0.5).isActive = true
        mealImageView.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        
        let mealLabel = UILabel()
        mealLabel.textColor = .black
        mealLabel.font = mainFontBold(size: 16)
        mealLabel.text = meal.recipe.name
        mealLabel.numberOfLines = 0
        mealLabel.textAlignment = .center
        mealLabel.translatesAutoresizingMaskIntoConstraints = false
        cellView.addSubview(mealLabel)

        mealLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 7).isActive = true
//        mealLabel.topAnchor.constraint(equalTo: tagsScrollView.bottomAnchor, constant: 7).isActive = true //mealImageView
        mealLabel.bottomAnchor.constraint(equalTo: mealImageView.topAnchor, constant: -7).isActive = true
        mealLabel.leftAnchor.constraint(equalTo: mealImageView.leftAnchor, constant: 0).isActive = true
        mealLabel.rightAnchor.constraint(equalTo: mealImageView.rightAnchor, constant: 0).isActive = true
        mealLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let tagsScrollView = UIScrollView()
        tagsScrollView.isUserInteractionEnabled = true
        tagsScrollView.translatesAutoresizingMaskIntoConstraints = false
//        tagsScrollView.backgroundColor = .white
//        tagsScrollView.layer.cornerRadius = 15
        tagsScrollView.showsHorizontalScrollIndicator = false
        cellView.addSubview(tagsScrollView)

        tagsScrollView.leftAnchor.constraint(equalTo: mealImageView.leftAnchor, constant: 0).isActive = true
        tagsScrollView.rightAnchor.constraint(equalTo: mealImageView.rightAnchor, constant: 0).isActive = true
        tagsScrollView.topAnchor.constraint(equalTo: mealImageView.bottomAnchor, constant: 7).isActive = true
        tagsScrollView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        var lastTagView = UIView()
        
        for keyword in meal.recipe.keywords {
            
            let tagView = UIView()
            tagView.backgroundColor = .white
            tagView.translatesAutoresizingMaskIntoConstraints = false
            tagView.isUserInteractionEnabled = true
            tagView.layer.cornerRadius = (50 - 7) / 2
            tagsScrollView.addSubview(tagView)
            
            tagView.heightAnchor.constraint(equalTo: tagsScrollView.heightAnchor, constant: -7).isActive = true
//            tagView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            tagView.centerYAnchor.constraint(equalTo: tagsScrollView.centerYAnchor).isActive = true
            
            let tagLabel = UILabel()
            tagLabel.font = mainFontBold(size: 12)
            tagLabel.text = "#" + keyword
            tagLabel.textColor = .black
            tagLabel.translatesAutoresizingMaskIntoConstraints = false
            tagView.addSubview(tagLabel)

            tagLabel.leftAnchor.constraint(equalTo: tagView.leftAnchor, constant: 5).isActive = true
            tagLabel.rightAnchor.constraint(equalTo: tagView.rightAnchor, constant: -5).isActive = true
            tagLabel.heightAnchor.constraint(equalTo: tagView.heightAnchor, multiplier: 1.0).isActive = true
            
            if(meal.recipe.keywords[0] == keyword){
                tagView.leftAnchor.constraint(equalTo: tagsScrollView.leftAnchor, constant: 0).isActive = true
            }
            else{
                tagView.leftAnchor.constraint(equalTo: lastTagView.rightAnchor, constant: 7).isActive = true
            }
            
            lastTagView = tagView
            
        }
        
        cell.layoutIfNeeded()
        tagsScrollView.contentSize = CGSize(width: lastTagView.frame.maxX + 0, height: tagsScrollView.frame.size.height)
        
        let actionsViewheightConstant = CGFloat(30.0)

        let actionsView = UIView()
        actionsView.isUserInteractionEnabled = true
        actionsView.translatesAutoresizingMaskIntoConstraints = false
        cellView.addSubview(actionsView)

        actionsView.leftAnchor.constraint(equalTo: mealImageView.leftAnchor, constant: 0).isActive = true
        actionsView.rightAnchor.constraint(equalTo: mealImageView.rightAnchor, constant: 0).isActive = true
        actionsView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -7).isActive = true
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

        
//        let mealLabel = UILabel()
//        mealLabel.textColor = .black
//        mealLabel.font = mainFontBold(size: 16)
//        mealLabel.text = meal.recipe.name
//        mealLabel.numberOfLines = 0
//        mealLabel.textAlignment = .center
//        mealLabel.translatesAutoresizingMaskIntoConstraints = false
//        cellView.addSubview(mealLabel)
//
//        mealLabel.topAnchor.constraint(equalTo: tagsScrollView.bottomAnchor, constant: 7).isActive = true //mealImageView
//        mealLabel.bottomAnchor.constraint(equalTo: actionsView.topAnchor, constant: -7).isActive = true
//        mealLabel.leftAnchor.constraint(equalTo: mealImageView.leftAnchor, constant: 0).isActive = true
//        mealLabel.rightAnchor.constraint(equalTo: mealImageView.rightAnchor, constant: 0).isActive = true
//        mealLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true

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
        
        
        //        let cellView = ThoughtRectangularCellView()
        //
        //        cellView.initwith(thought: thoughtsArray[indexPath.row])
        //        cell.addSubview(cellView)
        //
        //        cellView.topAnchor.constraint(equalTo: cell.topAnchor, constant: 0).isActive = true
        //        cellView.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: 0).isActive = true
        //        cellView.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 0).isActive = true
        //        cellView.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: 0).isActive = true
        
        
        //        let cellView = UIView()
        //        cellView.translatesAutoresizingMaskIntoConstraints = false
        //        cellView.backgroundColor = .green
        //
        //        if(indexPath.row%2 == 0){
        //            cellView.backgroundColor = .orange
        //        }
        //        else{
        //            cellView.backgroundColor = .red
        //        }
        //
        //        //        cellView.initwith(thought: thoughtsArray[indexPath.row])
        //        cell.addSubview(cellView)
        //
        //        cellView.topAnchor.constraint(equalTo: cell.topAnchor, constant: 0).isActive = true
        //        cellView.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: 0).isActive = true
        //        cellView.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 0).isActive = true
        //        cellView.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: 0).isActive = true
//
//        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if ((indexPath.row + 2) == mealsArray.count) && (currentPageNumber < totalPagesNumber) && (isFetchingData == false) {
            currentPageNumber = currentPageNumber + 1
            getRacipes()
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
                self.getRacipes()
//                GlobalMealPlanViewController?.shouldRefresh = true
                SVProgressHUD.dismiss()
            }
            else{
                SVProgressHUD.showError(withStatus: response["message"] as? String)
                self.recipesCollection.reloadData()
            }
        }
        
    }
    
    @objc func filterButtonPressed(sender: UIButton) {
        
        self.present(FilterViewController(), animated: true) {
            
        }
        
    }
    
}


