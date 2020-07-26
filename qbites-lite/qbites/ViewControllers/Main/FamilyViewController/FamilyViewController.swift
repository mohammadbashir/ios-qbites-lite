//
//  FamilyViewController.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 11/1/19.
//  Copyright © 2019 Mohammad Bashir sidani. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class FamilyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    lazy var familyTableView: UITableView = {
            
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
    
    var sectionTitles = ["Parent", "Child"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        
        view.addSubview(familyTableView)
        familyTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        SVProgressHUD.show()
        RequestHelper.sharedInstance.getFamily { (response) in
            if(response["success"] as? Bool == true){
                
                self.familyTableView.reloadData()
                SVProgressHUD.dismiss()
                
            }
            else{
                SVProgressHUD.showError(withStatus: response["message"] as? String)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.familyTableView.reloadData()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        // ... your layout code here
        layoutViews()
    }
    
    func layoutViews(){
        familyTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: Utilities.sharedInstance.SafeAreaTopInset() + (self.navigationController?.navigationBar.frame.size.height)!).isActive = true
        familyTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        familyTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        familyTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Utilities.sharedInstance.SafeAreaBottomInset()).isActive = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 180
        
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
        cellView.layer.cornerRadius = 15
        cellView.backgroundColor = mainLightGrayColor.withAlphaComponent(0.5)
        cellView.clipsToBounds = true
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellView.isUserInteractionEnabled = true
        cell.addSubview(cellView)
//
        cellView.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        cellView.widthAnchor.constraint(equalTo: cell.widthAnchor, multiplier: 1, constant: -10).isActive = true
        cellView.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
        cellView.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -15).isActive = true
        
        if(indexPath.section == 0){
            
            let personImageView = UIImageView()
//            personImageView.backgroundColor = .lightGray
            personImageView.clipsToBounds = true
            personImageView.contentMode = .scaleAspectFit
            personImageView.translatesAutoresizingMaskIntoConstraints = false
            cellView.addSubview(personImageView)

            personImageView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 7).isActive = true
            personImageView.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 7).isActive = true
            personImageView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -7).isActive = true
            personImageView.widthAnchor.constraint(equalTo: cellView.widthAnchor, multiplier: 0.4).isActive = true
            
            let nameLabel = UILabel()
            nameLabel.font = mainFontBold(size: 20)
            nameLabel.textAlignment = .center
            nameLabel.setLineSpacing(lineSpacing: 10, lineHeightMultiple: 0)
            nameLabel.textColor = .black//mainLightBlueColor
            nameLabel.numberOfLines = 2
            nameLabel.adjustsFontSizeToFitWidth = true
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            cellView.addSubview(nameLabel)
            
            nameLabel.topAnchor.constraint(equalTo: personImageView.topAnchor, constant: 0).isActive = true
            nameLabel.leftAnchor.constraint(equalTo: personImageView.rightAnchor, constant: 10).isActive = true
            nameLabel.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -10).isActive = true
            nameLabel.bottomAnchor.constraint(equalTo: cellView.centerYAnchor, constant: 0).isActive = true
            
            let roleLabel = UILabel()
            roleLabel.font = mainFontBold(size: 16)
            roleLabel.textAlignment = .center
            roleLabel.setLineSpacing(lineSpacing: 10, lineHeightMultiple: 0)
            roleLabel.textColor = .black//mainLightBlueColor
            roleLabel.numberOfLines = 2
            roleLabel.adjustsFontSizeToFitWidth = true
            roleLabel.translatesAutoresizingMaskIntoConstraints = false
            cellView.addSubview(roleLabel)
            
            roleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0).isActive = true
            roleLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor, constant: 0).isActive = true
            roleLabel.rightAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 0).isActive = true
            roleLabel.bottomAnchor.constraint(equalTo: personImageView.bottomAnchor, constant: 0).isActive = true
            
            if(appParent().parentType == "FATHER"){
                personImageView.image = UIImage(named: "father")
                roleLabel.text = "Dad"
            }
            else{
                personImageView.image = UIImage(named: "mother")
                roleLabel.text = "Mom"
            }
            
            nameLabel.text = appParent().name
//            roleLabel.text = appParent().parentType.capitalizingFirstLetter()
            
            cellView.layoutIfNeeded()
        
            personImageView.layer.cornerRadius = 15

        }
        else{
            
            if (appChild().id == -1){
                
                let addChildLabel = UILabel()
                addChildLabel.font = mainFontBold(size: 25)
                addChildLabel.textColor = .black//mainLightBlueColor
                addChildLabel.textAlignment = .center
                addChildLabel.text = "Add Child"

                addChildLabel.translatesAutoresizingMaskIntoConstraints = false
                cellView.addSubview(addChildLabel)

                addChildLabel.topAnchor.constraint(equalTo: cellView.topAnchor).isActive = true
                addChildLabel.bottomAnchor.constraint(equalTo: cellView.bottomAnchor).isActive = true
                addChildLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor).isActive = true
                addChildLabel.rightAnchor.constraint(equalTo: cellView.rightAnchor).isActive = true
                
            }
            else{
                
                let personImageView = UIImageView()
                personImageView.clipsToBounds = true
                personImageView.contentMode = .scaleAspectFit
                personImageView.translatesAutoresizingMaskIntoConstraints = false
                cellView.addSubview(personImageView)

                personImageView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 7).isActive = true
                personImageView.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 7).isActive = true
                personImageView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -7).isActive = true
                personImageView.widthAnchor.constraint(equalTo: cellView.widthAnchor, multiplier: 0.4).isActive = true
                    
                let nameLabel = UILabel()
                nameLabel.font = mainFontBold(size: 20)
                nameLabel.textAlignment = .center
                nameLabel.setLineSpacing(lineSpacing: 10, lineHeightMultiple: 0)
                nameLabel.textColor = .black//mainLightBlueColor
                nameLabel.numberOfLines = 2
                nameLabel.adjustsFontSizeToFitWidth = true
                nameLabel.translatesAutoresizingMaskIntoConstraints = false
                cellView.addSubview(nameLabel)
                
                nameLabel.topAnchor.constraint(equalTo: personImageView.topAnchor, constant: 0).isActive = true
                nameLabel.leftAnchor.constraint(equalTo: personImageView.rightAnchor, constant: 10).isActive = true
                nameLabel.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -10).isActive = true
                nameLabel.bottomAnchor.constraint(equalTo: personImageView.bottomAnchor, constant: 0).isActive = true
                
                
                nameLabel.text = appChild().name
                
                if(appChild().gender == "MALE"){
                    personImageView.image = UIImage(named: "baby-boy")
                }
                else{
                    personImageView.image = UIImage(named: "baby-girl")
                }
                    
                cellView.layoutIfNeeded()
                
                personImageView.layer.cornerRadius = 15
                
            }
    
            
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.section == 0){
            self.navigationController?.pushViewController(ParentViewController(), animated: true)
        }
        else{
            self.navigationController?.pushViewController(ChildViewController(), animated: true)
        }
        

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()

        let headerLabel = UILabel(frame: CGRect(x: 5, y: 5, width: 0, height: 0))
        headerLabel.font = mainFontBold(size: 40)
        headerLabel.textColor = mainGreenColor//mainLightBlueColor //mainGreenColor//UIColor.white
        headerLabel.text = sectionTitles[section]
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
            
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

