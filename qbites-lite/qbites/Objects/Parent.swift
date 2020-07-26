//
//  Parent.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 11/10/19.
//  Copyright © 2019 Mohammad Bashir sidani. All rights reserved.
//

import Foundation

class Parent: NSObject, NSCoding {
    
    var id = -1
    var name = ""
    var firstName = ""
    var lastName = ""
    var parentType = "" //[ MOTHER, FATHER ]
    
    var nationalityName = ""
    var nationality2DigitCode = ""
    
    var isUSMetrics = false
    var didCheckCuisines = false
    
    override init(){
        super.init()
    }
    
    init(id: Int, name: String, firstName: String, lastName: String, parentType: String, nationalityName:String, nationality2DigitCode: String, isUSMetrics: Bool, didCheckCuisines: Bool) {
        
        self.id = id
        self.name = name
        self.firstName = firstName
        self.lastName = lastName
        self.parentType = parentType
        self.nationalityName = nationalityName
        self.nationality2DigitCode = nationality2DigitCode
        self.isUSMetrics = isUSMetrics
        self.didCheckCuisines = didCheckCuisines

    }

    required convenience init(coder aDecoder: NSCoder) {
        
        let id = aDecoder.decodeInteger(forKey: "id")
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let firstName = aDecoder.decodeObject(forKey: "firstName") as! String
        let lastName = aDecoder.decodeObject(forKey: "lastName") as! String
        let parentType = aDecoder.decodeObject(forKey: "parentType") as! String
        let nationalityName = aDecoder.decodeObject(forKey: "nationalityName") as! String
        let nationality2DigitCode = aDecoder.decodeObject(forKey: "nationality2DigitCode") as! String
        let isUSMetrics = aDecoder.decodeBool(forKey: "isUSMetrics")
        let didCheckCuisines = aDecoder.decodeBool(forKey: "didCheckCuisines")
        
        self.init(id: id, name: name, firstName: firstName, lastName:lastName, parentType: parentType, nationalityName:nationalityName, nationality2DigitCode: nationality2DigitCode, isUSMetrics: isUSMetrics, didCheckCuisines: didCheckCuisines)
    }

    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(parentType, forKey: "parentType")
        aCoder.encode(nationalityName, forKey: "nationalityName")
        aCoder.encode(nationality2DigitCode, forKey: "nationality2DigitCode")
        aCoder.encode(isUSMetrics, forKey: "isUSMetrics")
        aCoder.encode(didCheckCuisines, forKey: "didCheckCuisines")
        
    }
}
