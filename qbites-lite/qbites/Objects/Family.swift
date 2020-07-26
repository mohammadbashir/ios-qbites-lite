//
//  Family.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 11/10/19.
//  Copyright © 2019 Mohammad Bashir sidani. All rights reserved.
//

import Foundation

class Family: NSObject, NSCoding {

    var id = -1
    var parents = [Parent]()
    var childs = [Child]()
    
    override init(){
        super.init()
    }
    
    init(id: Int, parents: [Parent], childs: [Child]) {
        
        self.id = id
        self.parents = parents
        self.childs = childs

    }

    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeInteger(forKey: "id")
        let parents = aDecoder.decodeObject(forKey: "parents") as! [Parent]
        let childs = aDecoder.decodeObject(forKey: "childs") as! [Child]
        
        self.init(id: id, parents: parents, childs: childs)
    }

    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(id, forKey: "id")
        aCoder.encode(parents, forKey: "parents")
        aCoder.encode(childs, forKey: "childs")
        
    }

}
