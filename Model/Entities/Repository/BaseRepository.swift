//
//  BaseRepository.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 31/07/23.
//

import Foundation
import UIKit
import CoreData

let LOG_ENABLED:Bool = true

/**
 A base class for repository classes that provide methods for inserting, updating, and retrieving entities from a Core Data store. The class includes an in-memory cache to save entities while they are being inserted to the database, and methods for inserting or updating an entity, and retrieving an entity by ID.
 */
class BaseRepository {
    
    // The Core Data context for the repository
    var context = PersistenceController.shared.container.viewContext
    
    // In-Memory Cache to save entity while they are being inserted to db.
    private var inMemoryCache: [String: BaseEntity] = [:]
    
    /**
     Inserts or updates an entity in the Core Data store with the specified entity data.
     
     - Parameter entityData: The data for the entity to insert or update.
     */
    func insertOrUpdate(_ entityData: [String: Any]) {
        let id = BasicHelper.toString(entityData[getEntityIdentifier()]) ?? ""
        let uts: String? = entityData["uts"] as? String
        if LOG_ENABLED {
            print("Store: storing entity", id)
        }
        do {
            var updatedEntity = try self.getExistingEntity(entityData)
            if updatedEntity == nil {
                if LOG_ENABLED {
                    print("Store: creating new entity", id)
                }
                updatedEntity = self.createEntity()
            }
            updatedEntity?.id = id
            updatedEntity?.uts = uts
            updatedEntity?.entityData = try JSONSerialization.data(withJSONObject: entityData)
            self.saveEntity(updatedEntity!)
        }
        catch {
            print("Error inserting or updating entity: \(error)")
        }
    }
    
    /**
     Retrieves an entity from the Core Data store with the specified ID.
     
     - Parameter id: The ID of the entity to retrieve.
     
     - Returns: The entity with the specified ID, or nil if no entity was found.
     */
    func getById(_ id: String) throws -> BaseEntity? {
        if let entity = getEntityFromInMemory(forKey: id) {
            return entity
        }
        let request = NSFetchRequest<BaseEntity>(entityName: getEntityName())
        request.predicate = NSPredicate(format: "id = %@", id)
        let result = try context.fetch(request)
        return result.first;
    }
    
    /**
     Deletes an entity from the Core Data store with the specified ID.
     
     - Parameters
     - id: The ID of the entity to delete.
     - callback: The callback to call with the result of the delete operation.
     */
    func deleteById(_ id: String, callback: ((Bool) -> Void)?) {
        deleteEntityFromInMemory(forKey: id)
        context.perform {
            do {
                if let entity = try self.getById(id){
                    self.context.delete(entity)
                    try self.context.save()
                    callback?(true)
                }
            }
            catch {
                callback?(false)
            }
        }
    }
    
    // MARK: In-Memory Cache methods
    
    /**
     Retrieves an entity from the in-memory cache with the specified ID.
     
     - Parameter id: The ID of the entity to retrieve.
     
     - Returns: The entity with the specified ID, or nil if no entity was found.
     */
    func getEntityFromInMemory(forKey id: String) -> BaseEntity? {
        if let entity = inMemoryCache[id]{
            return entity
        }
        return nil
    }
    
    /**
     Saves an entity in the in-memory cache with the specified ID.
     
     - Parameters
     - key: The ID of the entity to save.
     - val: The entity to save.
     */
    func saveEntityInMemory(key: String, val: BaseEntity) {
        if LOG_ENABLED {
            print("Cache1: saving in memory", key)
        }
        inMemoryCache[key] = val
    }
    
    /**
     Deletes an entity from the in-memory cache with the specified ID.
     
     - Parameter key: The ID of the entity to delete.
     */
    func deleteEntityFromInMemory(forKey key: String) {
        if LOG_ENABLED {
            print("Cache1: deleteEntityFromMemory in memory", key)
        }
        inMemoryCache[key] = nil
    }
    
    // MARK: Helper methods
    /**
     Saves an entity in the Core Data store.
     
     - Parameter entity: The entity to save.
     */
    func saveEntity(_ entity: BaseEntity) {
        saveEntityInMemory(key: entity.id, val: entity)
        context.perform {
            do {
                try self.context.save()
                let previousUTS = BasicHelper.toString(entity.uts)
                let newUTS = BasicHelper.toString(self.getEntityFromInMemory(forKey: entity.id)?.uts)
                if previousUTS == newUTS {
                    self.deleteEntityFromInMemory(forKey: entity.id)
                }
            }
            catch {
                print("error in saving entity.", error)
            }
        }
    }
    
    /**
     Creates a new entity in the Core Data store.
     
     - Returns: The newly created entity.
     */
    func createEntity() -> BaseEntity {
        if LOG_ENABLED {
            print("Cache1: creating new entity")
        }
        let entityDesc = NSEntityDescription.entity(forEntityName: getEntityName(), in: context)!
        let entity = BaseEntity.init(entity: entityDesc, insertInto: context)
        return entity
    }
    
    /**
     Retrieves an existing entity from the Core Data store with the specified data.
     
     - Parameter data: The data of the entity to retrieve.
     
     - Returns: The entity with the specified data, or nil if no entity was found.
     */
    func getExistingEntity(_ data: [String : Any]) throws -> BaseEntity? {
        guard let id = BasicHelper.toString(data[getEntityIdentifier()]) else { return nil }
        let fetchRequest: NSFetchRequest<BaseEntity>  = NSFetchRequest<BaseEntity>.init(entityName: getEntityName())
        let predicate = NSPredicate.init(format: "id = %@", id)
        fetchRequest.predicate = predicate
        let result = try context.fetch(fetchRequest)
        let entity = result.first
        return entity
    }
    
    /**
     Retrieves the identifier of the entity.
     
     - Returns: The identifier of the entity.
     */
    func getEntityIdentifier() -> String {
        // The default implementation returns "id"
        return "id"
    }
    
    // MARK: Methods to be overriden
    func getEntityName() -> String {
        fatalError("getEntityName is not override")
    }
    
}
