//
//  Questao_registro.swift
//  
//
//  Created by Andre Lucas Ota on 14/09/15.
//
//

import Foundation
import CoreData

class Questao_registro: NSManagedObject {

    @NSManaged var id_parse: String
    @NSManaged var respondido: String
    @NSManaged var registro: NSManagedObject

}
