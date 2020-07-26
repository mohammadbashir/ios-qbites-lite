//
//  Utilities.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 10/9/19.
//  Copyright © 2019 Mohammad Bashir sidani. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import SVProgressHUD
import SkyFloatingLabelTextField
import Firebase
import FirebaseAuth

let applicationWindow = UIApplication.shared.windows.first

class Utilities : NSObject {
    
    static let sharedInstance = Utilities()
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func SafeAreaBottomInset() -> CGFloat {
        
        var inset = 0 as CGFloat
        
        if #available(iOS 11.0, *) {
            inset = (UIApplication.shared.keyWindow?.safeAreaInsets.bottom)!
        }
        
        return inset
    }
    
    func SafeAreaTopInset() -> CGFloat {
        
        var inset = 0 as CGFloat
        
        if #available(iOS 11.0, *) {
            inset = (UIApplication.shared.keyWindow?.safeAreaInsets.top)!
        }
        
        return inset
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current() // 1
            .requestAuthorization(options: [.alert, .sound, .badge]) { // 2
                granted, error in
                print("Permission granted: \(granted)") // 3
        }
    }
    
    func parseUserDictAndSave(dict: NSDictionary){
        
        if let userDict = dict["user"] as? NSDictionary{
            
            let user = appUser()
            
            if let userId = userDict["id"] as? Int {
                user.id = userId
            }
            if let userEmail = userDict["email"] as? String {
                user.email = userEmail
            }
            if let notificationBool = userDict["isNotificationsEnabled"] as? Bool {
                user.notificationsAllowed = notificationBool
            }
            
            saveAppUser(user: user)
            
        }
        
        if let parentDict = dict["parent"] as? NSDictionary{
            
            let parent = appParent()
            
            if let parentFamilyDict = parentDict["family"] as? NSDictionary {
                if let parentFamilyId = parentFamilyDict["id"] as? Int{
                    
                    let family = appFamily()
                    family.id = parentFamilyId
                    saveAppFamily(family: family)
                    
                }
            }
            
            if let parentId = parentDict["id"] as? Int {
                parent.id = parentId
            }
            if let parentName = parentDict["name"] as? String {
                parent.name = parentName
            }
            if let firstName = parentDict["firstName"] as? String {
                parent.firstName = firstName
            }
            if let lastName = parentDict["lastName"] as? String {
                parent.lastName = lastName
            }
            if let parentRole = parentDict["parentType"] as? String {
                parent.parentType = parentRole
            }
            if let parentNationality = parentDict["nationalityName"] as? String {
                parent.nationalityName = parentNationality
            }
            if let parentNationalityCode = parentDict["nationality2DigitCode"] as? String {
                parent.nationality2DigitCode = parentNationalityCode
            }
            
            if let parentIsUSMetrics = parentDict["isUSMetrics"] as? Bool {
                parent.isUSMetrics = parentIsUSMetrics
            }
            
            if let parentDidCheckCuisines = parentDict["didCheckCuisines"] as? Bool {
                parent.didCheckCuisines = parentDidCheckCuisines
            }
            
            saveAppParent(parent: parent)
            
        }
        
        if let childDict = dict["child"] as? NSDictionary{
            
            let child = appChild()
            
            if let childId = childDict["id"] as? Int {
                child.id = childId
            }
            
            if let childName = childDict["name"] as? String {
                child.name = childName
            }
            
            if let childGender = childDict["gender"] as? String {
                child.gender = childGender
            }
            
            if let childDate = childDict["birthDate"] as? String {
                child.birthDate = childDate.components(separatedBy: "+")[0].toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSS")!
            }
            
            if let childWeight = childDict["weight"] as? Int {
                child.weight = childWeight
            }
            
            if let childWeightPlaceholder = childDict["weightPlaceHolder"] as? String {
                child.weightPlaceholder = childWeightPlaceholder
            }
            
            if let childHeight = childDict["height"] as? Int {
                child.height = childHeight
            }
            
            if let childHeightPlaceholder = childDict["heightPlaceHolder"] as? String {
                child.heightPlaceholder = childHeightPlaceholder
            }
            
            if let childFeeding = childDict["infantFeeding"] as? String {
                child.infantFeeding = childFeeding
            }
            
            if let childNumberOfBreastFeedings = childDict["numberOfBreastFeedings"] as? Int {
                child.numberOfBreastFeedings = childNumberOfBreastFeedings
            }
            
            if let childSizeOfBreastFeedingsMin = childDict["sizeOfBreastFeedingsMin"] as? Int {
                child.sizeOfBreastFeedingsMin = childSizeOfBreastFeedingsMin
            }
            
            if let childSizeOfBreastFeedingsMax = childDict["sizeOfBreastFeedingsMax"] as? Int {
                child.sizeOfBreastFeedingsMax = childSizeOfBreastFeedingsMax
            }
            
            if let childNumberOfFormulaFeedings = childDict["numberOfFormulaFeedings"] as? Int {
                child.numberOfFormulaFeedings = childNumberOfFormulaFeedings
            }
            
            if let childSizeOfFormulaFeedingsMin = childDict["sizeOfFormulaFeedingsMin"] as? Int {
                child.sizeOfFormulaFeedingsMin = childSizeOfFormulaFeedingsMin
            }
            
            if let childSizeOfFormulaFeedingsMax = childDict["sizeOfFormulaFeedingsMax"] as? Int {
                child.sizeOfFormulaFeedingsMax = childSizeOfFormulaFeedingsMax
            }
            
            if let allergy = childDict["isAllergicToAlcohol"] as? Bool {
                child.isAllergicToAlcohol = allergy
            }
            
            if let allergy = childDict["isAllergicToEggs"] as? Bool {
                child.isAllergicToEggs = allergy
            }
            
            if let allergy = childDict["isAllergicToFish"] as? Bool {
                child.isAllergicToFish = allergy
            }
            
            if let allergy = childDict["isAllergicToMilk"] as? Bool {
                child.isAllergicToMilk = allergy
            }
            
            if let allergy = childDict["isAllergicToMilkCMP"] as? Bool {
                child.isAllergicToMilkCMP = allergy
            }
            
            if let allergy = childDict["isAllergicToPeanuts"] as? Bool {
                child.isAllergicToPeanuts = allergy
            }
            
            if let allergy = childDict["isAllergicToPork"] as? Bool {
                child.isAllergicToPork = allergy
            }
            
            if let allergy = childDict["isAllergicToShellfish"] as? Bool {
                child.isAllergicToShellfish = allergy
            }
            
            if let allergy = childDict["isAllergicToSoy"] as? Bool {
                child.isAllergicToSoy = allergy
            }
            
            if let allergy = childDict["isAllergicToTreenuts"] as? Bool {
                child.isAllergicToTreenuts = allergy
            }
            
            if let allergy = childDict["isAllergicToWheat"] as? Bool {
                child.isAllergicToWheat = allergy
            }
            
            if let isIntroducedToSolidFoods = childDict["isIntroducedToSolidFoods"] as? Bool {
                child.isIntroducedToSolidFoods = isIntroducedToSolidFoods
            }
            
            if let didCuisinePrefs = childDict["didCuisinePrefs"] as? Bool {
                child.didCuisinePrefs = didCuisinePrefs
            }
            
            saveAppChild(child: child)
            
        }
        
    }
    
    func clearUserDefaults(){
        
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            if(key != "hasRunBefore"){
                defaults.removeObject(forKey: key)
            }
            
        }
        
    }
    func logout(message: String? = "Session terminated, please login again."){
        
        clearUserDefaults()
        
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        
        //        FirebaseIDToken = ""
        try! Auth.auth().signOut()
        
        //
        let mainNavigationController = UINavigationController.init(rootViewController: LoginViewController())
        UIApplication.shared.delegate?.window??.rootViewController = mainNavigationController
        
        SVProgressHUD.showInfo(withStatus: message)
        
    }
    
    func timeAgoSinceDate(_ rawDate: String) -> String {
        
        let numericDates = true
        
        let isoDate = rawDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        let date = dateFormatter.date(from:isoDate)!
        
        let currentDate = Date()
        
        let calendar = Calendar.current
        let now = currentDate
        let earliest = (now as NSDate).earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
        
    }
    
    func isURLImageType(url: URL) -> Bool {
        // image formats which you want to check
        let imageExtensions = ["png", "jpg", "gif"]
        
        if imageExtensions.contains(url.pathExtension) {
            return true
        } else{
            return false
        }
    }
    
    func HoursAgoSinceDate(_ rawDate: String) -> Int {
        
        let isoDate = rawDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        let date = dateFormatter.date(from:isoDate)!
        
        let currentDate = Date()
        
        let calendar = Calendar.current
        let now = currentDate
        let earliest = (now as NSDate).earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        
        return components.hour!
        
    }
    
    
    //    func optimizeURLForProfile(url: URL) -> URL {
    //
    //        let modification = "upload/q_auto:best/w_100/h_100/"
    //
    //        let string = url.absoluteString.replacingOccurrences(of: "upload/", with: modification, options: .literal, range: nil)
    //
    //        return URL(string: string)!
    //    }
    //
    //    func optimizeURLForScreen(url: URL) -> URL {
    //
    //        let modification = "upload/q_auto:best/w_" + String(Int(UIScreen.main.bounds.width)) + "/h_" + String(Int(UIScreen.main.bounds.height)) + "/"
    //        let string = url.absoluteString.replacingOccurrences(of: "upload/", with: modification, options: .literal, range: nil)
    //
    //        return URL(string: string)!
    //
    //    }
    
    func applyBlueGradient(view: UIView){
        
        view.backgroundColor = .white
        
//        let blueColor = UIColor.init(red: 80/255, green: 180/255, blue: 85/255, alpha: 1.0)
//        let lightBlueColor = UIColor.init(red: 190/255, green: 225/255, blue: 190/255, alpha: 1.0)
//
////        let blueColor = UIColor.init(red: 41/255, green: 131/255, blue: 186/255, alpha: 1.0)
////        let lightBlueColor = UIColor.init(red: 201/255, green: 227/255, blue: 255/255, alpha: 1.0)
//
//        let gradient: CAGradientLayer = CAGradientLayer()
//
//        gradient.colors = [lightBlueColor.cgColor, blueColor.cgColor]
//        gradient.locations = [0.0 , 1.0]
//        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
//        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
//        gradient.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height:view.frame.size.height)
//
//        view.layer.insertSublayer(gradient, at: 0)
        
    }
    
    func parseMeal(dict: NSDictionary) -> Meal {
        
        let meal = Meal()
        
        if let id = dict["id"] as? Int {
            meal.id = id
        }
        
        //only for recipe ranking //totalRank
        if let totalRank = dict["totalRank"] as? Int {
            meal.totalRank = totalRank
        }
        
        if let weekOrder = dict["weekOrder"] as? Int {
            meal.weekOrder = weekOrder
        }
        
        if let previousWeekOrder = dict["previousWeekOrder"] as? Int {
            meal.previousWeekOrder = previousWeekOrder
        }
        
        if let mealStatus = dict["mealStatus"] as? String {
            meal.status = mealStatus
        }
        
        //reaction
        if let childReactionDict = dict["childReaction"] as? NSDictionary {
            if let mealReaction = childReactionDict["reaction"] as? String {
                meal.reaction = mealReaction
            }
        }
        
        if let isFavourite = dict["isFavorite"] as? Bool{
            meal.isFavorite = isFavourite
        }
        
//        meal.isFavorite = dict["isFavorite"] as! Bool
        
        meal.recipe = parseRecipe(dict: dict["recipe"]as! NSDictionary)
        
        return meal
        
    }
    
    
    func parseRecipe(dict: NSDictionary) -> Recipe {
        
        let recipe = Recipe()

        recipe.id = dict["id"] as! Int
        recipe.name = dict["name"] as! String
        
        if let typeDict = dict["course"] as? NSDictionary {
            recipe.type = typeDict["code"] as! String
        }

        if let attachments = dict["attachments"] as? NSArray {
            if(attachments.count > 0){
                for attachment in ((attachments as? [[String:Any]]))! {

                    let tag = attachment["tag"] as? String
                    if ( tag == "image"){
                        if let uuid = attachment["uuid"] as? String {
                            recipe.imageURLsArray.append(imageBaseURL + uuid)
                        }
                    }

                }
            }
        }

        recipe.ratingMedal = dict["ratingMedal"] as? String ?? ""

        recipe.activeTimeDisplay = dict["activeTimeDisplay"] as? String ?? ""
        recipe.preparationTimeDisplay = dict["preparationTimeDisplay"] as? String ?? ""
        
        //-- optional now
        
        if let kcal = dict["kcal"] as? Double {
            recipe.kcal = Int(kcal)
        }
        
        if let kcalPerServing = dict["kcalPerServing"] as? Double {
            recipe.kcalPerServing = Int(kcalPerServing)
        }
        
        if let qcal = dict["qcal"] as? Double {
            recipe.qcal = Int(qcal)
        }
        
        if let qcalPerServing = dict["qcalPerServing"] as? Double {
            recipe.qcalPerServing = Int(qcalPerServing)
        }
        
        if let qcalToKCalRatio = dict["qcalToKCalRatio"] as? Double {
            recipe.qcalToKCalRatio = Int(qcalToKCalRatio)
        }
        
        if let numberServings = dict["numberServings"] as? Double {
            recipe.numberServings = Int(numberServings)
        }
        
        if let mealDescription = dict["description"] as? String {
            recipe.mealDescription = mealDescription
        }
        
        if let instructions = dict["instructions"] as? String {
            recipe.instructions = instructions
        }
        

        if let ingredientsArray = dict["ingredients"] as? NSArray {
            
            for (k, _) in ingredientsArray.enumerated() {

                let ingredientDict = ingredientsArray[k] as! NSDictionary

                let ingredient = Ingredient()
                ingredient.name = ingredientDict["displayName"] as! String
                ingredient.quantity = (ingredientDict["quantity"] as! NSNumber).stringValue
                ingredient.unit = ingredientDict["unit"] as! String

                recipe.ingredients.append(ingredient)
            }
            
        }
        
        if let publisher = dict["publisher"] as? String {
            recipe.publisher = publisher
        }
        
        if let qcalToKCalRatioPct = dict["qcalToKCalRatioPct"] as? Double {
            recipe.qcalToKCalRatioPct = qcalToKCalRatioPct
        }
        
        if let keywords = dict["keywords"] as? NSArray {
            
            for keyword in keywords {
                recipe.keywords.append(keyword as! String)
            }
            
        }
        
        if let sourceUrl = dict["sourceURL"] as? String {
            recipe.sourceUrl = sourceUrl
        }
        
        if let sourceImageUrl = dict["sourceImageURL"] as? String {
            recipe.sourceImageUrl = sourceImageUrl
        }
        
        return recipe

    }
    
    func styleSkyField(field: SkyFloatingLabelTextField, color: UIColor? = mainGreenColor) {
        
        
//        let fieldsColor = color as! UIColor
        
        field.font = mainFont(size: 12)
        //        field.titleColor = mainGreenColor
        field.tintColor = color // the color of the blinking cursor
        field.textColor = .black
        field.lineColor = color ?? .black
        field.selectedTitleColor = color ?? .black
        field.selectedLineColor = color ?? .black
        field.placeholderColor = color ?? .black

        field.lineHeight = 2.0 // bottom line height in points
        field.selectedLineHeight = 3.0
        
    }
    
    func getGuageRatio(value: Double) -> Double {
        
        let redMin = 0.75
        let redMax = 0.867
        let yellowMax = 0.9432
        let greenMax = 1.2
        
        var percentage = 0.0
        
        if(value <= redMin){
            percentage = 0
        }
        else if (value > redMin && value <= redMax){
            percentage = ( (value - redMin) / (redMax - redMin) ) *  GuageRedRatio
        }
        else if (value > redMax && value <= yellowMax){
            percentage = GuageRedRatio + ( ( (value - redMax) / (yellowMax - redMax) ) *  GuageYellowRatio )
        }
        else if (value > yellowMax && value <= greenMax){
            percentage = GuageRedRatio + GuageYellowRatio + ( ( (value - yellowMax) / (greenMax - yellowMax) ) * GuageGreenRatio )
        }
        else{
            percentage = 100
        }
        
        return percentage
    }
    
    func receiptExists() -> Bool {
        
        let receiptPath = Bundle.main.appStoreReceiptURL?.path
        if FileManager.default.fileExists(atPath: receiptPath!)
        {
            return true
        }
        else{
            return false
        }
        
    }

    func getReceipt() -> NSData{
        let receiptPath = Bundle.main.appStoreReceiptURL?.path
        
        var receiptData = NSData()
        
        if FileManager.default.fileExists(atPath: receiptPath!)
        {
            
            do{
                receiptData = try NSData(contentsOf: Bundle.main.appStoreReceiptURL!, options: NSData.ReadingOptions.alwaysMapped)
            }
            catch{
                print("ERROR: " + error.localizedDescription)
            }
        }
        
        return receiptData
    }
    
    func handleSubscription(){
        
//        SVProgressHUD.show()
//        RequestHelper.sharedInstance.getSubscriptionInfo { (response) in
//            if(response["success"] as? Bool == true){
//                SVProgressHUD.dismiss()
//                let isSubscribed  = response["isSubscribed"] as! Bool
//                let offerTrial  = !(response["usedTrial"] as! Bool)
//
//                if(isSubscribed){

                    let mainNavigationController = UINavigationController.init(rootViewController: MainViewController())
                    UIApplication.shared.keyWindow?.rootViewController = mainNavigationController

//                }
//                else{
//                    //pop up the subscription controller..
//                    let subscriptionVC = SubscriptionViewController()
//                    subscriptionVC.offerTrial = offerTrial
//
//                    UIApplication.shared.keyWindow?.rootViewController = subscriptionVC
//
//                }
//            }
//            else{
//                SVProgressHUD.dismiss()
//                let alertController = UIAlertController(title: "Something's wrong with the connection, please try again",
//                                                        message: nil,
//                                                        preferredStyle: .alert)
//                alertController.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
//                    self.handleSubscription()
//                }))
//                alertController.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { action in
//                    Utilities.sharedInstance.logout()
//                }))
//                UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: { })
//            }
//        }
//
    }

    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }

    func populateDefaultUserDefaultsValues() {
        
        if (!isKeyPresentInUserDefaults(key: filtersCuisinesArrayKey)){
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: [Cuisine]())
            UserDefaults.standard.set(encodedData, forKey: filtersCuisinesArrayKey)
        }
        if (!isKeyPresentInUserDefaults(key: filtersBreakfastKey)){
            UserDefaults.standard.set(true, forKey: filtersBreakfastKey)
        }
        if (!isKeyPresentInUserDefaults(key: filtersLunchKey)){
            UserDefaults.standard.set(true, forKey: filtersLunchKey)
        }
        if (!isKeyPresentInUserDefaults(key: filtersDinnerKey)){
            UserDefaults.standard.set(true, forKey: filtersDinnerKey)
        }
        if (!isKeyPresentInUserDefaults(key: filtersSnackKey)){
            UserDefaults.standard.set(true, forKey: filtersSnackKey)
        }
        if (!isKeyPresentInUserDefaults(key: filtersVegeterianKey)){
            UserDefaults.standard.set(false, forKey: filtersVegeterianKey)
        }
        if (!isKeyPresentInUserDefaults(key: filtersVeganKey)){
            UserDefaults.standard.set(false, forKey: filtersVeganKey)
        }
        if (!isKeyPresentInUserDefaults(key: filtersPorkFreeKey)){
            UserDefaults.standard.set(false, forKey: filtersPorkFreeKey)
        }
        if (!isKeyPresentInUserDefaults(key: filtersQuickRecipesKey)){
            UserDefaults.standard.set(false, forKey: filtersQuickRecipesKey)
        }
        if (!isKeyPresentInUserDefaults(key: filtersGoldkey)){
            UserDefaults.standard.set(true, forKey: filtersGoldkey)
        }
        if (!isKeyPresentInUserDefaults(key: filtersSilverKey)){
            UserDefaults.standard.set(true, forKey: filtersSilverKey)
        }
        if (!isKeyPresentInUserDefaults(key: filtersBronzeKey)){
            UserDefaults.standard.set(true, forKey: filtersBronzeKey)
        }
        
        UserDefaults.standard.synchronize()
        
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {

        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
    
}
