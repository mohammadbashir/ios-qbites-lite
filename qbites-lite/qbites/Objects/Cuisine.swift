//
//  Cuisine.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 11/1/19.
//  Copyright © 2019 Mohammad Bashir sidani. All rights reserved.
//

import Foundation


class Cuisine: NSObject, NSCoding {
    
    var id = -1
    var name = ""
    var imageURL = ""
    var reaction = "" //[ LIKE, DISLIKE, LOVE, HATE, DO_NOT_INCLUDE ]
    
    override init(){
        super.init()
    }
    
    init(id: Int, name: String, imageURL: String, reaction: String) {
        
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.reaction = reaction

    }

    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeInteger(forKey: "id")
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let imageURL = aDecoder.decodeObject(forKey: "imageURL") as! String
        let reaction = aDecoder.decodeObject(forKey: "reaction") as! String
        
        self.init(id: id, name: name, imageURL: imageURL, reaction: reaction)
    }

    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(imageURL, forKey: "imageURL")
        aCoder.encode(reaction, forKey: "reaction")
        
    }
    
}
