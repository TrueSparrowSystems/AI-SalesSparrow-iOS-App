//
//  Tasks+CoreDataProperties.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 31/07/23.
//

import Foundation
import CoreData

/**
 An extension of the `Tasks` Core Data entity that provides computed properties for attributes of the entity.
 */
extension Tasks {
    var status: String?{
        return BasicHelper.toString(data["status"])
    }
}
