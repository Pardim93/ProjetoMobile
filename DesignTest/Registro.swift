//
//  Registro.swift
//  
//
//  Created by Andre Lucas Ota on 14/09/15.
//
//

import Foundation
import CoreData

class Registro: NSManagedObject {

    @NSManaged var data: NSDate
    @NSManaged var nome: String
    @NSManaged var questoes: NSSet

}
