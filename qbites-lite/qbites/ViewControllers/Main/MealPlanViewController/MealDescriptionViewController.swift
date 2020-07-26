//
//  MealDescriptionViewController.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 12/6/19.
//  Copyright © 2019 Mohammad Bashir sidani. All rights reserved.
//

import Foundation
import SDWebImage

class MealDescriptionViewController: UIViewController, UIScrollViewDelegate {
    
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
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Description"
        label.font = mainFontBold(size: 24)
        label.textColor = .black
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionContentLabel: UILabel = {
        
        let textView = UILabel()
        
        textView.numberOfLines = 0
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showNavigationBar()
        makeNavigationTransparent()
        self.navigationController?.navigationBar.tintColor = .black
//        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        self.title = meal.recipe.name
        
        if(meal.recipe.imageURLsArray.count > 0){
            mealImage.sd_imageIndicator = SDWebImageActivityIndicator.white
            mealImage.sd_setImage(with: URL(string: CloudinaryURLByWidth(url: meal.recipe.imageURLsArray[0], width: 1200) ), placeholderImage: UIImage())
        }
        
        let descriptionAttributedText = (spanStartString + meal.recipe.mealDescription + spanEndString).htmlAttributedString() as! NSMutableAttributedString
        descriptionContentLabel.attributedText = descriptionAttributedText
        
        descriptionContentLabel.textColor = .black
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utilities.sharedInstance.applyBlueGradient(view: self.view)
        
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(contentView)
        
        contentView.addSubview(mealImage)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(descriptionContentLabel)
        
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
        
        
        descriptionLabel.topAnchor.constraint(equalTo: mealImage.bottomAnchor, constant: 10).isActive = true
        descriptionLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1).isActive = true
        
        descriptionContentLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10).isActive = true
        descriptionContentLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        descriptionContentLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20).isActive = true
        
        contentView.bottomAnchor.constraint(equalTo: descriptionContentLabel.bottomAnchor, constant: 30).isActive = true
        
        view.layoutIfNeeded()
//        IngredientsContentLabel.sizeToFit()
        
    }
    
}
