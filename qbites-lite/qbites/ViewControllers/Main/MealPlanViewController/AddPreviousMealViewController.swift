//
//  AddPreviousMealViewController.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 3/8/20.
//  Copyright © 2020 Mohammad Bashir sidani. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField
import SVProgressHUD

class AddPreviousMealViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var previousPlans = [DailyPlan]()
    var selectedMealPlanId = -1
    var recipeId = -1
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = mainFont(size: 20)
        label.numberOfLines = 0
        label.setLineSpacing(lineSpacing: 15, lineHeightMultiple: 0)
        label.text = "Select the date and the meal or drink you would like to add"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var dateField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        Utilities.sharedInstance.styleSkyField(field: field, color: .black)
        field.lineColor = mainGreenColor
        field.textAlignment = .center
        field.placeholder = "Day"
        field.tag = 1
        field.delegate = self
        
        field.inputView = mealPlanPicker
        field.inputAccessoryView = pickerToolbar
        
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var mealPlanPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        
        picker.tag = 1
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let pickerToolbar: UIToolbar = {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(ToolbarDonePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
        
    }()
    
    lazy var mealField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        Utilities.sharedInstance.styleSkyField(field: field, color: .black)
        field.lineColor = mainGreenColor
        field.textAlignment = .center
        field.placeholder = "Meal/Drink"
        field.tag = 2
        field.delegate = self
        
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 2
        button.layer.borderColor = mainGreenColor.cgColor
        button.setTitle("Add", for: .normal)
        button.setTitleColor(mainGreenColor, for: .normal)
        button.addTarget(self, action: #selector(donePressed( sender:)),for: .touchUpInside)
        button.titleLabel?.font =  mainFontBold(size: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("cancel", for: .normal)
        button.titleLabel?.font =  mainFont(size: 15)
        button.setTitleColor(mainGreenColor, for: .normal)
        button.addTarget(self, action: #selector(cancelPressed( sender:)),for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
        //listen to observers
        NotificationCenter.default.addObserver(self, selector: #selector(recipeSelected(_:)), name: NSNotification.Name(rawValue: "recipeSelected"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //remove observers
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
//        Utilities.sharedInstance.applyBlueGradient(view: self.view)
        self.edgesForExtendedLayout = []
        
        //        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
        //        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        
        view.addSubview(titleLabel)
        view.addSubview(dateField)
        view.addSubview(mealField)
        view.addSubview(doneButton)
        view.addSubview(cancelButton)
        
        layoutViews()
        
    }
    
//    override func viewSafeAreaInsetsDidChange() {
//        // ... your layout code here
//        layoutViews()
//    }
    
    func layoutViews(){
        
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant:20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        
        dateField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant:40).isActive = true
        dateField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dateField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        dateField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        mealField.centerXAnchor.constraint(equalTo: dateField.centerXAnchor).isActive = true
        mealField.topAnchor.constraint(equalTo: dateField.bottomAnchor, constant:10).isActive = true
        mealField.widthAnchor.constraint(equalTo: dateField.widthAnchor, multiplier: 1).isActive = true
        mealField.heightAnchor.constraint(equalTo: dateField.heightAnchor).isActive = true
        
        doneButton.topAnchor.constraint(equalTo: mealField.bottomAnchor, constant: 40).isActive = true
        doneButton.widthAnchor.constraint(equalTo: dateField.widthAnchor).isActive = true
        doneButton.centerXAnchor.constraint(equalTo: dateField.centerXAnchor).isActive = true
        doneButton.heightAnchor.constraint(equalTo: mealField.heightAnchor).isActive = true
        
        cancelButton.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 7).isActive = true
        cancelButton.widthAnchor.constraint(equalTo: doneButton.widthAnchor).isActive = true
        cancelButton.centerXAnchor.constraint(equalTo: doneButton.centerXAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalTo: doneButton.heightAnchor, multiplier: 0.5).isActive = true
        
        view.layoutIfNeeded()
        
        doneButton.layer.cornerRadius = 15
    }
    
    @objc func donePressed(sender: UIButton){
        
        if(selectedMealPlanId == -1){
            SVProgressHUD.showInfo(withStatus: "Select a date first")
        }
        else if (recipeId == -1){
            SVProgressHUD.showInfo(withStatus: "Select a meal first")
        }
        else{
            SVProgressHUD.show()
            RequestHelper.sharedInstance.addPreviousMeal(mealPlanId: selectedMealPlanId, recipeId: recipeId) { (response) in
                if(response["success"] as? Bool == true){
                    SVProgressHUD.dismiss()
                    self.dismiss(animated: true) {
                        GlobalMealPlanViewController?.fetchMeals(forceRefresh: false)
                    }
                }
                else{
                    SVProgressHUD.showError(withStatus: response["message"] as? String)
                }
            }
        }
    }
    
    @objc func cancelPressed(sender: UIButton){
        self.dismiss(animated: true) { }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return previousPlans.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return previousPlans[row].title
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let mealPlan = previousPlans[row]
        
        selectedMealPlanId = mealPlan.id
        dateField.text = mealPlan.title
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField.tag == 2){
            
            let mealSearchVC = MealSearchViewController()
            mealSearchVC.view.tag = 1
            self.present(mealSearchVC, animated: true)
            
            return false
        }
        
        return true
    }
    
    @objc func ToolbarDonePressed(){
        self.view.endEditing(true)
    }
    
    @objc func recipeSelected(_ notification: NSNotification) {
        
        if let dict = notification.userInfo as NSDictionary? {
            if let recipe = dict["recipe"] as? Recipe{
                
                mealField.text = recipe.name
                recipeId = recipe.id
                
            }
        }
        
    }
    
}
