//
//  ToDoModel.swift
//  Easy To Do
//
//  Created by Umberto Mauro on 12/07/17.
//  Copyright © 2017 Umberto Mauro. All rights reserved.
//

import UIKit

class ToDoModel: NSObject, NSCoding {
    
    var nome : String
    var fatto : Bool = false
    
    init(nome: String) {
        self.nome = nome
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        self.nome = aDecoder.decodeObject(forKey: "nome") as! String
        self.fatto = aDecoder.decodeBool(forKey: "fatto")
    }
    
    func encode(with encoder: NSCoder) {
        encoder.encode(self.nome, forKey: "nome")
        encoder.encode(self.fatto, forKey: "fatto")
    }
    
    
}
