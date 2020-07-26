//
//  ChildObject.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 11/10/19.
//  Copyright © 2019 Mohammad Bashir sidani. All rights reserved.
//

import Foundation

class Child: NSObject, NSCoding {
    
    var id = -1
    var familyId = -1
    var name = ""
    var gender = "" //[ MALE, FEMALE ]
    var birthDate = Date()
    var weight = 0
    var weightPlaceholder = ""
    var height = 0
    var heightPlaceholder = ""
    var infantFeeding = "" //[ BREAST_FEEDING, FORMULA_FEEDING, COMBINATION, DONE ]
    
    var numberOfFeedings = 0
    var sizeOfFeedingsMin = 0
    var sizeOfFeedingsMax = 0
    
    var numberOfBreastFeedings = 0
    var sizeOfBreastFeedingsMin = 0
    var sizeOfBreastFeedingsMax = 0
    
    var numberOfFormulaFeedings = 0
    var sizeOfFormulaFeedingsMin = 0
    var sizeOfFormulaFeedingsMax = 0
    
    var isAllergicToAlcohol = false
    var isAllergicToEggs = false
    var isAllergicToFish = false
    var isAllergicToMilk = false
    var isAllergicToMilkCMP = false
    var isAllergicToPeanuts = false
    var isAllergicToPork = false
    var isAllergicToShellfish = false
    var isAllergicToSoy = false
    var isAllergicToTreenuts = false
    var isAllergicToWheat = false
    
    var isIntroducedToSolidFoods = false
    
    var didCuisinePrefs = false
    
    override init(){
        super.init()
    }
    

    init(id: Int, familyId: Int, name: String, gender:String, birthDate: Date, weight: Int, weightPlaceholder: String, height: Int, heightPlaceholder: String,  infantFeeding: String, numberOfFeedings: Int, sizeOfFeedingsMin: Int, sizeOfFeedingsMax: Int, numberOfBreastFeedings: Int, sizeOfBreastFeedingsMin: Int, sizeOfBreastFeedingsMax: Int, numberOfFormulaFeedings: Int, sizeOfFormulaFeedingsMin: Int, sizeOfFormulaFeedingsMax: Int,  isAllergicToAlcohol: Bool, isAllergicToEggs: Bool, isAllergicToFish: Bool, isAllergicToMilk: Bool, isAllergicToMilkCMP: Bool, isAllergicToPeanuts: Bool, isAllergicToPork: Bool, isAllergicToShellfish: Bool, isAllergicToSoy: Bool, isAllergicToTreenuts: Bool, isAllergicToWheat: Bool, isIntroducedToSolidFoods: Bool, didCuisinePrefs: Bool) {
        
        self.id = id
        self.familyId = familyId
        self.name = name
        self.gender = gender
        self.birthDate = birthDate
        self.weight = weight
        self.weightPlaceholder = weightPlaceholder
        self.height = height
        self.heightPlaceholder = heightPlaceholder
        
        self.infantFeeding = infantFeeding
        
        self.numberOfFeedings = numberOfFeedings
        self.sizeOfFeedingsMin = sizeOfFeedingsMin
        self.sizeOfFeedingsMax = sizeOfFeedingsMax
        
        self.numberOfBreastFeedings = numberOfBreastFeedings
        self.sizeOfBreastFeedingsMin = sizeOfBreastFeedingsMin
        self.sizeOfBreastFeedingsMax = sizeOfBreastFeedingsMax
        
        self.numberOfFormulaFeedings = numberOfFormulaFeedings
        self.sizeOfFormulaFeedingsMin = sizeOfFormulaFeedingsMin
        self.sizeOfFormulaFeedingsMax = sizeOfFormulaFeedingsMax
        
        self.isAllergicToAlcohol = isAllergicToAlcohol
        self.isAllergicToEggs = isAllergicToEggs
        self.isAllergicToFish = isAllergicToFish
        self.isAllergicToMilk = isAllergicToMilk
        self.isAllergicToMilkCMP = isAllergicToMilkCMP
        self.isAllergicToPeanuts = isAllergicToPeanuts
        self.isAllergicToPork = isAllergicToPork
        self.isAllergicToShellfish = isAllergicToShellfish
        self.isAllergicToSoy = isAllergicToSoy
        self.isAllergicToTreenuts = isAllergicToTreenuts
        self.isAllergicToWheat = isAllergicToWheat
        
        self.isIntroducedToSolidFoods = isIntroducedToSolidFoods
        self.didCuisinePrefs = didCuisinePrefs

    }

    required convenience init(coder aDecoder: NSCoder) {
        
        let id = aDecoder.decodeInteger(forKey: "id")
        let familyId = aDecoder.decodeInteger(forKey: "familyId")
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let gender = aDecoder.decodeObject(forKey: "gender") as! String
        let birthDate = aDecoder.decodeObject(forKey: "birthDate") as! Date
        
        let weight = aDecoder.decodeInteger(forKey: "weight")
        let weightPlaceholder = aDecoder.decodeObject(forKey: "weightPlaceholder") as! String
        let height = aDecoder.decodeInteger(forKey: "height")
        let heightPlaceholder = aDecoder.decodeObject(forKey: "heightPlaceholder") as! String
        
        let infantFeeding = aDecoder.decodeObject(forKey: "infantFeeding") as! String
        
        let numberOfFeedings = aDecoder.decodeInteger(forKey: "numberOfFeedings")
        let sizeOfFeedingsMin = aDecoder.decodeInteger(forKey: "sizeOfFeedingsMin")
        let sizeOfFeedingsMax = aDecoder.decodeInteger(forKey: "sizeOfFeedingsMax")
        
        let numberOfBreastFeedings = aDecoder.decodeInteger(forKey: "numberOfBreastFeedings")
        let sizeOfBreastFeedingsMin = aDecoder.decodeInteger(forKey: "sizeOfBreastFeedingsMin")
        let sizeOfBreastFeedingsMax = aDecoder.decodeInteger(forKey: "sizeOfBreastFeedingsMax")
        
        let numberOfFormulaFeedings = aDecoder.decodeInteger(forKey: "numberOfFormulaFeedings")
        let sizeOfFormulaFeedingsMin = aDecoder.decodeInteger(forKey: "sizeOfFormulaFeedingsMin")
        let sizeOfFormulaFeedingsMax = aDecoder.decodeInteger(forKey: "sizeOfFormulaFeedingsMax")
        
        let isAllergicToAlcohol = aDecoder.decodeBool(forKey: "isAllergicToAlcohol")
        let isAllergicToEggs = aDecoder.decodeBool(forKey: "isAllergicToEggs")
        let isAllergicToFish = aDecoder.decodeBool(forKey: "isAllergicToFish")
        let isAllergicToMilk = aDecoder.decodeBool(forKey: "isAllergicToMilk")
        let isAllergicToMilkCMP = aDecoder.decodeBool(forKey: "isAllergicToMilkCMP")
        let isAllergicToPeanuts = aDecoder.decodeBool(forKey: "isAllergicToPeanuts")
        let isAllergicToPork = aDecoder.decodeBool(forKey: "isAllergicToPork")
        let isAllergicToShellfish = aDecoder.decodeBool(forKey: "isAllergicToShellfish")
        let isAllergicToSoy = aDecoder.decodeBool(forKey: "isAllergicToSoy")
        let isAllergicToTreenuts = aDecoder.decodeBool(forKey: "isAllergicToTreenuts")
        let isAllergicToWheat = aDecoder.decodeBool(forKey: "isAllergicToWheat")
        
        let isIntroducedToSolidFoods = aDecoder.decodeBool(forKey: "isIntroducedToSolidFoods")
        let didCuisinePrefs = aDecoder.decodeBool(forKey: "didCuisinePrefs")

        self.init(id: id, familyId: familyId, name: name, gender:gender, birthDate: birthDate, weight: weight, weightPlaceholder: weightPlaceholder, height: height, heightPlaceholder: heightPlaceholder,  infantFeeding: infantFeeding, numberOfFeedings: numberOfFeedings, sizeOfFeedingsMin: sizeOfFeedingsMin, sizeOfFeedingsMax: sizeOfFeedingsMax, numberOfBreastFeedings: numberOfBreastFeedings, sizeOfBreastFeedingsMin: sizeOfBreastFeedingsMin, sizeOfBreastFeedingsMax: sizeOfBreastFeedingsMax, numberOfFormulaFeedings: numberOfFormulaFeedings, sizeOfFormulaFeedingsMin: sizeOfFormulaFeedingsMin, sizeOfFormulaFeedingsMax: sizeOfFormulaFeedingsMax, isAllergicToAlcohol: isAllergicToAlcohol, isAllergicToEggs: isAllergicToEggs, isAllergicToFish: isAllergicToFish, isAllergicToMilk: isAllergicToMilk, isAllergicToMilkCMP:isAllergicToMilkCMP, isAllergicToPeanuts: isAllergicToPeanuts, isAllergicToPork: isAllergicToPork, isAllergicToShellfish: isAllergicToShellfish, isAllergicToSoy: isAllergicToSoy, isAllergicToTreenuts: isAllergicToTreenuts, isAllergicToWheat: isAllergicToWheat, isIntroducedToSolidFoods: isIntroducedToSolidFoods, didCuisinePrefs: didCuisinePrefs)
    }

    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(id, forKey: "id")
        aCoder.encode(familyId, forKey: "familyId")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(gender, forKey: "gender")
        aCoder.encode(birthDate, forKey: "birthDate")
        
        aCoder.encode(weight, forKey: "weight")
        aCoder.encode(weightPlaceholder, forKey: "weightPlaceholder")
        aCoder.encode(height, forKey: "height")
        aCoder.encode(heightPlaceholder, forKey: "heightPlaceholder")
        
        aCoder.encode(infantFeeding, forKey: "infantFeeding")
        
        aCoder.encode(numberOfFeedings, forKey: "numberOfFeedings")
        aCoder.encode(sizeOfFeedingsMin, forKey: "sizeOfFeedingsMin")
        aCoder.encode(sizeOfFeedingsMax, forKey: "sizeOfFeedingsMax")
        
        aCoder.encode(numberOfBreastFeedings, forKey: "numberOfBreastFeedings")
        aCoder.encode(sizeOfBreastFeedingsMin, forKey: "sizeOfBreastFeedingsMin")
        aCoder.encode(sizeOfBreastFeedingsMax, forKey: "sizeOfBreastFeedingsMax")
        
        aCoder.encode(numberOfFormulaFeedings, forKey: "numberOfFormulaFeedings")
        aCoder.encode(sizeOfFormulaFeedingsMin, forKey: "sizeOfFormulaFeedingsMin")
        aCoder.encode(sizeOfFormulaFeedingsMax, forKey: "sizeOfFormulaFeedingsMax")
        
        aCoder.encode(isAllergicToAlcohol, forKey: "isAllergicToAlcohol")
        aCoder.encode(isAllergicToEggs, forKey: "isAllergicToEggs")
        aCoder.encode(isAllergicToFish, forKey: "isAllergicToFish")
        aCoder.encode(isAllergicToMilk, forKey: "isAllergicToMilk")
        aCoder.encode(isAllergicToMilkCMP, forKey: "isAllergicToMilkCMP")
        aCoder.encode(isAllergicToPeanuts, forKey: "isAllergicToPeanuts")
        aCoder.encode(isAllergicToPork, forKey: "isAllergicToPork")
        aCoder.encode(isAllergicToShellfish, forKey: "isAllergicToShellfish")
        aCoder.encode(isAllergicToSoy, forKey: "isAllergicToSoy")
        aCoder.encode(isAllergicToTreenuts, forKey: "isAllergicToTreenuts")
        aCoder.encode(isAllergicToWheat, forKey: "isAllergicToWheat")

        aCoder.encode(isIntroducedToSolidFoods, forKey: "isIntroducedToSolidFoods")
        aCoder.encode(didCuisinePrefs, forKey: "didCuisinePrefs")
        
    }

}
