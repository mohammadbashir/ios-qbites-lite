//
//  CuisineMultiselectViewController.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 3/1/20.
//  Copyright © 2020 Mohammad Bashir sidani. All rights reserved.
//

import Foundation
import UIKit
import SwipeCellKit
import SVProgressHUD
import SDWebImage
import M13Checkbox
import SkyFloatingLabelTextField

class CuisineMultiselectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var cuisinesArray = [Cuisine]()
    var selectedCuisinesArray = [Cuisine]()
    
    let searchView: UIView = {
        let view = UIView()
        
        view.backgroundColor = mainLightGrayColor.withAlphaComponent(0.5)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let searchImage: UIImageView = {
        let image = UIImageView()
        
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "search")?.mask(with: .black)
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
    
    lazy var cuisinesField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextFieldWithIcon()
        Utilities.sharedInstance.styleSkyField(field: field, color: .black)
        field.lineColor = mainGreenColor
        field.placeholder = "All cuisines"
        field.title = ""
        field.iconType = .image
        field.iconImage = UIImage(named:"filter")?.mask(with: .black)
        field.textAlignment = .center
        field.isUserInteractionEnabled = false
        field.delegate = self
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var cuisineTableView: UITableView = {
        
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
        
        view.backgroundColor = .white
//        Utilities.sharedInstance.applyBlueGradient(view: self.view)
        self.edgesForExtendedLayout = []
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        
        view.addSubview(searchView)
        searchView.addSubview(searchImage)
        searchView.addSubview(searchField)
        
        view.addSubview(cuisinesField)
        view.addSubview(cuisineTableView)
        
        cuisineTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
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
        
        cuisinesField.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 10).isActive = true
        cuisinesField.leftAnchor.constraint(equalTo: searchView.leftAnchor, constant: 0).isActive = true
        cuisinesField.rightAnchor.constraint(equalTo: searchView.rightAnchor, constant: 0).isActive = true
        
        cuisineTableView.topAnchor.constraint(equalTo: cuisinesField.bottomAnchor, constant: 10).isActive = true
        cuisineTableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        cuisineTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Utilities.sharedInstance.SafeAreaBottomInset() ).isActive = true
        
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
        
        let checkbox = M13Checkbox()
        checkbox.tintColor = mainGreenColor
        checkbox.stateChangeAnimation = .fill
        checkbox.isUserInteractionEnabled = false
        
        if(selectedCuisinesArray.contains(where: { cuisineObj in cuisineObj.id == cuisine.id })){
            checkbox.setCheckState(.checked, animated: false)
        }
        else{
            checkbox.setCheckState(.unchecked, animated: false)
        }
        
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        cellView.addSubview(checkbox)
        
        checkbox.widthAnchor.constraint(equalToConstant: 25).isActive = true
        checkbox.heightAnchor.constraint(equalTo: checkbox.widthAnchor, multiplier: 1).isActive = true
        checkbox.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 7).isActive = true
        checkbox.centerYAnchor.constraint(equalTo: cellView.centerYAnchor, constant: 0).isActive = true
        
        let cuisineImageView = UIImageView()
        cuisineImageView.backgroundColor = .lightGray
        cuisineImageView.clipsToBounds = true
        cuisineImageView.contentMode = .scaleAspectFill
        cuisineImageView.translatesAutoresizingMaskIntoConstraints = false
        cellView.addSubview(cuisineImageView)
        
        cuisineImageView.sd_imageIndicator = SDWebImageActivityIndicator.white
        cuisineImageView.sd_setImage(with: URL(string: CloudinaryURLByWidth(url: cuisine.imageURL, width: 200) ), placeholderImage: UIImage())
        
        cuisineImageView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 7).isActive = true
        cuisineImageView.leftAnchor.constraint(equalTo: checkbox.rightAnchor, constant: 7).isActive = true
        cuisineImageView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -7).isActive = true
        cuisineImageView.widthAnchor.constraint(equalTo: cellView.widthAnchor, multiplier: 0.3).isActive = true
        
        let cuisineLabel = UILabel()
        cuisineLabel.textColor = mainLightBlueColor
        cuisineLabel.font = mainFontBold(size: 16)
        cuisineLabel.text = cuisine.name
        cuisineLabel.textAlignment = .center
        //        cuisineLabel.backgroundColor = .lightGray
        cuisineLabel.numberOfLines = 0
        cuisineLabel.translatesAutoresizingMaskIntoConstraints = false
        cellView.addSubview(cuisineLabel)
        
        cuisineLabel.topAnchor.constraint(equalTo: cuisineImageView.topAnchor, constant: 0).isActive = true
        cuisineLabel.leftAnchor.constraint(equalTo: cuisineImageView.rightAnchor, constant: 7).isActive = true
        cuisineLabel.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -7).isActive = true
        cuisineLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        cellView.layoutIfNeeded()
        
        cuisineImageView.layer.cornerRadius = 15
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cuisine = cuisinesArray[indexPath.row]
        
        if(selectedCuisinesArray.contains(where: { cuisineObj in cuisineObj.id == cuisine.id })){
            
            for (index, cuis) in selectedCuisinesArray.enumerated(){
                if(cuis.id == cuisine.id){
                    selectedCuisinesArray.remove(at: index)
                }
            }
        }
        else{
            selectedCuisinesArray.append(cuisine)
        }
        
        cuisineTableView.reloadData()
        
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
    
    func searchCuisines(showLoader: Bool){
        
        if(showLoader){
            SVProgressHUD.show()
        }
        
        RequestHelper.sharedInstance.searchCuisines(keyword: searchField.text ?? "") { (response) in
            if(response["success"] as? Bool == true){
                
                self.cuisinesArray = response["cuisines"] as! [Cuisine]
                self.cuisineTableView.reloadData()
                
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
    
    @objc func donePressed(){
        self.dismiss(animated: true) {
            
            let dict:[String: Any] = ["cuisines": self.selectedCuisinesArray, "display" : self.cuisinesField.text ?? ""]
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "multipleCuisinesSelected"), object: nil, userInfo: dict)
            
        }
    }
    
    @objc func cancelPressed(){
        self.dismiss(animated: true) {
            
        }
    }
    
}
