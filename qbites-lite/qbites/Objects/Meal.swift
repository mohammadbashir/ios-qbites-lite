//
//  Meal.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 11/26/19.
//  Copyright © 2019 Mohammad Bashir sidani. All rights reserved.
//

import Foundation

class Meal: NSObject {
    
    var id = -1
    var reaction = "" //[ LIKE, DISLIKE, LOVE, HATE, DO_NOT_INCLUDE ]
    var isFavorite = false
    var status = ""
    var recipe = Recipe()
    
    var totalRank = -1
    
    var weekOrder = 0
    var previousWeekOrder = 0
    
}
