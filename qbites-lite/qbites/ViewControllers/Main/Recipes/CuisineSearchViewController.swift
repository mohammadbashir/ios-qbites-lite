//
//  CuisineSearchViewController.swift
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

class CuisineSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var meal = Meal()
    var parentVC = ""
    
    var cuisinesArray = [Cuisine]()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utilities.sharedInstance.applyBlueGradient(view: self.view)
        
        
        view.addSubview(searchView)
        searchView.addSubview(searchImage)
        searchView.addSubview(searchField)
        
        //        view.addSubview(segmentedControl)
        view.addSubview(mealPlanTableView)
        
        mealPlanTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        
        mealPlanTableView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 10).isActive = true
        //        mealPlanTableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 0).isActive = true
        mealPlanTableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        mealPlanTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Utilities.sharedInstance.SafeAreaBottomInset() ).isActive = true
        
        view.layoutIfNeeded()
        
        searchView.layer.cornerRadius = searchView.frame.size.height/2
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if (cuisinesArray.count == 0){
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
        
        return cuisinesArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cuisine = cuisinesArray[indexPath.row]
        
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
        
        mealImageView.sd_imageIndicator = SDWebImageActivityIndicator.white
        mealImageView.sd_setImage(with: URL(string: CloudinaryURLByWidth(url: cuisine.imageURL, width: 200) ), placeholderImage: UIImage())
        
        mealImageView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 7).isActive = true
        mealImageView.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 7).isActive = true
        mealImageView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -7).isActive = true
        mealImageView.widthAnchor.constraint(equalTo: cellView.widthAnchor, multiplier: 0.3).isActive = true
        
        let mealLabel = UILabel()
        mealLabel.textColor = .black
        mealLabel.font = mainFontBold(size: 16)
        mealLabel.text = cuisine.name
        mealLabel.textAlignment = .center
        //        mealLabel.backgroundColor = .lightGray
        mealLabel.numberOfLines = 0
        mealLabel.translatesAutoresizingMaskIntoConstraints = false
        cellView.addSubview(mealLabel)
        
        mealLabel.topAnchor.constraint(equalTo: mealImageView.topAnchor, constant: 0).isActive = true
        mealLabel.leftAnchor.constraint(equalTo: mealImageView.rightAnchor, constant: 7).isActive = true
        mealLabel.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -7).isActive = true
        mealLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        cellView.layoutIfNeeded()
        
        mealImageView.layer.cornerRadius = 15
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cuisine = cuisinesArray[indexPath.row]
        
        self.dismiss(animated: true) {
            
            let dict:[String: Any] = ["cuisine": cuisine]
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cuisineSelected"), object: nil, userInfo: dict)
        }
    }
    
    func searchCuisines(showLoader: Bool){
        
        if(showLoader){
            SVProgressHUD.show()
        }
        
        RequestHelper.sharedInstance.searchCuisines(keyword: searchField.text ?? "") { (response) in
            if(response["success"] as? Bool == true){
                
                self.cuisinesArray = response["cuisines"] as! [Cuisine]
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
        searchCuisines(showLoader: false)
    }
    
    
    
}
