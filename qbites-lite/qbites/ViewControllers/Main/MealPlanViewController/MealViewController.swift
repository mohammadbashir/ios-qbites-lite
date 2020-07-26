//
//  MealViewController.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 10/26/19.
//  Copyright © 2019 Mohammad Bashir sidani. All rights reserved.
//

import Foundation
import UIKit
import ABGaugeViewKit
import SDWebImage
import SVProgressHUD

class MealViewController: UIViewController, UIScrollViewDelegate {
    
    let spanStartString = "<span style=\"font-size: 15; color:white; font-family: '-apple-system', 'GothamMedium'\">"
    let spanEndString = "</span>"
    
    var meal = Meal()
    
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
    
    let mealImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .lightGray
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        return image
    }()
    
    let mealHighlightsView: UIView = {
        let view = UIView()
        //        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let qCalView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let timeImageView: UIImageView = {
        
        let image = UIImageView()
        image.image = UIImage(named: "clock.png")?.mask(with: .black)
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
        
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = mainFontBold(size: 14)
        label.textColor = .black
        label.textAlignment = .center
        //        label.backgroundColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "qCal"
        
        return label
    }()
    
    let kCalView: UIView = {
        let view = UIView()
        //        view.backgroundColor = .green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let kCalCount: UILabel = {
        let label = UILabel()
        label.font = mainFontBold(size: 22)
        label.textColor = .black
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        //        label.backgroundColor = .green
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let kCalLabel: UILabel = {
        let label = UILabel()
        label.font = mainFontBold(size: 14)
        label.textColor = .black
        label.textAlignment = .center
        //        label.backgroundColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        
        label.text = "per serving"
        
        return label
    }()
    
    let guage: ABGaugeView = {
        let guage = ABGaugeView()
        
        guage.translatesAutoresizingMaskIntoConstraints = false
        guage.backgroundColor = .clear
        
        guage.blinkAnimate = false
        guage.colorCodes =  UIColor.red.toHexString() + "," + mainYellowColor.toHexString() + "," + mainGreenColor.toHexString()
        guage.areas = String(GuageRedRatio) + "," + String(GuageYellowRatio) + "," + String(GuageGreenRatio)//"15,25,60"
        guage.needleValue = 100
        
        guage.clipsToBounds = false
        
        return guage
    }()
    
    let guageLabel: UILabel = {
        let label = UILabel()
        label.font = mainFontBold(size: 14)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.text = "qCal"
        return label
    }()
    
    let cookBoookButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "star-off")?.mask(with: UIColor.black), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(starPressed( sender:)),for: .touchUpInside)
        button.tag = 0
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "share")?.mask(with: UIColor.black), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(sharePressed( sender:)),for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let IngredientsLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Ingredients"
        label.font = mainFontBold(size: 24)
        label.textColor = mainGreenColor
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let IngredientsContentLabel: UILabel = {
        
        let textView = UILabel()
        textView.textColor = .black
        textView.numberOfLines = 0
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let instructionsLabel: UILabel = {
        let label = UILabel()
        //        label.backgroundColor = .red
        label.text = "Directions"
        label.font = mainFontBold(size: 24)
        label.textColor = mainGreenColor
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let instructionsContentLabel: UILabel = {
        
        let textView = UILabel()
        textView.textColor = .black
        textView.numberOfLines = 0
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let createdByButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(sourcePressed( sender:)),for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let createdByLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Recipe source: "
        label.font = mainFontItalic(size: 18)
        label.textColor = mainGreenColor
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let createdByImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showNavigationBar()
        makeNavigationTransparent()
        self.navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        self.title = meal.recipe.name
        
        if(meal.recipe.imageURLsArray.count > 0){
            mealImage.sd_imageIndicator = SDWebImageActivityIndicator.white
            mealImage.sd_setImage(with: URL(string: CloudinaryURLByWidth(url: meal.recipe.imageURLsArray[0], width: 1200) ), placeholderImage: UIImage())
        }
        
//        timeImageView.text = String(meal.recipe.qcalPerServing)
        kCalCount.text = String(meal.recipe.kcalPerServing) + " Cal"
        
        guage.needleValue = CGFloat(meal.recipe.qcalToKCalRatioPct)
//        guage.needleValue = CGFloat(Utilities.sharedInstance.getGuageRatio(value: Double(meal.recipe.qcal)/Double(meal.recipe.kcal) ))
        
        if(meal.isFavorite){
            cookBoookButton.setImage(UIImage(named: "star-on"), for: .normal)
            cookBoookButton.tag = 1
        }
        
        //ingredients
        var ingredientsString = "<ul>"
        
        for (i, _) in meal.recipe.ingredients.enumerated(){
            ingredientsString = ingredientsString + "<li>" + "<b>" + meal.recipe.ingredients[i].quantity + " " + meal.recipe.ingredients[i].unit + " " + "</b>" + "\t\t" + meal.recipe.ingredients[i].name + "</li>"
        }
        
        ingredientsString = ingredientsString + "</ul>"
        
        let instructionsAttributedText = (spanStartString + ingredientsString + spanEndString).htmlAttributedString() as! NSMutableAttributedString
        IngredientsContentLabel.attributedText = instructionsAttributedText
        
        let directionsAttributedText = (spanStartString + meal.recipe.instructions + spanEndString).htmlAttributedString() as! NSMutableAttributedString
        instructionsContentLabel.attributedText = directionsAttributedText
        
        IngredientsContentLabel.textColor = .black
        instructionsContentLabel.textColor = .black
        
        if(meal.recipe.numberServings > 0){
            IngredientsLabel.text = (IngredientsLabel.text ?? "") + " ("
            IngredientsLabel.text = (IngredientsLabel.text ?? "") + String(meal.recipe.numberServings) + " Servings)"
        }
        
        timeLabel.text = meal.recipe.preparationTimeDisplay
        
        if(meal.recipe.publisher != ""){
            createdByLabel.text = createdByLabel.text! + meal.recipe.publisher
            createdByLabel.isHidden = false
        }
        else{
            createdByLabel.isHidden = true
        }
        
        if(meal.recipe.sourceImageUrl != ""){
            createdByImageView.sd_setImage(with: URL(string: CloudinaryURLByWidth(url: meal.recipe.sourceImageUrl, width: 500) ), placeholderImage: UIImage())
        } else{
            createdByImageView.isHidden = true
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utilities.sharedInstance.applyBlueGradient(view: self.view)
        
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(contentView)
        
        contentView.addSubview(mealImage)
        contentView.addSubview(mealHighlightsView)
        
        mealHighlightsView.addSubview(qCalView)
        qCalView.addSubview(timeImageView)
        qCalView.addSubview(timeLabel)
        
        mealHighlightsView.addSubview(kCalView)
        kCalView.addSubview(kCalCount)
        kCalView.addSubview(kCalLabel)
        
        mealHighlightsView.addSubview(guage)
        mealHighlightsView.addSubview(guageLabel)
        
        mealHighlightsView.addSubview(cookBoookButton)
        mealHighlightsView.addSubview(shareButton)
        
        contentView.addSubview(IngredientsLabel)
        contentView.addSubview(IngredientsContentLabel)
        contentView.addSubview(instructionsLabel)
        contentView.addSubview(instructionsContentLabel)
        
        contentView.addSubview(createdByButton)
        createdByButton.addSubview(createdByLabel)
        createdByButton.addSubview(createdByImageView)
        
        layoutViews()
        
        
        
    }
    
    func layoutViews(){
        
        mainScrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainScrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: Utilities.sharedInstance.SafeAreaTopInset() + (self.navigationController?.navigationBar.frame.size.height ?? 0)).isActive = true
        mainScrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        contentView.topAnchor.constraint(equalTo: mainScrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: mainScrollView.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: mainScrollView.rightAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor).isActive = true
        
        mealImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1).isActive = true
        mealImage.heightAnchor.constraint(equalTo: mealImage.widthAnchor, multiplier: 9/16).isActive = true
        mealImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        
        mealHighlightsView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1).isActive = true
        mealHighlightsView.topAnchor.constraint(equalTo: mealImage.bottomAnchor, constant: 10).isActive = true
        mealHighlightsView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        qCalView.leftAnchor.constraint(equalTo: mealHighlightsView.leftAnchor, constant: 0).isActive = true
        qCalView.heightAnchor.constraint(equalTo: mealHighlightsView.heightAnchor, constant: 0).isActive = true
        qCalView.widthAnchor.constraint(equalTo: mealHighlightsView.widthAnchor, multiplier: 0.2).isActive = true
        
        timeImageView.leftAnchor.constraint(equalTo: qCalView.leftAnchor, constant: 0).isActive = true
        timeImageView.rightAnchor.constraint(equalTo: qCalView.rightAnchor, constant: 0).isActive = true
        timeImageView.heightAnchor.constraint(equalTo: qCalView.heightAnchor, multiplier: 0.7).isActive = true
        timeImageView.topAnchor.constraint(equalTo: qCalView.topAnchor, constant: 0).isActive = true
        
        timeLabel.leftAnchor.constraint(equalTo: timeImageView.leftAnchor, constant: 0).isActive = true
        timeLabel.rightAnchor.constraint(equalTo: timeImageView.rightAnchor, constant: 0).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: qCalView.heightAnchor, multiplier: 0.3).isActive = true
        timeLabel.topAnchor.constraint(equalTo: timeImageView.bottomAnchor, constant: 0).isActive = true
        
        kCalView.leftAnchor.constraint(equalTo: qCalView.rightAnchor, constant: 0).isActive = true
        kCalView.heightAnchor.constraint(equalTo: mealHighlightsView.heightAnchor, constant: 0).isActive = true
        kCalView.widthAnchor.constraint(equalTo: mealHighlightsView.widthAnchor, multiplier: 0.2).isActive = true
        
        kCalCount.leftAnchor.constraint(equalTo: kCalView.leftAnchor, constant: 0).isActive = true
        kCalCount.widthAnchor.constraint(equalTo: kCalView.widthAnchor, constant: -10).isActive = true
        kCalCount.heightAnchor.constraint(equalTo: kCalView.heightAnchor, multiplier: 0.7).isActive = true
        kCalCount.topAnchor.constraint(equalTo: kCalView.topAnchor, constant: 0).isActive = true
        
        kCalLabel.leftAnchor.constraint(equalTo: kCalCount.leftAnchor, constant: 0).isActive = true
        kCalLabel.rightAnchor.constraint(equalTo: kCalCount.rightAnchor, constant: 0).isActive = true
        kCalLabel.heightAnchor.constraint(equalTo: kCalView.heightAnchor, multiplier: 0.3).isActive = true
        kCalLabel.topAnchor.constraint(equalTo: kCalCount.bottomAnchor, constant: 0).isActive = true
        
        guage.leftAnchor.constraint(equalTo: kCalView.rightAnchor, constant: 0).isActive = true
        guage.centerYAnchor.constraint(equalTo: mealHighlightsView.centerYAnchor, constant: 5).isActive = true
        guage.heightAnchor.constraint(equalTo: mealHighlightsView.heightAnchor, constant: 15).isActive = true
        guage.widthAnchor.constraint(equalTo: guage.heightAnchor, multiplier: 1.0).isActive = true
        
        guageLabel.centerXAnchor.constraint(equalTo: guage.centerXAnchor, constant: 0).isActive = true
        guageLabel.bottomAnchor.constraint(equalTo: mealHighlightsView.bottomAnchor, constant: 0).isActive = true
        guageLabel.heightAnchor.constraint(equalTo: timeLabel.heightAnchor, constant: 0).isActive = true
        
        cookBoookButton.leftAnchor.constraint(equalTo: guage.rightAnchor, constant: 0).isActive = true
        cookBoookButton.heightAnchor.constraint(equalTo: mealHighlightsView.heightAnchor, multiplier: 0.7).isActive = true
        cookBoookButton.centerYAnchor.constraint(equalTo: mealHighlightsView.centerYAnchor, constant: 0).isActive = true
        cookBoookButton.widthAnchor.constraint(equalTo: mealHighlightsView.widthAnchor, multiplier: 0.2).isActive = true
        
        shareButton.leftAnchor.constraint(equalTo: cookBoookButton.rightAnchor, constant: 0).isActive = true
        shareButton.heightAnchor.constraint(equalTo: mealHighlightsView.heightAnchor, multiplier: 0.7).isActive = true
        shareButton.centerYAnchor.constraint(equalTo: mealHighlightsView.centerYAnchor, constant: 0).isActive = true
        shareButton.widthAnchor.constraint(equalTo: mealHighlightsView.widthAnchor, multiplier: 0.2).isActive = true
        
        IngredientsLabel.topAnchor.constraint(equalTo: mealHighlightsView.bottomAnchor, constant: 25).isActive = true
        IngredientsLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1).isActive = true
        
        IngredientsContentLabel.topAnchor.constraint(equalTo: IngredientsLabel.bottomAnchor, constant: 10).isActive = true
        IngredientsContentLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: 0).isActive = true
        
        instructionsLabel.topAnchor.constraint(equalTo: IngredientsContentLabel.bottomAnchor, constant: 10).isActive = true
        instructionsLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: 0).isActive = true
        
        instructionsContentLabel.topAnchor.constraint(equalTo: instructionsLabel.bottomAnchor, constant: 10).isActive = true
        instructionsContentLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        instructionsContentLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20).isActive = true
        
        createdByButton.topAnchor.constraint(equalTo: instructionsContentLabel.bottomAnchor, constant: 10).isActive = true
        createdByButton.centerXAnchor.constraint(equalTo: instructionsContentLabel.centerXAnchor, constant: 0).isActive = true
        createdByButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20).isActive = true
        
        createdByLabel.topAnchor.constraint(equalTo: createdByButton.topAnchor, constant: 0).isActive = true
        createdByLabel.centerXAnchor.constraint(equalTo: createdByButton.centerXAnchor, constant: 0).isActive = true
        createdByLabel.widthAnchor.constraint(equalTo: createdByButton.widthAnchor, constant: 0).isActive = true
        
        createdByImageView.topAnchor.constraint(equalTo: createdByLabel.bottomAnchor, constant: 10).isActive = true
        createdByImageView.centerXAnchor.constraint(equalTo: createdByButton.centerXAnchor, constant: 0).isActive = true
        createdByImageView.widthAnchor.constraint(equalTo: createdByButton.widthAnchor, constant: 0).isActive = true
        
        if(meal.recipe.sourceImageUrl != ""){
            createdByImageView.heightAnchor.constraint(equalTo: createdByImageView.widthAnchor, multiplier: 9/16).isActive = true
        } else {
            createdByImageView.heightAnchor.constraint(equalTo: createdByImageView.widthAnchor, multiplier: 0).isActive = true
        }
        
        createdByButton.bottomAnchor.constraint(equalTo: createdByImageView.bottomAnchor, constant: 0).isActive = true
        
        contentView.bottomAnchor.constraint(equalTo: createdByButton.bottomAnchor, constant: 30).isActive = true
        
        view.layoutIfNeeded()
        
    }
    
    @objc func starPressed(sender: UIButton){
        
        if(sender.tag == 0){
            SVProgressHUD.show()
            RequestHelper.sharedInstance.favouriteRecepie(recepieId: meal.recipe.id, isFavorite: true) { (response) in
                if(response["success"] as? Bool == true){
                    SVProgressHUD.showSuccess(withStatus: "Added to cookbook!")
                    sender.setImage(UIImage(named: "star-on"), for: .normal)
                    sender.tag = 1
                    self.meal.isFavorite = true
                    
                    if let mealPlans = GlobalMealPlanViewController?.mealPlanArray {
                        for (i, plan) in mealPlans.enumerated() {
                            
                            for (j, meal) in plan.mealsArray.enumerated(){
                                
                                if(meal.recipe.id == self.meal.recipe.id){
                                    GlobalMealPlanViewController?.mealPlanArray[i].mealsArray[j].isFavorite = true
                                }
                            }
                        }
                    }
                    
                    GlobalCookBookViewController?.shouldRefresh = true
                    
                }
                else{
                    SVProgressHUD.showError(withStatus: response["message"] as? String)
                }
            }
            
        }
        else{
            SVProgressHUD.show()
            RequestHelper.sharedInstance.favouriteRecepie(recepieId: meal.recipe.id, isFavorite: false) { (response) in
                if(response["success"] as? Bool == true){
                    SVProgressHUD.showSuccess(withStatus: "Removed from cookbook")
                    sender.setImage(UIImage(named: "star-off")?.mask(with: UIColor.black), for: .normal)
                    sender.tag = 0
                    self.meal.isFavorite = false
                    
                    if let mealPlans = GlobalMealPlanViewController?.mealPlanArray {
                        for (i, plan) in mealPlans.enumerated() {
                            
                            for (j, meal) in plan.mealsArray.enumerated(){
                                
                                if(meal.recipe.id == self.meal.recipe.id){
                                    GlobalMealPlanViewController?.mealPlanArray[i].mealsArray[j].isFavorite = false
                                }
                            }
                            
                        }
                    }
                    
                    GlobalCookBookViewController?.shouldRefresh = true
                    
                }
                else{
                    SVProgressHUD.showError(withStatus: response["message"] as? String)
                }
            }
            
        }
        
    }
    
    @objc func sharePressed(sender: UIButton){
        
        SVProgressHUD.show()
        RequestHelper.sharedInstance.getRecepieShareTemplate(recepieId: meal.recipe.id) { (response) in
            if(response["success"] as? Bool == true){
                SVProgressHUD.dismiss()
                
                var activityArray = [Any]()
                activityArray.append(response["template"] as! String)
                
//                if let image = self.mealImage.image {
//                    activityArray.append(image)
//                }
                
                
                let activityViewController : UIActivityViewController = UIActivityViewController(
                    activityItems: activityArray, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = (sender )
                
                self.present(activityViewController, animated: true, completion: nil)
            }
            else{
                SVProgressHUD.showError(withStatus: response["message"] as? String)
            }
        }
        
    }
    
    @objc func sourcePressed(sender: UIButton){
        if(meal.recipe.sourceUrl != ""){
            let webVC = WebViewController()
            webVC.webView.load(NSURLRequest(url: NSURL(string: meal.recipe.sourceUrl)! as URL) as URLRequest)
            self.present(webVC, animated: true) {}
        }
    }
    
}


