//
//  FilterViewController.swift
//  qbites Lite
//
//  Created by Mohammad Bashir sidani on 6/7/20.
//  Copyright © 2020 Mohammad Bashir sidani. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField
import SVProgressHUD

class FilterViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate  {
    
    var cuisinesArray = [Cuisine]()
    
//    var selectedCuisinesData = UserDefaults.standard.data(forKey: filtersCuisinesArrayKey)
    var selectedCuisinesArray = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.data(forKey: filtersCuisinesArrayKey)!) as! [Cuisine]
    
    var didChangeSelection = false
    
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
    
    let filtersTitle: UILabel = {
        
        let label = UILabel()
        label.font = mainFontBold(size: 35)
        label.textColor = .black
        label.text = "Filters"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
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
    
    let courseLabel: UILabel = {
        
        let label = UILabel()
        label.font = mainFontBold(size: 20)
        label.textColor = .black
        label.text = "Course"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    let breakfastSwitch: UISwitch = {
        
        let switchh = UISwitch()
        switchh.tag = 0
        
        DispatchQueue.main.async {
            switchh.setOn(UserDefaults.standard.bool(forKey: filtersBreakfastKey), animated: false)
        }
        
        switchh.addTarget(self, action: #selector(switchValueDidChange( sender:)), for: .valueChanged)
        switchh.translatesAutoresizingMaskIntoConstraints = false
        return switchh
        
    }()
    
    let breakfastLabel: UILabel = {
        
        let label = UILabel()
        label.font = mainFont(size: 14)
        label.textColor = .black
        label.text = "Breakfast"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    let lunchSwitch: UISwitch = {
        
        let switchh = UISwitch()
        switchh.tag = 1
        
        DispatchQueue.main.async {
            switchh.setOn(UserDefaults.standard.bool(forKey: filtersLunchKey), animated: false)
        }
        
        switchh.addTarget(self, action: #selector(switchValueDidChange( sender:)), for: .valueChanged)
        switchh.translatesAutoresizingMaskIntoConstraints = false
        return switchh
        
    }()
    
    let lunchLabel: UILabel = {
        
        let label = UILabel()
        label.font = mainFont(size: 14)
        label.textColor = .black
        label.text = "Lunch"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    let dinnerSwitch: UISwitch = {
        
        let switchh = UISwitch()
        switchh.tag = 2
        
        DispatchQueue.main.async {
            switchh.setOn(UserDefaults.standard.bool(forKey: filtersDinnerKey), animated: false)
        }
        
        switchh.addTarget(self, action: #selector(switchValueDidChange( sender:)), for: .valueChanged)
        switchh.translatesAutoresizingMaskIntoConstraints = false
        return switchh
        
    }()
    
    let dinnerLabel: UILabel = {
        
        let label = UILabel()
        label.font = mainFont(size: 14)
        label.textColor = .black
        label.text = "Dinner"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    let snackSwitch: UISwitch = {
        
        let switchh = UISwitch()
        switchh.tag = 3
        
        DispatchQueue.main.async {
            switchh.setOn(UserDefaults.standard.bool(forKey: filtersSnackKey), animated: false)
        }
        
        switchh.addTarget(self, action: #selector(switchValueDidChange( sender:)), for: .valueChanged)
        switchh.translatesAutoresizingMaskIntoConstraints = false
        return switchh
        
    }()
    
    let snackLabel: UILabel = {
        
        let label = UILabel()
        label.font = mainFont(size: 14)
        label.textColor = .black
        label.text = "Snack"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    let preferencesLabel: UILabel = {
        
        let label = UILabel()
        label.font = mainFontBold(size: 20)
        label.textColor = .black
        label.text = "Preferences"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    let vegetarianSwitch: UISwitch = {
        
        let switchh = UISwitch()
        switchh.tag = 4
        
        DispatchQueue.main.async {
            switchh.setOn(UserDefaults.standard.bool(forKey: filtersVegeterianKey), animated: false)
        }
        
        switchh.addTarget(self, action: #selector(switchValueDidChange( sender:)), for: .valueChanged)
        switchh.translatesAutoresizingMaskIntoConstraints = false
        return switchh
        
    }()
    
    let vegetarianLabel: UILabel = {
        
        let label = UILabel()
        label.font = mainFont(size: 14)
        label.textColor = .black
        label.text = "Vegetarian"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    let veganSwitch: UISwitch = {
        
        let switchh = UISwitch()
        switchh.tag = 5
        
        DispatchQueue.main.async {
            switchh.setOn(UserDefaults.standard.bool(forKey: filtersVeganKey), animated: false)
        }
        
        switchh.addTarget(self, action: #selector(switchValueDidChange( sender:)), for: .valueChanged)
        switchh.translatesAutoresizingMaskIntoConstraints = false
        return switchh
        
    }()
    
    let veganLabel: UILabel = {
        
        let label = UILabel()
        label.font = mainFont(size: 14)
        label.textColor = .black
        label.text = "Vegan"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    let porkFreeSwitch: UISwitch = {
        
        let switchh = UISwitch()
        switchh.tag = 6
        
        DispatchQueue.main.async {
            switchh.setOn(UserDefaults.standard.bool(forKey: filtersPorkFreeKey), animated: false)
        }
        
        switchh.addTarget(self, action: #selector(switchValueDidChange( sender:)), for: .valueChanged)
        switchh.translatesAutoresizingMaskIntoConstraints = false
        return switchh
        
    }()
    
    let porkFreeLabel: UILabel = {
        
        let label = UILabel()
        label.font = mainFont(size: 14)
        label.textColor = .black
        label.text = "Pork Free"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    let quickRecipesSwitch: UISwitch = {
        
        let switchh = UISwitch()
        switchh.tag = 7
        
        DispatchQueue.main.async {
            switchh.setOn(UserDefaults.standard.bool(forKey: filtersQuickRecipesKey), animated: false)
        }
        
        switchh.addTarget(self, action: #selector(switchValueDidChange( sender:)), for: .valueChanged)
        switchh.translatesAutoresizingMaskIntoConstraints = false
        return switchh
        
    }()
    
    let quickRecipesLabel: UILabel = {
        
        let label = UILabel()
        label.font = mainFont(size: 14)
        label.textColor = .black
        label.text = "Quick Recipes (30 mins or less)"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
//    let healthLabel: UILabel = {
//
//        let label = UILabel()
//        label.font = mainFontBold(size: 20)
//        label.textColor = .black
//        label.text = "Quality"
//
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//
//    }()
//
//    let healthView: UIView = {
//
//        let view = UIView()
//        view.backgroundColor = mainLightGrayColor.withAlphaComponent(0.5)
//        view.layer.cornerRadius = 15
//
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//
//    }()
//
//    let healthGoldButton: UIButton = {
//
//        let button = UIButton()
//        button.layer.cornerRadius = 15
//
//        button.tag = 0
//
//        if(UserDefaults.standard.bool(forKey: filtersGoldkey) == true){
//            button.tag = 1
//            button.backgroundColor = .white
//        }
//
//        button.addTarget(self, action: #selector(goldPressed( sender:)),for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//
//    }()
//
//    let healthGoldImageView: UIImageView = {
//
//        let image = UIImageView()
//        image.contentMode = .scaleAspectFit
//
//        image.image = UIImage(named: "qcal.png")?.mask(with: mainGoldColor)
//
//        image.translatesAutoresizingMaskIntoConstraints = false
//        return image
//
//    }()
//
//    let healthGoldLabel: UILabel = {
//
//        let label = UILabel()
//        label.isUserInteractionEnabled = false
//        label.adjustsFontSizeToFitWidth = true
//        label.textAlignment = .center
//        label.font = mainFontBold(size: 12)
//        label.text = "Gold"
//        label.textColor = mainGoldColor
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//
//    }()
//
//    let healthSilverButton: UIButton = {
//
//        let button = UIButton()
//        button.layer.cornerRadius = 15
//
//        button.tag = 0
//
//        if(UserDefaults.standard.bool(forKey: filtersSilverKey) == true){
//            button.tag = 1
//            button.backgroundColor = .white
//        }
//
//        button.addTarget(self, action: #selector(silverPressed( sender:)),for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//
//    }()
//
//    let healthSilverImageView: UIImageView = {
//
//        let image = UIImageView()
//        image.contentMode = .scaleAspectFit
//
//        image.image = UIImage(named: "qcal.png")?.mask(with: mainSilverColor)
//
//        image.translatesAutoresizingMaskIntoConstraints = false
//        return image
//
//    }()
//
//    let healthSilverLabel: UILabel = {
//
//        let label = UILabel()
//        label.isUserInteractionEnabled = false
//        label.adjustsFontSizeToFitWidth = true
//        label.textAlignment = .center
//        label.font = mainFontBold(size: 12)
//        label.text = "Silver"
//        label.textColor = mainSilverColor
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//
//    }()
//
//    let healthBronzeButton: UIButton = {
//
//        let button = UIButton()
//        button.layer.cornerRadius = 15
//
//        button.tag = 0
//
//        if(UserDefaults.standard.bool(forKey: filtersBronzeKey) == true){
//            button.tag = 1
//            button.backgroundColor = .white
//        }
//
//        button.addTarget(self, action: #selector(bronzePressed( sender:)),for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//
//    }()
//
//    let healthBronzeImageView: UIImageView = {
//
//        let image = UIImageView()
//        image.contentMode = .scaleAspectFit
//
//        image.image = UIImage(named: "qcal.png")?.mask(with: mainBronzeColor)
//
//        image.translatesAutoresizingMaskIntoConstraints = false
//        return image
//
//    }()
//
//    let healthBronzeLabel: UILabel = {
//
//        let label = UILabel()
//        label.isUserInteractionEnabled = false
//        label.adjustsFontSizeToFitWidth = true
//        label.textAlignment = .center
//        label.font = mainFontBold(size: 12)
//        label.text = "Bronze"
//        label.textColor = mainBronzeColor
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//
//    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow( notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide( notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //listen to observers
        NotificationCenter.default.addObserver(self, selector: #selector(multipleCuisinesSelected(_:)), name: NSNotification.Name(rawValue: "multipleCuisinesSelected"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        //remove observers
        NotificationCenter.default.removeObserver(self)
        
        if(didChangeSelection){
            GlobalRecipesViewController?.shouldRefresh = true
            GlobalRecipesViewController?.getRacipes()
        }
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//
//        if(didChangeSelection){
//            GlobalRecipesViewController?.getRacipes()
//        }
//    }
    
    @objc func keyboardWillShow(notification: Notification){
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            mainScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight - (self.view.frame.size.height - mainScrollView.frame.size.height), right: 0)
            mainScrollView.scrollIndicatorInsets = mainScrollView.contentInset
        }
    }
    
    @objc func keyboardWillHide(notification: Notification){
        mainScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        mainScrollView.scrollIndicatorInsets = mainScrollView.contentInset
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(contentView)
        
        contentView.addSubview(filtersTitle)
        contentView.addSubview(cuisinesField)
        contentView.addSubview(courseLabel)
        
        contentView.addSubview(breakfastSwitch)
        contentView.addSubview(breakfastLabel)
        
        contentView.addSubview(lunchSwitch)
        contentView.addSubview(lunchLabel)
        
        contentView.addSubview(dinnerSwitch)
        contentView.addSubview(dinnerLabel)
        
        contentView.addSubview(snackSwitch)
        contentView.addSubview(snackLabel)
        
        contentView.addSubview(preferencesLabel)
        
        contentView.addSubview(vegetarianSwitch)
        contentView.addSubview(vegetarianLabel)
        
        contentView.addSubview(veganSwitch)
        contentView.addSubview(veganLabel)
        
        contentView.addSubview(porkFreeSwitch)
        contentView.addSubview(porkFreeLabel)
        
        contentView.addSubview(quickRecipesSwitch)
        contentView.addSubview(quickRecipesLabel)
        
//        contentView.addSubview(healthLabel)
//        contentView.addSubview(healthView)
//
//        healthView.addSubview(healthGoldButton)
//        healthView.addSubview(healthSilverButton)
//        healthView.addSubview(healthBronzeButton)
//
//        healthGoldButton.addSubview(healthGoldImageView)
//        healthGoldButton.addSubview(healthGoldLabel)
//
//        healthSilverButton.addSubview(healthSilverImageView)
//        healthSilverButton.addSubview(healthSilverLabel)
//
//        healthBronzeButton.addSubview(healthBronzeImageView)
//        healthBronzeButton.addSubview(healthBronzeLabel)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutViews()
        populateCuisinesTextField()
        //        getRankings()
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
        
        filtersTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        filtersTitle.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 7).isActive = true
        
        cuisinesField.topAnchor.constraint(equalTo: filtersTitle.bottomAnchor, constant: 20).isActive = true
        cuisinesField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        cuisinesField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9).isActive = true
        
        courseLabel.topAnchor.constraint(equalTo: cuisinesField.bottomAnchor, constant: 30).isActive = true
        courseLabel.leftAnchor.constraint(equalTo: filtersTitle.leftAnchor, constant: 0).isActive = true
        
        breakfastSwitch.topAnchor.constraint(equalTo: courseLabel.bottomAnchor, constant: 20).isActive = true
        breakfastSwitch.leftAnchor.constraint(equalTo: courseLabel.leftAnchor, constant: 0).isActive = true
        breakfastLabel.centerYAnchor.constraint(equalTo: breakfastSwitch.centerYAnchor).isActive = true
        breakfastLabel.leftAnchor.constraint(equalTo: breakfastSwitch.rightAnchor, constant: 10).isActive = true
        
        lunchSwitch.topAnchor.constraint(equalTo: breakfastSwitch.bottomAnchor, constant: 20).isActive = true
        lunchSwitch.leftAnchor.constraint(equalTo: breakfastSwitch.leftAnchor, constant: 0).isActive = true
        lunchLabel.centerYAnchor.constraint(equalTo: lunchSwitch.centerYAnchor).isActive = true
        lunchLabel.leftAnchor.constraint(equalTo: lunchSwitch.rightAnchor, constant: 10).isActive = true
        
        dinnerSwitch.topAnchor.constraint(equalTo: lunchSwitch.bottomAnchor, constant: 20).isActive = true
        dinnerSwitch.leftAnchor.constraint(equalTo: breakfastSwitch.leftAnchor, constant: 0).isActive = true
        dinnerLabel.centerYAnchor.constraint(equalTo: dinnerSwitch.centerYAnchor).isActive = true
        dinnerLabel.leftAnchor.constraint(equalTo: dinnerSwitch.rightAnchor, constant: 10).isActive = true
        
        snackSwitch.topAnchor.constraint(equalTo: dinnerSwitch.bottomAnchor, constant: 20).isActive = true
        snackSwitch.leftAnchor.constraint(equalTo: breakfastSwitch.leftAnchor, constant: 0).isActive = true
        snackLabel.centerYAnchor.constraint(equalTo: snackSwitch.centerYAnchor).isActive = true
        snackLabel.leftAnchor.constraint(equalTo: snackSwitch.rightAnchor, constant: 10).isActive = true
        
        preferencesLabel.topAnchor.constraint(equalTo: snackSwitch.bottomAnchor, constant: 20).isActive = true
        preferencesLabel.leftAnchor.constraint(equalTo: courseLabel.leftAnchor).isActive = true
        
        vegetarianSwitch.topAnchor.constraint(equalTo: preferencesLabel.bottomAnchor, constant: 20).isActive = true
        vegetarianSwitch.leftAnchor.constraint(equalTo: preferencesLabel.leftAnchor, constant: 0).isActive = true
        vegetarianLabel.centerYAnchor.constraint(equalTo: vegetarianSwitch.centerYAnchor).isActive = true
        vegetarianLabel.leftAnchor.constraint(equalTo: vegetarianSwitch.rightAnchor, constant: 10).isActive = true
        
        veganSwitch.topAnchor.constraint(equalTo: vegetarianSwitch.bottomAnchor, constant: 20).isActive = true
        veganSwitch.leftAnchor.constraint(equalTo: vegetarianSwitch.leftAnchor, constant: 0).isActive = true
        veganLabel.centerYAnchor.constraint(equalTo: veganSwitch.centerYAnchor).isActive = true
        veganLabel.leftAnchor.constraint(equalTo: veganSwitch.rightAnchor, constant: 10).isActive = true
        
        porkFreeSwitch.topAnchor.constraint(equalTo: veganSwitch.bottomAnchor, constant: 20).isActive = true
        porkFreeSwitch.leftAnchor.constraint(equalTo: vegetarianSwitch.leftAnchor, constant: 0).isActive = true
        porkFreeLabel.centerYAnchor.constraint(equalTo: porkFreeSwitch.centerYAnchor).isActive = true
        porkFreeLabel.leftAnchor.constraint(equalTo: porkFreeSwitch.rightAnchor, constant: 10).isActive = true
        
        quickRecipesSwitch.topAnchor.constraint(equalTo: porkFreeSwitch.bottomAnchor, constant: 20).isActive = true
        quickRecipesSwitch.leftAnchor.constraint(equalTo: vegetarianSwitch.leftAnchor, constant: 0).isActive = true
        quickRecipesLabel.centerYAnchor.constraint(equalTo: quickRecipesSwitch.centerYAnchor).isActive = true
        quickRecipesLabel.leftAnchor.constraint(equalTo: quickRecipesSwitch.rightAnchor, constant: 10).isActive = true
        
//        healthLabel.topAnchor.constraint(equalTo: quickRecipesSwitch.bottomAnchor, constant: 20).isActive = true
//        healthLabel.leftAnchor.constraint(equalTo: courseLabel.leftAnchor).isActive = true
//
//        healthView.topAnchor.constraint(equalTo: healthLabel.bottomAnchor, constant: 20).isActive = true
//        healthView.heightAnchor.constraint(equalToConstant: 70).isActive = true
//        healthView.leftAnchor.constraint(equalTo: cuisinesField.leftAnchor, constant: 0).isActive = true
//        healthView.rightAnchor.constraint(equalTo: cuisinesField.rightAnchor, constant: 0).isActive = true
//
//        let healthSpacingOffset = CGFloat(5)
//
//        healthGoldButton.topAnchor.constraint(equalTo: healthView.topAnchor, constant: healthSpacingOffset).isActive = true
//        healthGoldButton.bottomAnchor.constraint(equalTo: healthView.bottomAnchor, constant: -healthSpacingOffset).isActive = true
//        healthGoldButton.leftAnchor.constraint(equalTo: healthView.leftAnchor, constant: healthSpacingOffset).isActive = true
//        healthGoldButton.widthAnchor.constraint(equalTo: healthView.widthAnchor, multiplier: 1/3, constant: -20/3).isActive = true
//
//        healthGoldImageView.leftAnchor.constraint(equalTo: healthGoldButton.leftAnchor).isActive = true
//        healthGoldImageView.rightAnchor.constraint(equalTo: healthGoldButton.rightAnchor).isActive = true
//        healthGoldImageView.topAnchor.constraint(equalTo: healthGoldButton.topAnchor, constant: 3).isActive = true
//        healthGoldImageView.bottomAnchor.constraint(equalTo: healthGoldButton.bottomAnchor, constant: -20).isActive = true
//
//        healthGoldLabel.leftAnchor.constraint(equalTo: healthGoldButton.leftAnchor, constant: 3).isActive = true
//        healthGoldLabel.rightAnchor.constraint(equalTo: healthGoldButton.rightAnchor, constant: -3).isActive = true
//        healthGoldLabel.topAnchor.constraint(equalTo: healthGoldImageView.bottomAnchor, constant: 3).isActive = true
//        healthGoldLabel.bottomAnchor.constraint(equalTo: healthGoldButton.bottomAnchor, constant: -3).isActive = true
//
//        healthSilverButton.topAnchor.constraint(equalTo: healthGoldButton.topAnchor).isActive = true
//        healthSilverButton.widthAnchor.constraint(equalTo: healthGoldButton.widthAnchor).isActive = true
//        healthSilverButton.heightAnchor.constraint(equalTo: healthGoldButton.heightAnchor).isActive = true
//        healthSilverButton.leftAnchor.constraint(equalTo: healthGoldButton.rightAnchor, constant: healthSpacingOffset).isActive = true
//
//        healthSilverImageView.leftAnchor.constraint(equalTo: healthSilverButton.leftAnchor).isActive = true
//        healthSilverImageView.rightAnchor.constraint(equalTo: healthSilverButton.rightAnchor).isActive = true
//        healthSilverImageView.topAnchor.constraint(equalTo: healthSilverButton.topAnchor, constant: 3).isActive = true
//        healthSilverImageView.bottomAnchor.constraint(equalTo: healthSilverButton.bottomAnchor, constant: -20).isActive = true
//
//        healthSilverLabel.leftAnchor.constraint(equalTo: healthSilverButton.leftAnchor, constant: 3).isActive = true
//        healthSilverLabel.rightAnchor.constraint(equalTo: healthSilverButton.rightAnchor, constant: -3).isActive = true
//        healthSilverLabel.topAnchor.constraint(equalTo: healthSilverImageView.bottomAnchor, constant: 3).isActive = true
//        healthSilverLabel.bottomAnchor.constraint(equalTo: healthSilverButton.bottomAnchor, constant: -3).isActive = true
//
//        healthBronzeButton.topAnchor.constraint(equalTo: healthGoldButton.topAnchor).isActive = true
//        healthBronzeButton.widthAnchor.constraint(equalTo: healthGoldButton.widthAnchor).isActive = true
//        healthBronzeButton.heightAnchor.constraint(equalTo: healthGoldButton.heightAnchor).isActive = true
//        healthBronzeButton.leftAnchor.constraint(equalTo: healthSilverButton.rightAnchor, constant: healthSpacingOffset).isActive = true
//
//        healthBronzeImageView.leftAnchor.constraint(equalTo: healthBronzeButton.leftAnchor).isActive = true
//        healthBronzeImageView.rightAnchor.constraint(equalTo: healthBronzeButton.rightAnchor).isActive = true
//        healthBronzeImageView.topAnchor.constraint(equalTo: healthBronzeButton.topAnchor, constant: 3).isActive = true
//        healthBronzeImageView.bottomAnchor.constraint(equalTo: healthBronzeButton.bottomAnchor, constant: -20).isActive = true
//
//        healthBronzeLabel.leftAnchor.constraint(equalTo: healthBronzeButton.leftAnchor, constant: 3).isActive = true
//        healthBronzeLabel.rightAnchor.constraint(equalTo: healthBronzeButton.rightAnchor, constant: -3).isActive = true
//        healthBronzeLabel.topAnchor.constraint(equalTo: healthBronzeImageView.bottomAnchor, constant: 3).isActive = true
//        healthBronzeLabel.bottomAnchor.constraint(equalTo: healthBronzeButton.bottomAnchor, constant: -3).isActive = true
        
        contentView.bottomAnchor.constraint(equalTo: quickRecipesLabel.bottomAnchor, constant: 10).isActive = true
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
        
        didChangeSelection = true
        
        if let dict = notification.userInfo as NSDictionary? {
            if let cuisines = dict["cuisines"] as? [Cuisine]{
                selectedCuisinesArray = cuisines
                
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: selectedCuisinesArray)
                UserDefaults.standard.set(encodedData, forKey: filtersCuisinesArrayKey)
                UserDefaults.standard.synchronize()
            }
            
            populateCuisinesTextField()
        }
        
        //        getRankings()
    }
    
    func populateCuisinesTextField(){
        
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
    
    @objc func switchValueDidChange (sender: UISwitch){
        
        didChangeSelection = true
        
        if(sender.tag == 0){
            UserDefaults.standard.set(sender.isOn, forKey: filtersBreakfastKey)
        }
        else if(sender.tag == 1){
            UserDefaults.standard.set(sender.isOn, forKey: filtersLunchKey)
        }
        else if(sender.tag == 2){
            UserDefaults.standard.set(sender.isOn, forKey: filtersDinnerKey)
        }
        else if(sender.tag == 3){
            UserDefaults.standard.set(sender.isOn, forKey: filtersSnackKey)
        }
        else if(sender.tag == 4){
            UserDefaults.standard.set(sender.isOn, forKey: filtersVegeterianKey)
        }
        else if(sender.tag == 5){
            UserDefaults.standard.set(sender.isOn, forKey: filtersVeganKey)
        }
        else if(sender.tag == 6){
            UserDefaults.standard.set(sender.isOn, forKey: filtersPorkFreeKey)
        }
        else if(sender.tag == 7){
            UserDefaults.standard.set(sender.isOn, forKey: filtersQuickRecipesKey)
        }
        
        UserDefaults.standard.synchronize()
    }
    
    @objc func goldPressed(sender: UIButton){
        medalButtonPressed(sender: sender, key: filtersGoldkey)
    }
    
    @objc func silverPressed(sender: UIButton){
        medalButtonPressed(sender: sender, key: filtersSilverKey)
    }
    
    @objc func bronzePressed(sender: UIButton){
        medalButtonPressed(sender: sender, key: filtersBronzeKey)
    }
    
    func medalButtonPressed(sender: UIButton, key: String) {
        
        didChangeSelection = true
        
        if(sender.tag == 0){
            sender.tag = 1
            sender.backgroundColor = .white
            
            UserDefaults.standard.set(true, forKey: key)
        }
        else if (sender.tag == 1){
            sender.tag = 0
            sender.backgroundColor = .clear
            
            UserDefaults.standard.set(false, forKey: key)
        }
        
        UserDefaults.standard.synchronize()
    }
}
