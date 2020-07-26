//
//  Recepie.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 1/20/20.
//  Copyright © 2020 Mohammad Bashir sidani. All rights reserved.
//

import Foundation

class Recipe: NSObject {
    
    var id = -1
    
    var name = ""
    var type = ""
    var imageURLsArray = [String]()
//    var reaction = "" //[ LIKE, DISLIKE, LOVE, HATE, DO_NOT_INCLUDE ]
//    var isFavorite = false
    var ratingMedal = ""
    
    var activeTimeDisplay = ""
    var preparationTimeDisplay = ""
    
    var kcal = 0
    var kcalPerServing = 0
    
    var qcal = 0
    var qcalPerServing = 0
    
    var qcalToKCalRatio = 0
    
    var numberServings = 0

    var mealDescription = ""
    var ingredients = [Ingredient]()
    var instructions = ""
    
    var publisher = ""
    
    var qcalToKCalRatioPct = 0 as Double
    
    var keywords = [String]()
    
    var sourceUrl = ""
    var sourceImageUrl = ""
    
    override init(){
        super.init()
    }
    
}
