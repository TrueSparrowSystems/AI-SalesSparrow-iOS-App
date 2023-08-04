//
//  BaseEntity.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 31/07/23.
//

import CoreData

/**
 A base class for Core Data entities that provides properties for the ID, UTS, and entity data of the entity.
 */
public class BaseEntity: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var uts: String?
    @NSManaged var entityData: Data
    
     /**
     A computed property that returns the entity data as a dictionary.
     */
    var data: [String: Any] {
        do{
            let data = try JSONSerialization.jsonObject(with: entityData) as! [String : Any]
            return data
        }
        catch{}
        return [:]
    }
}
