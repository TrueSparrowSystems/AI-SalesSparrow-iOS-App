//
//  Tasks+CoreDataClass.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 31/07/23.
//

import Foundation
import CoreData

/**
 A Core Data class that represents `Tasks` entity.
 */
@objc(Tasks)
public class Tasks: BaseEntity {
    
    // Fetch the attributes of the entity
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tasks> {
        return NSFetchRequest<Tasks>(entityName: "Tasks")
    }
    
    // Set the attributes of the entity
    static func storeEntity(_ entityData: [String: Any]) {
        return TasksRepository
            .shared
            .insertOrUpdate(entityData)
    }
}
