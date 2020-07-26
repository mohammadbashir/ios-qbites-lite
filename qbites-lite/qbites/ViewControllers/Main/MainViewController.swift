//
//  MainViewController.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 10/10/19.
//  Copyright © 2019 Mohammad Bashir sidani. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import StoreKit

class MainViewController: UITabBarController { 
    
    var pages = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GlobalMainViewController = self
        
        view.backgroundColor = .white
        
        Utilities.sharedInstance.registerForPushNotifications()
        
        self.tabBar.tintColor = mainBlueColor
        self.tabBar.barTintColor = .white
        
        let page1 = RecipeRankingsViewController()//AddRecepieViewController()
        let page2 = CookBookViewController()
        let page3 = RecipesViewController()
        let page4 = FamilyViewController()
        let page5 = SettingsViewController()

        page1.title = "Rankings"
        page2.title = "CookBook"
        page3.title = "Recipes"
        page4.title = "Family"
        page5.title = "More"

        page1.tabBarItem.image = UIImage(named: "tabicon-recipes")
        page2.tabBarItem.image = Utilities.sharedInstance.resizeImage(image: UIImage(named: "book")!, newWidth: 40)
        page3.tabBarItem.image = UIImage(named: "tabicon-mealplan-2")
        page4.tabBarItem.image = UIImage(named: "tabicon-family-2")
        page5.tabBarItem.image = UIImage(named: "tabicon-settings-1")
        
        self.pages = [page1, page2, page3, page4, page5]
        viewControllers = pages
        self.selectedIndex = 2
//
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
        
    }
    
}

