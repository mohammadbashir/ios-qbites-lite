//
//  Ingredient.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 12/6/19.
//  Copyright © 2019 Mohammad Bashir sidani. All rights reserved.
//

import Foundation

class Ingredient: NSObject {
    
    var name = ""
    var unit = ""
    var quantity = ""
    
    var displayIngredient = DisplayIngredient()
    
}

class DisplayIngredient: NSObject {
    var id = -1
    var ingredientID = -1
    var name = ""
}

