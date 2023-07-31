//
//  TaskRepository.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 31/07/23.
//

import CoreData
import UIKit

/**
 A repository class that provides methods for inserting, updating, and retrieving `ImageEntity` entities from a Core Data store.
 */
class TasksRepository: BaseRepository {
    static let shared = TasksRepository()
    
    override func getEntityName() -> String {
        "Tasks"
    }
    
    override func getById(_ id: String) throws -> Tasks? {
        return try super.getById(id) as? Tasks
    }
    
    override func getEntityIdentifier() -> String {
        return "id"
    }
}
