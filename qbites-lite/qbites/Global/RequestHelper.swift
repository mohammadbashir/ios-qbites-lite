//
//  RequestHelper.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 10/15/19.
//  Copyright © 2019 Mohammad Bashir sidani. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SVProgressHUD


class RequestHelper : NSObject {
    
    var genericFailMessage = "Something went wrong, please try again."
    
    static let sharedInstance = RequestHelper()
    
    //
    private static var Manager: Alamofire.SessionManager = {
        
        // Create the server trust policies
        let serverTrustPolicies: [String: ServerTrustPolicy] = [:
            
            //            "178.79.177.139": .disableEvaluation
        ]
        
        // Create custom manager
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let manager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        
        return manager
    }()
    //
    
    func signup(token: String, firstName: String, lastName: String, name:String, parentType: String, nationalityName: String, nationality2DigitCode: String, completionHandler:@escaping (_ result: NSMutableDictionary) -> Void){
        
        let completionDict: NSMutableDictionary = [:]
        
        let params = ["firstName": firstName, "lastName": lastName, "name": name, "parentType": parentType, "nationalityName": nationalityName,"nationality2DigitCode": nationality2DigitCode ,"lang1": "ENGLISH" ]
        
        //        let credentialData = "admin:admin".data(using: String.Encoding.utf8)!
        //        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Content-Type": "application/json"]
        //
        RequestHelper.Manager.request(signupURL + "?idtoken=" + token, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                let statusCode = response.response?.statusCode
                let dict = response.result.value as! NSDictionary
                
                if(statusCode == 200){
                    
                    //                    Utilities.sharedInstance.parseUserDictAndSave(dict: dict["user"] as! NSDictionary)
                    completionDict["success"] = true
                    
                }
                else{
                    var errorMessage = self.genericFailMessage
                    
                    let errorsDict = dict["errors"]  as? NSDictionary
                    if let valuesString = errorsDict?.allValues as? [String] {
                        errorMessage = valuesString[0]
                    }
                    
                    completionDict["success"] = false
                    completionDict["message"] = errorMessage
                }
                
                completionHandler(completionDict)
                break
                
            case .failure( _):
                
                completionDict["success"] = false
                completionDict["message"] = self.genericFailMessage
                completionHandler(completionDict)
            }
            
        }
        
    }
    
    func login( completionHandler:@escaping (_ result: NSMutableDictionary) -> Void){
        
        let completionDict: NSMutableDictionary = [:]
        
        let headers = ["X-Authorization-Firebase": appUser().firebaseToken]
        
        RequestHelper.Manager.request(loginURL, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                let statusCode = response.response?.statusCode
                let dict = response.result.value as! NSDictionary
                
                if(statusCode == 200){
                    
                    Utilities.sharedInstance.parseUserDictAndSave(dict: dict)
                    
                    if let childsArray = dict["childs"] as? NSArray {
                        if(childsArray.count > 0){
                            if let childDict = childsArray[0] as? NSDictionary {
                                Utilities.sharedInstance.parseUserDictAndSave(dict: ["child" : childDict])
                            }
                        }
                    }
                    
                    completionDict["success"] = true
                    
                }
                else{
                    var errorMessage = self.genericFailMessage
                    
                    let errorsDict = dict["errors"]  as? NSDictionary
                    if let valuesString = errorsDict?.allValues as? [String] {
                        errorMessage = valuesString[0]
                    }
                    
                    completionDict["success"] = false
                    completionDict["message"] = errorMessage
                }
                
                completionHandler(completionDict)
                break
                
            case .failure( _):
                
                completionDict["success"] = false
                completionDict["message"] = self.genericFailMessage
                completionHandler(completionDict)
            }
            
        }
        
    }
    
    func getCuisines( completionHandler:@escaping (_ result: NSMutableDictionary) -> Void){
        
        let completionDict: NSMutableDictionary = [:]
        
        let headers = ["X-Authorization-Firebase": appUser().firebaseToken]
        
        RequestHelper.Manager.request(cuisinesURL + "/" + String(appChild().id), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                let statusCode = response.response?.statusCode
                //                let dict = response.result.value as! NSDictionary
                
                if(statusCode == 200){
                    
                    let result = response.result.value as! NSArray
                    
                    var cuisinesGroupedArray = [NSDictionary]()
                    var cuisinesArray = [Cuisine]()
                    
                    for (index, _) in result.enumerated() {
                        
                        let elementDict = result[index] as! NSDictionary
                        
                        elementDict.forEach { (arg0) in
                            
                            var groupCuisinesArray = [Cuisine]()
                            
                            let (key, value) = arg0
                            
                            for element in value as! NSArray{
                                
                                let currentCuisineDict = element as! NSDictionary
                                let currentCuisineObjDict = currentCuisineDict["cuisine"] as! NSDictionary
                                
                                let cuisine = Cuisine()
                                cuisine.id = currentCuisineObjDict["id"] as! Int
                                cuisine.name = currentCuisineObjDict["name"] as! String
                                
                                if let attachments = currentCuisineObjDict["attachments"] as? NSArray {
                                    if(attachments.count > 0){
                                        for attachment in ((attachments as? [[String:Any]]))! {
                                            
                                            let tag = attachment["tag"] as? String
                                            if ( tag == "image"){
                                                if let uuid = attachment["uuid"] as? String {
                                                    cuisine.imageURL = imageBaseURL + uuid
                                                }
                                            }
                                            
                                        }
                                    }
                                }
                                
                                
                                if let reaction = (currentCuisineDict["reaction"] as? String)
                                {
                                    cuisine.reaction = reaction
                                }
                                
                                groupCuisinesArray.append(cuisine)
                                cuisinesArray.append(cuisine)
                                
                            }
                            
                            cuisinesGroupedArray.append(["key": key, "cuisines": groupCuisinesArray])
                            
                        }
                        
                    }
                    
                    completionDict["cuisinesArray"] = cuisinesArray
                    completionDict["groupedCuisinesArray"] = cuisinesGroupedArray
                    completionDict["success"] = true
                    
                }
                else{
                    let dict = response.result.value as! NSDictionary
                    
                    var errorMessage = self.genericFailMessage
                    
                    let errorsDict = dict["errors"]  as? NSDictionary
                    if let valuesString = errorsDict?.allValues as? [String] {
                        errorMessage = valuesString[0]
                    }
                    
                    completionDict["success"] = false
                    completionDict["message"] = errorMessage
                }
                
                completionHandler(completionDict)
                break
                
            case .failure( _):
                
                completionDict["success"] = false
                completionDict["message"] = self.genericFailMessage
                completionHandler(completionDict)
            }
            
        }
        
    }
    
    
    func setCuisinePreference(id: Int, action: String, completionHandler:@escaping (_ result: NSMutableDictionary) -> Void){
        
        let completionDict: NSMutableDictionary = [:]
        
        let headers = ["X-Authorization-Firebase": appUser().firebaseToken]
        
        var params = [:] as [String : Any]
        params["cuisine"] = ["id": id]
        //        params["parent"] = ["id": appParent().id]
        params["child"] = ["id": appChild().id]
        
        if(action == ""){
            params["reaction"] = NSNull()
        }
        else{
            params["reaction"] = action
        }
        
        RequestHelper.Manager.request(setCuisinePreferenceURL , method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                let statusCode = response.response?.statusCode
                let dict = response.result.value as! NSDictionary
                
                if(statusCode == 200){
                    Utilities.sharedInstance.parseUserDictAndSave(dict: dict)
                    completionDict["success"] = true
                }
                else{
                    var errorMessage = self.genericFailMessage
                    
                    let errorsDict = dict["errors"]  as? NSDictionary
                    if let valuesString = errorsDict?.allValues as? [String] {
                        errorMessage = valuesString[0]
                    }
                    
                    completionDict["success"] = false
                    completionDict["message"] = errorMessage
                }
                
                completionHandler(completionDict)
                break
                
            case .failure( _):
                
                completionDict["success"] = false
                completionDict["message"] = self.genericFailMessage
                completionHandler(completionDict)
            }
            
        }
        
    }
    
    func getFamily(completionHandler:@escaping (_ result: NSMutableDictionary) -> Void){
        
        let completionDict: NSMutableDictionary = [:]
        let headers = ["X-Authorization-Firebase": appUser().firebaseToken]
        
        RequestHelper.Manager.request(familyURL + "/" + String(appFamily().id) , method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                let statusCode = response.response?.statusCode
                let dict = response.result.value as! NSDictionary
                
                if(statusCode == 200){
                    
                    let parentsArray = dict["parents"] as! NSArray
                    let parentDict = parentsArray[0] as! NSDictionary
                    
                    if let childsArray = dict["childs"] as? NSArray {
                        if (childsArray.count > 0){
                            if let childDict = childsArray[0] as? NSDictionary {
                                Utilities.sharedInstance.parseUserDictAndSave(dict: ["child" : childDict])
                            }
                        }
                    }
                    
                    
                    Utilities.sharedInstance.parseUserDictAndSave(dict: ["parent" : parentDict])
                    
                    
                    completionDict["success"] = true
                }
                else{
                    var errorMessage = self.genericFailMessage
                    
                    let errorsDict = dict["errors"]  as? NSDictionary
                    if let valuesString = errorsDict?.allValues as? [String] {
                        errorMessage = valuesString[0]
                    }
                    
                    completionDict["success"] = false
                    completionDict["message"] = errorMessage
                }
                
                completionHandler(completionDict)
                break
                
            case .failure( _):
                
                completionDict["success"] = false
                completionDict["message"] = self.genericFailMessage
                completionHandler(completionDict)
            }
            
        }
        
    }
    
    func updateUserNotificationSettings(isNotificationEnabled: Bool, completionHandler:@escaping (_ result: NSMutableDictionary) -> Void){
        
        let completionDict: NSMutableDictionary = [:]
        let headers = ["X-Authorization-Firebase": appUser().firebaseToken, "Content-Type": "application/json"]
        
        RequestHelper.Manager.request(updateUserNotificationURL, method: .post, parameters: ["isNotificationsEnabled" : isNotificationEnabled], encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                let statusCode = response.response?.statusCode
                let dict = response.result.value as! NSDictionary
                
                if(statusCode == 200){
                    
                    Utilities.sharedInstance.parseUserDictAndSave(dict: ["parent" : dict])
                    completionDict["success"] = true
                    
                }
                else{
                    var errorMessage = self.genericFailMessage
                    
                    let errorsDict = dict["errors"]  as? NSDictionary
                    if let valuesString = errorsDict?.allValues as? [String] {
                        errorMessage = valuesString[0]
                    }
                    
                    completionDict["success"] = false
                    completionDict["message"] = errorMessage
                }
                
                completionHandler(completionDict)
                break
                
            case .failure( _):
                
                completionDict["success"] = false
                completionDict["message"] = self.genericFailMessage
                completionHandler(completionDict)
            }
            
        }
        
    }
    
    func updateParent(params: [String : Any], completionHandler:@escaping (_ result: NSMutableDictionary) -> Void){
        
        let completionDict: NSMutableDictionary = [:]
        let headers = ["X-Authorization-Firebase": appUser().firebaseToken, "Content-Type": "application/json"]
        
        RequestHelper.Manager.request(updateParentURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                let statusCode = response.response?.statusCode
                let dict = response.result.value as! NSDictionary
                
                if(statusCode == 200){
                    
                    Utilities.sharedInstance.parseUserDictAndSave(dict: ["parent" : dict])
                    completionDict["success"] = true
                    
                }
                else{
                    var errorMessage = self.genericFailMessage
                    
                    let errorsDict = dict["errors"]  as? NSDictionary
                    if let valuesString = errorsDict?.allValues as? [String] {
                        errorMessage = valuesString[0]
                    }
                    
                    completionDict["success"] = false
                    completionDict["message"] = errorMessage
                }
                
                completionHandler(completionDict)
                break
                
            case .failure( _):
                
                completionDict["success"] = false
                completionDict["message"] = self.genericFailMessage
                completionHandler(completionDict)
            }
            
        }
        
    }
    
    func createChild(params: [String : Any], completionHandler:@escaping (_ result: NSMutableDictionary) -> Void){
        
        let completionDict: NSMutableDictionary = [:]
        let headers = ["X-Authorization-Firebase": appUser().firebaseToken, "Content-Type": "application/json"]
        
        RequestHelper.Manager.request(createChildURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                let statusCode = response.response?.statusCode
                let dict = response.result.value as! NSDictionary
                
                if(statusCode == 200){
                    
                    Utilities.sharedInstance.parseUserDictAndSave(dict: ["child" : dict])
                    completionDict["success"] = true
                    
                }
                else{
                    var errorMessage = self.genericFailMessage
                    
                    let errorsDict = dict["errors"]  as? NSDictionary
                    if let valuesString = errorsDict?.allValues as? [String] {
                        errorMessage = valuesString[0]
                    }
                    
                    completionDict["success"] = false
                    completionDict["message"] = errorMessage
                }
                
                completionHandler(completionDict)
                break
                
            case .failure( _):
                
                completionDict["success"] = false
                completionDict["message"] = self.genericFailMessage
                completionHandler(completionDict)
            }
            
        }
        
    }
    
    func updateChild(params: [String : Any], completionHandler:@escaping (_ result: NSMutableDictionary) -> Void){
        
        let completionDict: NSMutableDictionary = [:]
        let headers = ["X-Authorization-Firebase": appUser().firebaseToken, "Content-Type": "application/json"]
        
        RequestHelper.Manager.request(updateChildURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                let statusCode = response.response?.statusCode
                let dict = response.result.value as! NSDictionary
                
                if(statusCode == 200){
                    
                    Utilities.sharedInstance.parseUserDictAndSave(dict: ["child" : dict])
                    completionDict["success"] = true
                    
                }
                else{
                    var errorMessage = self.genericFailMessage
                    
                    let errorsDict = dict["errors"]  as? NSDictionary
                    if let valuesString = errorsDict?.allValues as? [String] {
                        errorMessage = valuesString[0]
                    }
                    
                    completionDict["success"] = false
                    completionDict["message"] = errorMessage
                }
                
                completionHandler(completionDict)
                break
                
            case .failure( _):
                
                completionDict["success"] = false
                completionDict["message"] = self.genericFailMessage
                completionHandler(completionDict)
            }
            
        }
        
    }
    
    func getMealPlan(forceRefresh: Bool? = false, completionHandler:@escaping (_ result: NSMutableDictionary) -> Void){
        
        let completionDict: NSMutableDictionary = [:]
        
        let headers = ["X-Authorization-Firebase": appUser().firebaseToken]
        
        var url = mealPlanURL + "/" + String(appChild().id)
        if(forceRefresh == true){
            url = url + "?forceNewInstances=true"
        }
        
        RequestHelper.Manager.request(url , method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                let statusCode = response.response?.statusCode
                //                let dict = response.result.value as! NSDictionary
                
                if(statusCode == 200){
                    
                    let mealsDataArray = response.result.value as! NSArray
                    
                    var weekPlansArray = [DailyPlan]()
                    
                    for (i,_) in mealsDataArray.enumerated() {
                        let dayMealsDict = mealsDataArray[i] as! NSDictionary
                        
                        let dailyPlan = DailyPlan()
                        
                        dailyPlan.id = dayMealsDict["id"] as! Int
                        dailyPlan.date = (dayMealsDict["date"] as! String).components(separatedBy: "+")[0].toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSS")!
                        
                        let mealDictsArray = dayMealsDict["displayMeals"] as! NSArray
                        
                        if(Calendar.current.isDateInToday(dailyPlan.date)){
                            dailyPlan.title = "Today"
                        }
                        else if (Calendar.current.isDateInTomorrow(dailyPlan.date)){
                            dailyPlan.title = "Tomorrow"
                        }
                        else{
                            dailyPlan.title = dailyPlan.date.toString(withFormat: "EEEE")
                        }
                        
                        for (j,_) in mealDictsArray.enumerated() {
                            
                            let meal = Utilities.sharedInstance.parseMeal(dict: mealDictsArray[j] as! NSDictionary)
                            
                            dailyPlan.mealsArray.append(meal)
                            
                        }
                        
                        weekPlansArray.append(dailyPlan)
                        
                    }
                    
                    
                    completionDict["weekPlansArray"] = weekPlansArray
                    completionDict["success"] = true
                    
                }
                else{
                    
                    let dict = response.result.value as! NSDictionary
                    
                    var errorMessage = self.genericFailMessage
                    
                    let errorsDict = dict["errors"]  as? NSDictionary
                    if let valuesString = errorsDict?.allValues as? [String] {
                        errorMessage = valuesString[0]
                    }
                    
                    completionDict["success"] = false
                    completionDict["message"] = errorMessage
                }
                
                completionHandler(completionDict)
                break
                
            case .failure( _):
                
                completionDict["success"] = false
                completionDict["message"] = self.genericFailMessage
                completionHandler(completionDict)
            }
            
        }
        
    }
    
    func getPreviousMeals(includeAll: Bool, completionHandler:@escaping (_ result: NSMutableDictionary) -> Void){
        
        let completionDict: NSMutableDictionary = [:]
        
        let headers = ["X-Authorization-Firebase": appUser().firebaseToken]
        
        RequestHelper.Manager.request(previousMealsURL + "/" + String(appChild().id) + "?includeAll=" + String(includeAll) , method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                let statusCode = response.response?.statusCode
                //                let dict = response.result.value as! NSDictionary
                
                if(statusCode == 200){
                    
                    let mealsDataArray = response.result.value as! NSArray
                    
                    var weekPlansArray = [DailyPlan]()
                    
                    for (i,_) in mealsDataArray.enumerated() {
                        let dayMealsDict = mealsDataArray[i] as! NSDictionary
                        
                        let dailyPlan = DailyPlan()
                        
                        //                        dailyPlan.id = dayMealsDict["id"] as! Int
                        dailyPlan.date = (dayMealsDict["date"] as! String).components(separatedBy: "+")[0].toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSS")!
                        
                        let mealDictsArray = dayMealsDict["displayMeals"] as! NSArray
                        
                        dailyPlan.title = dailyPlan.date.toString(withFormat: "EEE MMM dd")
                        
                        for (j,_) in mealDictsArray.enumerated() {
                            
                            let meal = Utilities.sharedInstance.parseMeal(dict: mealDictsArray[j] as! NSDictionary)
                            
                            dailyPlan.mealsArray.append(meal)
                            
                        }
                        
                        weekPlansArray.append(dailyPlan)
                        
                    }
                    
                    completionDict["previousMealsArray"] = weekPlansArray
                    completionDict["success"] = true
                    
                }
                else{
                    
                    let dict = response.result.value as! NSDictionary
                    
                    var errorMessage = self.genericFailMessage
                    
                    let errorsDict = dict["errors"]  as? NSDictionary
                    if let valuesString = errorsDict?.allValues as? [String] {
                        errorMessage = valuesString[0]
                    }
                    
                    completionDict["success"] = false
                    completionDict["message"] = errorMessage
                }
                
                completionHandler(completionDict)
                break
                
            case .failure( _):
                
                completionDict["success"] = false
                completionDict["message"] = self.genericFailMessage
                completionHandler(completionDict)
            }
            
        }
        
    }
    
    func replaceMeal(mealId: Int, completionHandler:@escaping (_ result: NSMutableDictionary) -> Void){
        
        let completionDict: NSMutableDictionary = [:]
        
        let headers = ["X-Authorization-Firebase": appUser().firebaseToken]
        
        RequestHelper.Manager.request(replaceMealURL + "/" + String(mealId), method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                let statusCode = response.response?.statusCode
                let dict = response.result.value as! NSDictionary
                
                if(statusCode == 200){
                    
                    completionDict["success"] = true
                    
                }
                else{
                    
                    var errorMessage = self.genericFailMessage
                    
                    let errorsDict = dict["errors"]  as? NSDictionary
                    if let valuesString = errorsDict?.allValues as? [String] {
                        errorMessage = valuesString[0]
                    }
                    
                    completionDict["success"] = false
                    completionDict["message"] = errorMessage
                }
                
                completionHandler(completionDict)
                break
                
            case .failure( _):
                
                completionDict["success"] = false
                completionDict["message"] = self.genericFailMessage
                completionHandler(completionDict)
            }
            
        }
        
    }
    
    func skipMeal(mealId: Int, completionHandler:@escaping (_ result: NSMutableDictionary) -> Void){
        
        let completionDict: NSMutableDictionary = [:]
        
        let headers = ["X-Authorization-Firebase": appUser().firebaseToken]
        
        RequestHelper.Manager.request(skipMealURL + "/" + String(mealId), method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                let statusCode = response.response?.statusCode
                let dict = response.result.value as! NSDictionary
                
                if(statusCode == 200){
                    
                    completionDict["success"] = true
                    
                }
                else{
                    
                    var errorMessage = self.genericFailMessage
                    
                    let errorsDict = dict["errors"]  as? NSDictionary
                    if let valuesString = errorsDict?.allValues as? [String] {
                        errorMessage = valuesString[0]
                    }
                    
                    completionDict["success"] = false
                    completionDict["message"] = errorMessage
                }
                
                completionHandler(completionDict)
                break
                
            case .failure( _):
                
                completionDict["success"] = false
                completionDict["message"] = self.genericFailMessage
                completionHandler(completionDict)
            }
            
        }
        
    }
    
    func consumeMeal(mealId: Int, amount: Int, completionHandler:@escaping (_ result: NSMutableDictionary) -> Void){
        
        let completionDict: NSMutableDictionary = [:]
        
        let headers = ["X-Authorization-Firebase": appUser().firebaseToken]
        
        RequestHelper.Manager.request(consumeMealURL + "/" + String(mealId) + "?amount=" + String(Double(amount)/100), method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                let statusCode = response.response?.statusCode
                let dict = response.result.value as! NSDictionary
                
                if(statusCode == 200){
                    
                    completionDict["success"] = true
                    
                }
                else{
                    
                    var errorMessage = self.genericFailMessage
                    
                    let errorsDict = dict["errors"]  as? NSDictionary
                    if let valuesString = errorsDict?.allValues as? [String] {
                        errorMessage = valuesString[0]
                    }
                    
                    completionDict["success"] = false
                    completionDict["message"] = errorMessage
                }
                
                completionHandler(completionDict)
                break
                
            case .failure( _):
                
                completionDict["success"] = false
                completionDict["message"] = self.genericFailMessage
                completionHandler(completionDict)
            }
            
        }
        
    }
    
    func updateMeal(params:[String: Any], completionHandler:@escaping (_ result: NSMutableDictionary) -> Void){
        
        let completionDict: NSMutableDictionary = [:]
        
        let headers = ["X-Authorization-Firebase": appUser().firebaseToken]
        
        //        ["id": dailyPlanId, "meal": mealType]
        
        RequestHelper.Manager.request(updateMealURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                let statusCode = response.response?.statusCode
                let dict = response.result.value as! NSDictionary
                
                if(statusCode == 200){
                    
                    completionDict["success"] = true
                    
                }
                else{
                    
                    var errorMessage = self.genericFailMessage
                    
                    let errorsDict = dict["errors"]  as? NSDictionary
                    if let valuesString = errorsDict?.allValues as? [String] {
                        errorMessage = valuesString[0]
                    }
                    
                    completionDict["success"] = false
                    completionDict["message"] = errorMessage
                }
                
                completionHandler(completionDict)
                break
                
            case .failure( _):
                
                completionDict["success"] = false
                completionDict["message"] = self.genericFailMessage
                completionHandler(completionDict)
            }
            
        }
        
    }
    
    func setRecepieReaction(recepieId: Int, action: String, completionHandler:@escaping (_ result: NSMutableDictionary) -> Void){
        
        let completionDict: NSMutableDictionary = [:]
        
        let headers = ["X-Authorization-Firebase": appUser().firebaseToken]
        
        var params = [:] as [String : Any]
        params["recipe"] = ["id": recepieId]
        params["child"] = ["id": appChild().id]
        
        if(action == ""){
            params["reaction"] = NSNull()
        }
        else{
            params["reaction"] = action
        }
        
        RequestHelper.Manager.request(setRecepieReactionURL , method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                let statusCode = response.response?.statusCode
                let dict = response.result.value as! NSDictionary
                
                if(statusCode == 200){
                    completionDict["success"] = true
                }
                else{
                    var errorMessage = self.genericFailMessage
                    
                    let errorsDict = dict["errors"]  as? NSDictionary
                    if let valuesString = errorsDict?.allValues as? [String] {
                        errorMessage = valuesString[0]
                    }
                    
                    completionDict["success"] = false
                    completionDict["message"] = errorMessage
                }
                
                completionHandler(completionDict)
                break
                
            case .failure( _):
                
                completionDict["success"] = false
                completionDict["message"] = self.genericFailMessage
                completionHandler(completionDict)
            }
            
        }
        
    }
    
    
    func getRecepieShareTemplate(recepieId: Int, completionHandler:@escaping (_ result: NSMutableDictionary) -> Void){
        
        let completionDict: NSMutableDictionary = [:]
        
        let headers = ["X-Authorization-Firebase": appUser().firebaseToken]
        
        RequestHelper.Manager.request(shareRecepirURL + "/" + String(recepieId) , method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                let statusCode = response.response?.statusCode
                let dict = response.result.value as! NSDictionary
                
                if(statusCode == 200){
                    completionDict["success"] = true
                    completionDict["template"] = dict["template"]
                }
                else{
                    var errorMessage = self.genericFailMessage
                    
                    let errorsDict = dict["errors"]  as? NSDictionary
                    if let valuesString = errorsDict?.allValues as? [String] {
                        errorMessage = valuesString[0]
                    }
                    
                    completionDict["success"] = false
                    completionDict["message"] = errorMessage
                }
                
                completionHandler(completionDict)
                break
                
            case .failure( _):
                
                completionDict["success"] = false
                completionDict["message"] = self.genericFailMessage
                completionHandler(completionDict)
            }
            
        }
        
    }
    
    func favouriteRecepie(recepieId: Int, isFavorite:Bool, completionHandler:@escaping (_ result: NSMutableDictionary) -> Void){
        
        let completionDict: NSMutableDictionary = [:]
        
        let headers = ["X-Authorization-Firebase": appUser().firebaseToken]
        
        var params = [:] as [String : Any]
        params["recipe"] = ["id": recepieId]
        params["child"] = ["id": appChild().id]
        params["isFavorite"] = isFavorite
        
        RequestHelper.Manager.request(favouriteMealURL , method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                let statusCode = response.response?.statusCode
                let dict = response.result.value as! NSDictionary
                
                if(statusCode == 200){
                    completionDict["success"] = true
                }
                else{
                    var errorMessage = self.genericFailMessage
                    
                    let errorsDict = dict["errors"]  as? NSDictionary
                    if let valuesString = errorsDict?.allValues as? [String] {
                        errorMessage = valuesString[0]
                    }
                    
                    completionDict["success"] = false
                    completionDict["message"] = errorMessage
                }
                
                completionHandler(completionDict)
                break
                
            case .failure( _):
                
                completionDict["success"] = false
                completionDict["message"] = self.genericFailMessage
                completionHandler(completionDict)
            }
            
        }
        
    }
    
    func getCookBook(completionHandler:@escaping (_ result: NSMutableDictionary) -> Void){
        
        let completionDict: NSMutableDictionary = [:]
        
        let headers = ["X-Authorization-Firebase": appUser().firebaseToken]
        
        RequestHelper.Manager.request(getCookBookURL + "/" + String(appChild().id) , method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                let statusCode = response.response?.statusCode
                //                let dict = response.result.value as! NSDictionary
                
                if(statusCode == 200){
                    completionDict["success"] = true
                    
                    let mealDictsArray = response.result.value as! NSArray
                    var meals = [Meal]()
                    
                    //--
                    
                    for (j, _) in mealDictsArray.enumerated(){
                        
                        let meal = Utilities.sharedInstance.parseMeal(dict: mealDictsArray[j] as! NSDictionary)
                        
                        meals.append(meal)
                    }
                    
                    //--
                    
                    completionDict["favorites"] = meals
                    
                }
                else{
                    
                    let dict = response.result.value as! NSDictionary
                    
                    var errorMessage = self.genericFailMessage
                    
                    let errorsDict = dict["errors"]  as? NSDictionary
                    if let valuesString = errorsDict?.allValues as? [String] {
                        errorMessage = valuesString[0]
                    }
                    
                    completionDict["success"] = false
                    completionDict["message"] = errorMessage
                }
                
                completionHandler(completionDict)
                break
                
            case .failure( _):
                
                completionDict["success"] = false
                completionDict["message"] = self.genericFailMessage
                completionHandler(completionDict)
            }
            
        }
        
    }
    
    func getChildAssessment(period: String, completionHandler:@escaping (_ result: NSMutableDictionary) -> Void){
        
        let completionDict: NSMutableDictionary = [:]
        
        let headers = ["X-Authorization-Firebase": appUser().firebaseToken]
        
        RequestHelper.Manager.request(getChildAssessmentURL + "/" + String(appChild().id) + "?period=" + period , method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                let statusCode = response.response?.statusCode
                let dict = response.result.value as! NSDictionary
                
                if(statusCode == 200){
                    completionDict["success"] = true
                    
                    let assessment = Assessment()
                    
                    assessment.qcal_min = dict["qcal_min"] as! Double
                    assessment.qcal_max = dict["qcal_max"] as! Double
                    
                    assessment.diet_diversity_min = dict["diet_diversity_min"] as! Double
                    assessment.diet_diversity_max = dict["diet_diversity_max"] as! Double
                    
                    assessment.diet_adequacy_min = dict["diet_adequacy_min"] as! Double
                    assessment.diet_adequacy_max = dict["diet_adequacy_max"] as! Double
                    
                    assessment.diet_diversity = dict["diet_diversity"] as! Double
                    assessment.diet_adequacy = dict["diet_adequacy"] as! Double
                    assessment.qcal = dict["qcal"] as! Double
                    
                    assessment.qcalToKCalRatioPct = dict["qcalToKCalRatioPct"] as? Double ?? 0
                    
                    completionDict["assessment"] = assessment
                    
                }
                else{
                    var errorMessage = self.genericFailMessage
                    
                    let errorsDict = dict["errors"]  as? NSDictionary
                    if let valuesString = errorsDict?.allValues as? [String] {
                        errorMessage = valuesString[0]
                    }
                    
                    completionDict["success"] = false
                    completionDict["message"] = errorMessage
                }
                
                completionHandler(completionDict)
                break
                
            case .failure( _):
                
                completionDict["success"] = false
                completionDict["message"] = self.genericFailMessage
                completionHandler(completionDict)
            }
            
        }
        
    }
    
    func getDailyInput( completionHandler:@escaping (_ result: NSMutableDictionary) -> Void){
        
        let completionDict: NSMutableDictionary = [:]
        
        let headers = ["X-Authorization-Firebase": appUser().firebaseToken]
        
        let timeMarginSeconds = TimeZone.current.secondsFromGMT()
        let timeMarginHours = timeMarginSeconds/3600
        
        RequestHelper.Manager.request(getDailyInputURL + "/" + String(appChild().id) + "?timeMargin=" + String(Int(timeMarginHours)), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                let statusCode = response.response?.statusCode
                
                if(statusCode == 200 || statusCode == 204){
                    completionDict["success"] = true
                    
                    if let dict = response.result.value as? NSDictionary {
                        completionDict["mealId"] = dict["id"] as! Int
                        completionDict["date"] = (dict["date"] as! String).components(separatedBy: "+")[0].toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSS")!
                    }
                    
                    
                }
                else{
                    let dict = response.result.value as! NSDictionary
                    
                    var errorMessage = self.genericFailMessage
                    
                    let errorsDict = dict["errors"]  as? NSDictionary
                    if let valuesString = errorsDict?.allValues as? [String] {
                        errorMessage = valuesString[0]
                    }
                    
                    completionDict["success"] = false
                    completionDict["message"] = errorMessage
                }
                
                completionHandler(completionDict)
                break
                
            case .failure( _):
                
                completionDict["success"] = false
                completionDict["message"] = self.genericFailMessage
                completionHandler(completionDict)
            }
            
        }
        
    }
    
    
    func setDailyInput(params: [String : Any], completionHandler:@escaping (_ result: NSMutableDictionary) -> Void){
        
        let completionDict: NSMutableDictionary = [:]
        
        let headers = ["X-Authorization-Firebase": appUser().firebaseToken]
        
        let timeMarginSeconds = TimeZone.current.secondsFromGMT()
        let timeMarginHours = timeMarginSeconds/3600
        
        RequestHelper.Manager.request(createDailyInputURL + "?timeMargin=" + String(Int(timeMarginHours)), method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                let statusCode = response.response?.statusCode
                
                if(statusCode == 200){
                    completionDict["success"] = true
                    
                    
                }
                else{
                    let dict = response.result.value as! NSDictionary
                    
                    var errorMessage = self.genericFailMessage
                    
                    let errorsDict = dict["errors"]  as? NSDictionary
                    if let valuesString = errorsDict?.allValues as? [String] {
                        errorMessage = valuesString[0]
                    }
                    
                    completionDict["success"] = false
                    completionDict["message"] = errorMessage
                }
                
                completionHandler(completionDict)
                break
                
            case .failure( _):
                
                completionDict["success"] = false
                completionDict["message"] = self.genericFailMessage
                completionHandler(completionDict)
            }
            
        }
        
    }
    
    func getRecipe(recipeId: Int, completionHandler:@escaping (_ result: NSMutableDictionary) -> Void){
        
        let completionDict: NSMutableDictionary = [:]
        
        let headers = ["X-Authorization-Firebase": appUser().firebaseToken]
        
        RequestHelper.Manager.request(getRecipeURL + "/" + String(recipeId), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                let statusCode = response.response?.statusCode
                let dict = response.result.value as! NSDictionary
                
                if(statusCode == 200){
                    completionDict["success"] = true
                    let recipe = Utilities.sharedInstance.parseRecipe(dict: dict)
                    completionDict["recipe"] = recipe
                    
                }
                else{
                    var errorMessage = self.genericFailMessage
                    
                    let errorsDict = dict["errors"]  as? NSDictionary
                    if let valuesString = errorsDict?.allValues as? [String] {
                        errorMessage = valuesString[0]
                    }
                    
                    completionDict["success"] = false
                    completionDict["message"] = errorMessage
                }
                
                completionHandler(completionDict)
                break
                
            case .failure( _):
                
                completionDict["success"] = false
                completionDict["message"] = self.genericFailMessage
                completionHandler(completionDict)
            }
            
        }
        
    }
    
    func searchRecipes(keyword: String, foodType: String, completionHandler:@escaping (_ result: NSMutableDictionary) -> Void){
        
        let completionDict: NSMutableDictionary = [:]
        
        let headers = ["X-Authorization-Firebase": appUser().firebaseToken]
        
        let encodedKeyword = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        var urlString = searchRecipesURL + "?childId=" + String(appChild().id) + "&searchFields=" + "GENERAL"
        urlString = urlString + "&keyword=" + (encodedKeyword ?? "") + "&category=" + foodType
        
        RequestHelper.Manager.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                let statusCode = response.response?.statusCode
                let dict = response.result.value as! NSDictionary
                
                if(statusCode == 200){
                    completionDict["success"] = true
                    
                    let mainDict = dict["GENERAL"] as! NSDictionary
                    let recipesDictArray = mainDict["content"] as! NSArray
                    
                    var recipesArray = [Recipe]()
                    
                    for (i,_) in recipesDictArray.enumerated() {
                        
                        let recipeDict = recipesDictArray[i] as! NSDictionary
                        let recipe = Utilities.sharedInstance.parseRecipe(dict: recipeDict)
                        recipesArray.append(recipe)
                        
                    }
                    
                    completionDict["recipes"] = recipesArray
                    
                }
                else{
                    var errorMessage = self.genericFailMessage
                    
                    let errorsDict = dict["errors"]  as? NSDictionary
                    if let valuesString = errorsDict?.allValues as? [String] {
                        errorMessage = valuesString[0]
                    }
                    
                    completionDict["success"] = false
                    completionDict["message"] = errorMessage
                }
                
                completionHandler(completionDict)
                break
                
            case .failure( _):
                
                completionDict["success"] = false
                completionDict["message"] = self.genericFailMessage
                completionHandler(completionDict)
            }
            
        }
        
    }
    
    func replaceMealWith(mealId: Int, recipeId: Int, completionHandler:@escaping (_ result: NSMutableDictionary) -> Void){
        
        let completionDict: NSMutableDictionary = [:]
        
        let headers = ["X-Authorization-Firebase": appUser().firebaseToken]
        
        RequestHelper.Manager.request(replaceWithURL + "/" + String(mealId) + "?replacementRecipe=" + String(recipeId), method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                let statusCode = response.response?.statusCode
                let dict = response.result.value as! NSDictionary
                
                if(statusCode == 200){
                    completionDict["success"] = true
                }
                else{
                    var errorMessage = self.genericFailMessage
                    
                    let errorsDict = dict["errors"]  as? NSDictionary
                    if let valuesString = errorsDict?.allValues as? [String] {
                        errorMessage = valuesString[0]
                    }
                    
                    completionDict["success"] = false
                    completionDict["message"] = errorMessage
                }
                
                completionHandler(completionDict)
                break
                
            case .failure( _):
                
                completionDict["success"] = false
                completionDict["message"] = self.genericFailMessage
                completionHandler(completionDict)
            }
            
        }
        
    }
    
    
    func getMealRankings(cuisines: String, rankingDuration: String, completionHandler:@escaping (_ result: NSMutableDictionary) -> Void){
        
        let completionDict: NSMutableDictionary = [:]
        
        let headers = ["X-Authorization-Firebase": appUser().firebaseToken]
        
        var url = rankingsURL + "/" + String(appChild().id) + "?rankingDuration=" + rankingDuration
        if(cuisines != ""){
            url = url + "&cuisines=" + cuisines
        }
        
        RequestHelper.Manager.request(url , method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                let statusCode = response.response?.statusCode
                
                if(statusCode == 200){
                    let responesDict = response.result.value as! NSDictionary
                    let dict = responesDict["content"] as! NSArray
                    
                    var mealsArray = [Meal]()
                    for (i,_) in dict.enumerated(){
                        
                        let mainDict = dict[i] as! NSDictionary
                        //                        let recipeDict = mainDict["recipe"] as! NSDictionary
                        let meal = Utilities.sharedInstance.parseMeal(dict: mainDict)
                        mealsArray.append(meal)
                    }
                    completionDict["meals"] = mealsArray
                    completionDict["success"] = true
                }
                else{
                    let dict = response.result.value as! NSDictionary
                    var errorMessage = self.genericFailMessage
                    
                    let errorsDict = dict["errors"]  as? NSDictionary
                    if let valuesString = errorsDict?.allValues as? [String] {
                        errorMessage = valuesString[0]
                    }
                    
                    completionDict["success"] = false
                    completionDict["message"] = errorMessage
                }
                
                completionHandler(completionDict)
                break
                
            case .failure( _):
                
                completionDict["success"] = false
                completionDict["message"] = self.genericFailMessage
                completionHandler(completionDict)
            }
            
        }
        
    }
    
    func searchCuisines(keyword: String, completionHandler:@escaping (_ result: NSMutableDictionary) -> Void){
        
        let completionDict: NSMutableDictionary = [:]
        
        let headers = ["X-Authorization-Firebase": appUser().firebaseToken]
        
        let encodedKeyword = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let urlString = searchCuisinesURL + "?keyword=" + (encodedKeyword ?? "") + "&size=50"
        
        RequestHelper.Manager.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                let statusCode = response.response?.statusCode
                let dict = response.result.value as! NSDictionary
                
                if(statusCode == 200){
                    completionDict["success"] = true
                    
                    let cuisinesDictArray = dict["content"] as! NSArray
                    var cuisinesArray = [Cuisine]()
                    
                    for (index, _) in cuisinesDictArray.enumerated() {
                        
                        let element = cuisinesDictArray[index] as! NSDictionary
                        
                        let currentCuisineObjDict = element
                        
                        let cuisine = Cuisine()
                        cuisine.id = currentCuisineObjDict["id"] as! Int
                        cuisine.name = currentCuisineObjDict["name"] as! String
                        
                        if let attachments = currentCuisineObjDict["attachments"] as? NSArray {
                            if(attachments.count > 0){
                                for attachment in ((attachments as? [[String:Any]]))! {
                                    
                                    let tag = attachment["tag"] as? String
                                    if ( tag == "image"){
                                        if let uuid = attachment["uuid"] as? String {
                                            cuisine.imageURL = imageBaseURL + uuid
                                        }
                                    }
                                    
                                }
                            }
                        }
                        
                        cuisinesArray.append(cuisine)
                        
                    }
                    
                    completionDict["cuisines"] = cuisinesArray
                    
                }
                else{
                    var errorMessage = self.genericFailMessage
                    
                    let errorsDict = dict["errors"]  as? NSDictionary
                    if let valuesString = errorsDict?.allValues as? [String] {
                        errorMessage = valuesString[0]
                    }
                    
                    completionDict["success"] = false
                    completionDict["message"] = errorMessage
                }
                
                completionHandler(completionDict)
                break
                
            case .failure( _):
                
                completionDict["success"] = false
                completionDict["message"] = self.genericFailMessage
                completionHandler(completionDict)
            }
            
        }
        
    }
    
    func searchDisplayIngredients(keyword: String, completionHandler:@escaping (_ result: NSMutableDictionary) -> Void){
        
        let completionDict: NSMutableDictionary = [:]
        
        let headers = ["X-Authorization-Firebase": appUser().firebaseToken]
        
        let encodedKeyword = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let urlString = searchDisplayIngredientsURL + "?keyword=" + (encodedKeyword ?? "") + "&size=50"
        
        RequestHelper.Manager.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                let statusCode = response.response?.statusCode
                let dict = response.result.value as! NSDictionary
                
                if(statusCode == 200){
                    completionDict["success"] = true
                    
                    let displayIngredientsArray = dict["content"] as! NSArray
                    var ingredientsArray = [DisplayIngredient]()
                    
                    for (index, _) in displayIngredientsArray.enumerated() {
                        
                        let element = displayIngredientsArray[index] as! NSDictionary
                        let currentDisplayIngredientObjDict = element
                        
                        let displayIngredient = DisplayIngredient()
                        displayIngredient.id = currentDisplayIngredientObjDict["id"] as! Int
                        displayIngredient.name = currentDisplayIngredientObjDict["name"] as! String
                        
                        let parentIngredientDict = currentDisplayIngredientObjDict["ingredient"] as! NSDictionary
                        displayIngredient.ingredientID = parentIngredientDict["id"] as! Int
                        
                        ingredientsArray.append(displayIngredient)
                        
                    }
                    
                    completionDict["ingredients"] = ingredientsArray
                    
                }
                else{
                    var errorMessage = self.genericFailMessage
                    
                    let errorsDict = dict["errors"]  as? NSDictionary
                    if let valuesString = errorsDict?.allValues as? [String] {
                        errorMessage = valuesString[0]
                    }
                    
                    completionDict["success"] = false
                    completionDict["message"] = errorMessage
                }
                
                completionHandler(completionDict)
                break
                
            case .failure( _):
                
                completionDict["success"] = false
                completionDict["message"] = self.genericFailMessage
                completionHandler(completionDict)
            }
            
        }
        
    }
    
    func createDisplayIngredient(name: String, completionHandler:@escaping (_ result: NSMutableDictionary) -> Void){
        
        let completionDict: NSMutableDictionary = [:]
        
        let headers = ["X-Authorization-Firebase": appUser().firebaseToken]
        
        let params = ["name" : name]
        
        RequestHelper.Manager.request(createDisplayIngredientsURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                let statusCode = response.response?.statusCode
                let dict = response.result.value as! NSDictionary
                
                if(statusCode == 200){
                    completionDict["success"] = true
                    
                    let displayIngredient = DisplayIngredient()
                    displayIngredient.id = dict["id"] as! Int
                    displayIngredient.name = dict["name"] as! String
                    
                    let inredientDict = dict["ingredient"] as! NSDictionary
                    displayIngredient.ingredientID = inredientDict["id"] as! Int
                    
                    completionDict["ingredient"] = displayIngredient
                    
                }
                else{
                    var errorMessage = self.genericFailMessage
                    
                    let errorsDict = dict["errors"]  as? NSDictionary
                    if let valuesString = errorsDict?.allValues as? [String] {
                        errorMessage = valuesString[0]
                    }
                    
                    completionDict["success"] = false
                    completionDict["message"] = errorMessage
                }
                
                completionHandler(completionDict)
                break
                
            case .failure( _):
                
                completionDict["success"] = false
                completionDict["message"] = self.genericFailMessage
                completionHandler(completionDict)
            }
            
        }
        
    }
    
    func createRecipe(params: [String: Any], completionHandler:@escaping (_ result: NSMutableDictionary) -> Void){
        
        let completionDict: NSMutableDictionary = [:]
        
        let headers = ["X-Authorization-Firebase": appUser().firebaseToken]
        
        RequestHelper.Manager.request(createRecipeURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                let statusCode = response.response?.statusCode
                let dict = response.result.value as! NSDictionary
                
                if(statusCode == 200){
                    completionDict["success"] = true
                }
                else{
                    var errorMessage = self.genericFailMessage
                    
                    let errorsDict = dict["errors"]  as? NSDictionary
                    if let valuesString = errorsDict?.allValues as? [String] {
                        errorMessage = valuesString[0]
                    }
                    
                    completionDict["success"] = false
                    completionDict["message"] = errorMessage
                }
                
                completionHandler(completionDict)
                break
                
            case .failure( _):
                
                completionDict["success"] = false
                completionDict["message"] = self.genericFailMessage
                completionHandler(completionDict)
            }
            
        }
        
    }
    
    func uploadImage(image: UIImage, completionHandler:@escaping (_ result: NSMutableDictionary) -> Void){
        
        let completionDict: NSMutableDictionary = [:]
        
        let imageData = image.resizedTo(mb: 4)!.jpegData(compressionQuality: 1)
        
        let headers: HTTPHeaders = [ "X-Authorization-Firebase": appUser().firebaseToken]
        //,"Content-Type":"application/x-www-form-urlencoded"]
        
        RequestHelper.Manager.upload(multipartFormData: { multipartFormData in
            
            //                multipartFormData.append(image.pngData()!, withName: "file", fileName: "file.png", mimeType: "image/jpg")
            multipartFormData.append(imageData!, withName: "file", fileName: "file.jpeg", mimeType: "image/jpeg")
            multipartFormData.append("image".data(using: .utf8)!, withName: "tag")
            multipartFormData.append("true".data(using: .utf8)!, withName: "unique")
            
        }, usingThreshold:UInt64.init(), to: uploadImageURL, method:.post, headers:headers, encodingCompletion: { encodingResult in
            
            switch encodingResult {
                
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    let statusCode = response.response?.statusCode
                    let dict = response.result.value as! NSDictionary
                    
                    if(statusCode == 200){
                        
                        completionDict["success"] = true
                        
                        let id = dict["id"] as! Int
                        completionDict["id"] = id
                    }
                    else{
                        var errorMessage = self.genericFailMessage
                        
                        let errorsDict = dict["errors"]  as? NSDictionary
                        if let valuesString = errorsDict?.allValues as? [String] {
                            errorMessage = valuesString[0]
                        }
                        
                        completionDict["success"] = false
                        completionDict["message"] = errorMessage
                    }
                    
                    completionHandler(completionDict)
                    
                }
                break
                
            case .failure(_ ):
                completionDict["success"] = false
                completionDict["message"] = self.genericFailMessage
                completionHandler(completionDict)
            }
        })
        
    }
    
    
    func getLast5MealPlans( completionHandler:@escaping (_ result: NSMutableDictionary) -> Void){
        
        let completionDict: NSMutableDictionary = [:]
        
        let headers = ["X-Authorization-Firebase": appUser().firebaseToken]
        
        RequestHelper.Manager.request(getLast5MealPlansURL + "/" + String(appChild().id), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                let statusCode = response.response?.statusCode
                
                if(statusCode == 200){
                    completionDict["success"] = true
                    let mealsDataArray = response.result.value as! NSArray
                    
                    var weekPlansArray = [DailyPlan]()
                    
                    for (i,_) in mealsDataArray.enumerated() {
                        let dayMealsDict = mealsDataArray[i] as! NSDictionary
                        
                        let dailyPlan = DailyPlan()
                        
                        dailyPlan.id = dayMealsDict["id"] as! Int
                        dailyPlan.date = (dayMealsDict["date"] as! String).components(separatedBy: "+")[0].toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSS")!
                        
                        if(Calendar.current.isDateInToday(dailyPlan.date)){
                            dailyPlan.title = "Today"
                        }
                        else if (Calendar.current.isDateInTomorrow(dailyPlan.date)){
                            dailyPlan.title = "Tomorrow"
                        }
                            
                        else{
                            dailyPlan.title = dailyPlan.date.toString(withFormat: "EEE MMM dd")
                        }
                        
                        weekPlansArray.append(dailyPlan)
                        
                    }
                    
                    completionDict["MealPlansArray"] = weekPlansArray
                    
                    
                }
                else{
                    let dict = response.result.value as! NSDictionary
                    
                    var errorMessage = self.genericFailMessage
                    
                    let errorsDict = dict["errors"]  as? NSDictionary
                    if let valuesString = errorsDict?.allValues as? [String] {
                        errorMessage = valuesString[0]
                    }
                    
                    completionDict["success"] = false
                    completionDict["message"] = errorMessage
                }
                
                completionHandler(completionDict)
                break
                
            case .failure( _):
                
                completionDict["success"] = false
                completionDict["message"] = self.genericFailMessage
                completionHandler(completionDict)
            }
            
        }
        
    }
    
    func addPreviousMeal(mealPlanId: Int, recipeId: Int, completionHandler:@escaping (_ result: NSMutableDictionary) -> Void){
        
        let completionDict: NSMutableDictionary = [:]
        
        let headers = ["X-Authorization-Firebase": appUser().firebaseToken]
        
        var params = [:] as [String : Any]
        params["mealPlan"] = ["id": mealPlanId]
        params["recipe"] = ["id": recipeId]
        
        RequestHelper.Manager.request(addPreviousMealURL , method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                let statusCode = response.response?.statusCode
                let dict = response.result.value as! NSDictionary
                
                if(statusCode == 200){
                    completionDict["success"] = true
                }
                else{
                    var errorMessage = self.genericFailMessage
                    
                    let errorsDict = dict["errors"]  as? NSDictionary
                    if let valuesString = errorsDict?.allValues as? [String] {
                        errorMessage = valuesString[0]
                    }
                    
                    completionDict["success"] = false
                    completionDict["message"] = errorMessage
                }
                
                completionHandler(completionDict)
                break
                
            case .failure( _):
                
                completionDict["success"] = false
                completionDict["message"] = self.genericFailMessage
                completionHandler(completionDict)
            }
            
        }
        
    }
    
    func addChildGrowthInfo(params: [String : Any], completionHandler:@escaping (_ result: NSMutableDictionary) -> Void){
        
        let completionDict: NSMutableDictionary = [:]
        
        let headers = ["X-Authorization-Firebase": appUser().firebaseToken]
        
        RequestHelper.Manager.request(addChildGrowthInfoURL , method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                let statusCode = response.response?.statusCode
                let dict = response.result.value as! NSDictionary
                
                if(statusCode == 200){
                    completionDict["success"] = true
                }
                else{
                    var errorMessage = self.genericFailMessage
                    
                    let errorsDict = dict["errors"]  as? NSDictionary
                    if let valuesString = errorsDict?.allValues as? [String] {
                        errorMessage = valuesString[0]
                    }
                    
                    completionDict["success"] = false
                    completionDict["message"] = errorMessage
                }
                
                completionHandler(completionDict)
                break
                
            case .failure( _):
                
                completionDict["success"] = false
                completionDict["message"] = self.genericFailMessage
                completionHandler(completionDict)
            }
            
        }
        
    }
    
    func getSubscriptionInfo(completionHandler:@escaping (_ result: NSMutableDictionary) -> Void){
        
        let completionDict: NSMutableDictionary = [:]
        
        let headers = ["X-Authorization-Firebase": appUser().firebaseToken]
        
        var params = [:] as [String : Any]
        
        if(Utilities.sharedInstance.receiptExists()){
            //params["data"]
            let receiptData = Utilities.sharedInstance.getReceipt()
            //            let receiptString = receiptData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            let base64encodedReceipt = receiptData.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithCarriageReturn)
            params["data"] = base64encodedReceipt
        }
        
        RequestHelper.Manager.request(subscriptionInfoURL , method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                let statusCode = response.response?.statusCode
                let dict = response.result.value as! NSDictionary
                
                if(statusCode == 200){
                    completionDict["success"] = true
                    completionDict["isSubscribed"] = dict["validSubscription"] as? Bool
                    completionDict["usedTrial"] = dict["breviouslySubscriped"] as? Bool
                }
                else{
                    var errorMessage = self.genericFailMessage
                    
                    let errorsDict = dict["errors"]  as? NSDictionary
                    if let valuesString = errorsDict?.allValues as? [String] {
                        errorMessage = valuesString[0]
                    }
                    
                    completionDict["success"] = false
                    completionDict["message"] = errorMessage
                }
                
                completionHandler(completionDict)
                break
                
            case .failure( _):
                
                completionDict["success"] = false
                completionDict["message"] = self.genericFailMessage
                completionHandler(completionDict)
            }
            
        }
        
        
        
    }
    
    func searchRecipes2(page: Int, size: Int, completionHandler:@escaping (_ result: NSMutableDictionary) -> Void){

        let completionDict: NSMutableDictionary = [:]

        let headers = ["X-Authorization-Firebase": appUser().firebaseToken]

        var urlString = searchRecipes2URL + "?childId=" + String(appChild().id)
        urlString = urlString + "&size=" + String(size)
        urlString = urlString + "&page=" + String(page)
        
        if(UserDefaults.standard.bool(forKey: filtersVegeterianKey)){
            urlString = urlString + "&vegetarian=true"
        }
        
        if(UserDefaults.standard.bool(forKey: filtersVeganKey)){
            urlString = urlString + "&vegan=true"
        }
        
        if(UserDefaults.standard.bool(forKey: filtersPorkFreeKey)){
            urlString = urlString + "&porkFree=true"
        }
        
        if(UserDefaults.standard.bool(forKey: filtersQuickRecipesKey)){
            urlString = urlString + "&quick=true"
        }
        
        var coursesQueryParam = ""
        
        if(UserDefaults.standard.bool(forKey: filtersBreakfastKey)){
            coursesQueryParam = coursesQueryParam + ",breakfast"
        }
        
        if(UserDefaults.standard.bool(forKey: filtersLunchKey)){
            coursesQueryParam = coursesQueryParam + ",lunch_main_course"
        }
        
        if(UserDefaults.standard.bool(forKey: filtersDinnerKey)){
            coursesQueryParam = coursesQueryParam + ",dinner_main_course"
        }
        
        if(UserDefaults.standard.bool(forKey: filtersSnackKey)){
            coursesQueryParam = coursesQueryParam + ",snacks"
        }
        
        if(coursesQueryParam != ""){
            coursesQueryParam.remove(at: coursesQueryParam.startIndex)
            urlString = urlString + "&courses=" + coursesQueryParam
        }

        RequestHelper.Manager.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in

            switch response.result {

            case .success:

                let statusCode = response.response?.statusCode
                let dict = response.result.value as! NSDictionary

                if(statusCode == 200){
                    let responesDict = response.result.value as! NSDictionary
                    let mealDicts = responesDict["content"] as! NSArray
                    
                    var mealsArray = [Meal]()
                    for (i,_) in mealDicts.enumerated(){
                        
                        let mainDict = mealDicts[i] as! NSDictionary
                        //                        let recipeDict = mainDict["recipe"] as! NSDictionary
                        let meal = Meal()
                        meal.recipe = Utilities.sharedInstance.parseRecipe(dict: mainDict)
                        
                        if let isFavourite = mainDict["isFavorite"] as? Bool{
                            meal.isFavorite = isFavourite
                        }
                        
                        if let childReactionDict = mainDict["childReaction"] as? NSDictionary {
                            if let mealReaction = childReactionDict["reaction"] as? String {
                                meal.reaction = mealReaction
                            }
                        }
                        
//                        let meal = Utilities.sharedInstance.parseMeal(dict: mainDict)
                        mealsArray.append(meal)
                    }
                    
                    completionDict["meals"] = mealsArray
                    completionDict["totalPages"] = dict["totalPages"] as! Int
                    completionDict["number"] = dict["number"] as! Int
                    completionDict["success"] = true
                }
                else{
                    var errorMessage = self.genericFailMessage

                    let errorsDict = dict["errors"]  as? NSDictionary
                    if let valuesString = errorsDict?.allValues as? [String] {
                        errorMessage = valuesString[0]
                    }

                    completionDict["success"] = false
                    completionDict["message"] = errorMessage
                }

                completionHandler(completionDict)
                break

            case .failure( _):

                completionDict["success"] = false
                completionDict["message"] = self.genericFailMessage
                completionHandler(completionDict)
            }

        }

    }
    
}
