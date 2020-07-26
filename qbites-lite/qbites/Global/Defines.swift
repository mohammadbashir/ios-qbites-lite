//
//  Defines.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 10/9/19.
//  Copyright © 2019 Mohammad Bashir sidani. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import MapKit

let mainGrayColor = UIColor.init(red: 116/255, green: 119/255, blue: 135/255, alpha: 1.0)
let mainLightGrayColor = UIColor.init(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)
let mainUltraLightGrayColor = UIColor.init(red: 231/255, green: 230/255, blue: 236/255, alpha: 1.0)
let mainDarkGrayColor = UIColor.init(red: 76/255, green: 76/255, blue: 76/255, alpha: 1.0)
let mainOrangeColor = UIColor.init(red: 251/255, green: 93/255, blue: 32/255, alpha: 1.0)
let mainDarkBlueColor = UIColor.init(red: 3/255, green: 85/255, blue: 201/255, alpha: 1.0)
let mainLightBlueColor = UIColor.init(red: 28/255, green: 156/255, blue: 216/255, alpha: 1.0)
let mainBlueColor = UIColor.init(red: 35/255, green: 174/255, blue: 201/255, alpha: 1.0)
let mainGreenColor = UIColor.init(red: 35/255, green: 174/255, blue: 201/255, alpha: 1.0)//UIColor.init(red: 92/255, green: 184/255, blue: 78/255, alpha: 1.0)

let mainPinkColor = UIColor.init(red: 250/250, green: 197/250, blue: 183/250, alpha: 1)
let mainYellowColor = UIColor.init(red: 241/255, green: 156/255, blue: 38/255, alpha: 1.0)

let mainGoldColor = UIColor.init(red: 212/255, green: 175/255, blue: 55/255, alpha: 1.0)
let mainSilverColor = UIColor.darkGray
let mainBronzeColor = UIColor.init(red: 205/255, green: 127/255, blue: 50/255, alpha: 1.0)

let privacyURL = "https://app.termly.io/document/privacy-policy/e294cc92-0d0e-4030-8a9e-61580ad19bef"
let termsURL = "https://app.termly.io/document/terms-of-use-for-website/e269d653-43d9-4c4c-9668-596bbbddf2db"
let aboutUsURL = "https://www.qbites.com/about-us"
let contatUsURL = "https://www.qbites.com/contact-us"
let faqURL = "https://qbites.com/qbites-faq"
let ComplementaryFeedingURL = "https://www.who.int/elena/titles/bbc/complementary_feeding/en/"
//
//let mainURL = "http://ec2-54-191-186-178.us-west-2.compute.amazonaws.com:8001/qbites"
let mainURL = "http://app-test.qbites.com:8001/qbites" //DEV
//let mainURL = "http://app.qbites.com:8001/qbites" //PROD
let loginURL = mainURL + "/public/login"
let signupURL = mainURL + "/public/regesterUserFirebase"
let cuisinesURL = mainURL + "/cuisineReaction/getParentCuisines"
let setCuisinePreferenceURL = mainURL + "/cuisineReaction/create"
let mealPlanURL = mainURL + "/mealPlan/getChildMeals"
let previousMealsURL = mainURL + "/mealPlan/getChildPreviousMeals"
let familyURL = mainURL + "/family"
let updateParentURL = mainURL + "/parent/update"
let createChildURL = mainURL + "/child/create"
let updateChildURL = mainURL + "/child/update"
let updateUserNotificationURL = mainURL + "/user/updateNotificationSettings"
let replaceMealURL = mainURL + "/mealPlan/replace"
let skipMealURL = mainURL + "/mealPlan/skip"
let consumeMealURL = mainURL + "/mealPlan/consume"
let updateMealURL = mainURL + "/mealPlan/update"
let setRecepieReactionURL = mainURL + "/recipeReaction/create"
let shareRecepirURL = mainURL + "/recipe/getShareTemplate"
let favouriteMealURL = mainURL + "/childRecipeFavorite/create"
let getCookBookURL = mainURL + "/childRecipeFavorite/getCookbook"
let getChildAssessmentURL = mainURL + "/assessment/getChildAssessments"
let getDailyInputURL = mainURL + "/infantFoodConsumed/getUnconsumedInfantFeeds"
let createDailyInputURL = mainURL + "/infantFoodConsumed/consumeInfantFeeds"
let getRecipeURL = mainURL + "/recipe"
let weightGrowthChartURL = mainURL + "/html/charts/growth/weight"
let heightGrowthChartURL = mainURL + "/html/charts/growth/height"
let assessmentHistoryURL = mainURL + "/html/charts/assessment"
let searchRecipesURL = mainURL + "/recipe/search"
let searchRecipes2URL = mainURL + "/recipe/search2"
let replaceWithURL = mainURL + "/mealPlan/replaceWith"
let rankingsURL = mainURL + "/userRecipeRanking/getUserRecipeRankingsForChild"
let searchCuisinesURL = mainURL + "/cuisine/acSearch"
let searchDisplayIngredientsURL = mainURL + "/ingredientDisplay/fuzzySearch"
let createDisplayIngredientsURL = mainURL + "/ingredientDisplay/create"
let createRecipeURL = mainURL + "/recipe/create"
let uploadImageURL = mainURL + "/public/upload"
let getLast5MealPlansURL = mainURL + "/mealPlan/getChildLast5MealPlans"
let addPreviousMealURL = mainURL + "/meal/create"
let addChildGrowthInfoURL = mainURL + "/childGrowthInfo/create"
let subscriptionInfoURL = mainURL + "/subscriptionPlan/validateSubscriptionIOS"

let imageBaseURL = mainURL + "/public/download/"

func CloudinaryURLByWidth(url: String, width: Double) -> String {
    return "https://res.cloudinary.com/ditfnowz0/image/fetch/w_" + String(Int(width)) + ",c_fill/" + url
}

func mainFont(size: CGFloat) -> UIFont {
    return UIFont(name: "GothamMedium", size: size)!
}
func mainFontBold(size: CGFloat) -> UIFont {
    return UIFont(name: "GothamBold", size: size)!
}
func mainFontLight(size: CGFloat) -> UIFont {
    return UIFont(name: "Gotham-Light", size: size)!
}
func mainFontItalic(size: CGFloat) -> UIFont {
    return UIFont(name: "GillSans-SemiBoldItalic", size: size)!
}

func PrintFonts(){
    for fontFamilyName in UIFont.familyNames{
        for fontName in UIFont.fontNames(forFamilyName: fontFamilyName){
            print("Family: \(fontFamilyName)     Font: \(fontName)")
        }
    }
}


//----Global variables
let appUserKey = "appUserKey"
let appFamilyKey = "appFamilyKey"
let appParentKey = "appParentKey"
let appChildKey = "appChildKey"

let filtersCuisinesArrayKey = "filterCuisinesArray"
let filtersBreakfastKey = "filtersBreakfast"
let filtersLunchKey = "filtersLunch"
let filtersDinnerKey = "filtersDinner"
let filtersSnackKey = "filtersSnack"
let filtersVegeterianKey = "filtersVegeterian"
let filtersVeganKey = "filtersVegan"
let filtersPorkFreeKey = "filtersPorkFree"
let filtersQuickRecipesKey = "filtersQuickRecipes"
let filtersGoldkey = "filtersGold"
let filtersSilverKey = "filtersSilver"
let filtersBronzeKey = "filtersBronze"


//KEY Functions
func appUser() -> User {
    
    if let data = UserDefaults.standard.data(forKey: appUserKey), let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? User {
        return user
    } else {
        return User()
    }
    
}

func saveAppUser(user: User){
    
    let encodedData = NSKeyedArchiver.archivedData(withRootObject: user)
    UserDefaults.standard.set(encodedData, forKey: appUserKey)
    UserDefaults.standard.synchronize()
    
}

func appFamily() -> Family {

    if let data = UserDefaults.standard.data(forKey: appFamilyKey), let family = NSKeyedUnarchiver.unarchiveObject(with: data) as? Family {
        return family
    } else {
        return Family()
    }
    
}

func saveAppFamily(family: Family){
    let encodedData = NSKeyedArchiver.archivedData(withRootObject: family)
    UserDefaults.standard.set(encodedData, forKey: appFamilyKey)
    UserDefaults.standard.synchronize()
}

func appParent() -> Parent {

    if let data = UserDefaults.standard.data(forKey: appParentKey), let parent = NSKeyedUnarchiver.unarchiveObject(with: data) as? Parent {
        return parent
    } else {
        return Parent()
    }

}

func saveAppParent(parent: Parent){
    let encodedData = NSKeyedArchiver.archivedData(withRootObject: parent)
    UserDefaults.standard.set(encodedData, forKey: appParentKey)
    UserDefaults.standard.synchronize()
}

func appChild() -> Child {

    if let data = UserDefaults.standard.data(forKey: appChildKey), let child = NSKeyedUnarchiver.unarchiveObject(with: data) as? Child {
        return child
    } else {
        return Child()
    }

}

func saveAppChild(child: Child){
    let encodedData = NSKeyedArchiver.archivedData(withRootObject: child)
    UserDefaults.standard.set(encodedData, forKey: appChildKey)
    UserDefaults.standard.synchronize()
}


//----
var GlobalMealPlanViewController: MealPlanViewController?
var GlobalMainViewController: MainViewController?
var GlobalCookBookViewController: CookBookViewController?
var GlobalChildViewController: ChildViewController?
var GlobalSubscriptionViewController: SubscriptionViewController?
//var GlobalPreviousMealsViewController: PreviousMealsViewController?

var GlobalRecipesViewController: RecipesViewController?
//----

var GuageRedRatio = 15.0
var GuageYellowRatio = 25.0
var GuageGreenRatio = 60.0


//----


let userDefaultsShowRatingKey = "userDefaultsShowRating"

//var GlobalIAPStore = IAPProducts.store
//var GlobalIAPHelper =  IAPManager(productIDs: qbitesProducts.productIDs)
