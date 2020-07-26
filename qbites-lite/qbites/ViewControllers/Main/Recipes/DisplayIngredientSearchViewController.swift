//
//  DisplayIngredientSearchViewController.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 2/22/20.
//  Copyright © 2020 Mohammad Bashir sidani. All rights reserved.
//

import Foundation
import UIKit
import SwipeCellKit
import SVProgressHUD
import SDWebImage
import RLBAlertsPickers

class DisplayIngredientSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var ingredientsArray = [DisplayIngredient]()
    var newIngredientText = ""
    
    let searchView: UIView = {
        let view = UIView()
        
        view.backgroundColor = mainLightGrayColor.withAlphaComponent(0.5)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let searchImage: UIImageView = {
        let image = UIImageView()
        
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "search")?.mask(with: .lightGray)
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
    
    lazy var ingredientsTableView: UITableView = {
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchField.becomeFirstResponder()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utilities.sharedInstance.applyBlueGradient(view: self.view)
        
        view.addSubview(searchView)
        searchView.addSubview(searchImage)
        searchView.addSubview(searchField)
        
        //        view.addSubview(segmentedControl)
        view.addSubview(ingredientsTableView)
        
        ingredientsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //        segmentedControl.selectedSegmentIndex = 0
        
        layoutViews()
        
        searchCuisines(showLoader: true)
        
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
        
        ingredientsTableView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 10).isActive = true
        ingredientsTableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        ingredientsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Utilities.sharedInstance.SafeAreaBottomInset() ).isActive = true
        
        view.layoutIfNeeded()
        
        searchView.layer.cornerRadius = searchView.frame.size.height/2
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if (ingredientsArray.count == 0){
            let noDataLabel = UILabel()
            noDataLabel.font = mainFont(size: 20)
            noDataLabel.textColor = .black
            noDataLabel.numberOfLines = 0
            noDataLabel.textAlignment = .center
            noDataLabel.text = "No Results"
            
            tableView.backgroundView = noDataLabel
        }
        else{
            tableView.backgroundView = nil
        }
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ingredientsArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        
        for subView in cell.subviews {
            subView.removeFromSuperview()
        }
        
        cell.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let cellView = UIImageView()
        cellView.contentMode = .scaleAspectFill
//        cellView.layer.cornerRadius = 15
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
        
        let ingredientLabel = UILabel()
        ingredientLabel.textColor = .black
        ingredientLabel.font = mainFontBold(size: 16)
        ingredientLabel.textAlignment = .center
        ingredientLabel.numberOfLines = 0
        ingredientLabel.translatesAutoresizingMaskIntoConstraints = false
        cellView.addSubview(ingredientLabel)
        
        ingredientLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 0).isActive = true
        ingredientLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 0).isActive = true
        ingredientLabel.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: 0).isActive = true
        ingredientLabel.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: 0).isActive = true
        
        cellView.layoutIfNeeded()
        
//        ingredientLabel.layer.cornerRadius = 15
        cellView.layer.cornerRadius = cellView.frame.size.height / 2
        
        if(indexPath.row < ingredientsArray.count){
            let ingredient = ingredientsArray[indexPath.row]
            ingredientLabel.text = ingredient.name
        }
        else{
            cellView.backgroundColor = mainGreenColor
            ingredientLabel.textColor = .white
            ingredientLabel.text = "can't find ingredient?"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.row < ingredientsArray.count){
            
            let ingredient = ingredientsArray[indexPath.row]

            self.dismiss(animated: true) {

                let dict:[String: Any] = ["ingredient": ingredient, "tag": self.view.tag]
                // post a notification
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "displayIngredientSelected"), object: nil, userInfo: dict)
                
            }
        }
        else{
            
            let alert = UIAlertController(style: .alert, title: "New Ingredient")
            let config: TextField.Config = { textField in
                textField.becomeFirstResponder()
                textField.textColor = .black
                textField.placeholder = "Type the ingredient you didn't find"
                textField.leftViewPadding = 12
                textField.layer.borderWidth = 1
                textField.layer.cornerRadius = 8
                textField.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
                textField.backgroundColor = nil
                textField.returnKeyType = .done
                textField.action { textField in
                    // validation and so on
                    self.newIngredientText = textField.text ?? ""
                    
                }
            }
            alert.addOneTextField(configuration: config)
            alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (_) in
                if(self.newIngredientText != ""){
                    SVProgressHUD.show()
                    RequestHelper.sharedInstance.createDisplayIngredient(name: self.newIngredientText) { (response) in
                        if(response["success"] as? Bool == true){
                            SVProgressHUD.dismiss()
                            let ingredient = response["ingredient"] as! DisplayIngredient
                            
                            self.dismiss(animated: true) {

                                let dict:[String: Any] = ["ingredient": ingredient, "tag": self.view.tag]
                                // post a notification
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "displayIngredientSelected"), object: nil, userInfo: dict)
                                
                            }
                            
                        }
                        else{
                            SVProgressHUD.showError(withStatus: response["message"] as? String)
                        }
                    }
                }
                else{
                    SVProgressHUD.showError(withStatus: "name cannot be empty")
                }
            }))
            self.present(alert, animated: true, completion: nil)
//            alert.show()
            
        }
        
    }
    
    func searchCuisines(showLoader: Bool){
        
        if(showLoader){
            SVProgressHUD.show()
        }
        
        RequestHelper.sharedInstance.searchDisplayIngredients(keyword: searchField.text ?? "") { (response) in
            if(response["success"] as? Bool == true){
                
                self.ingredientsArray = response["ingredients"] as! [DisplayIngredient]
                self.ingredientsTableView.reloadData()
                
                
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
        
        searchCuisines(showLoader: false)
        
    }
    
    
    
}

