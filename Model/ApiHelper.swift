//
//  ApiHelper.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 31/07/23.
//

import Foundation

/// A class that provides methods for storing entities in the database from API responses.
class ApiHelper {
    // Map of single entity keys to store function
    static let singleEntityKeysToStoreFunctionMap = ["current_user": Tasks.storeEntity];
    
    // Map of entity keys to store function
    static let entityKeysKeysToStoreFunctionMap = [
        "task_map_by_id": Tasks.storeEntity,
    ];

    // Function to store entities in the database from a map
    static func storeEntitiesFromMap(key: String, entityMap: [String: Any]) {
        print("Count: \(key) ", entityMap.keys.count)
        entityMap.keys.forEach { id in
            let entity = entityMap[id] as! [String : Any]
            let entityStoreFunc = entityKeysKeysToStoreFunctionMap[key]
            entityStoreFunc?(entity)
        }
    }
    
    // Function to store single entity in the database
    static func storeSingleEntity(key: String, entity: [String: Any]) {
        let entityStoreFunc = singleEntityKeysToStoreFunctionMap[key]
        entityStoreFunc?(entity)
    }
    
    // Function to store entities in the database
    static func syncEntities(_ responseData: [String: Any]) {
        let keys = responseData.keys

        keys.forEach { key in
            print("I am here...\(key)")
            
            let entityMap = responseData[key]
            if(!(entityMap is NSNull)) {
                // Check if the key is in the map of entities to store
                if entityKeysKeysToStoreFunctionMap.keys.contains(key) {
                    storeEntitiesFromMap(key: key, entityMap: entityMap as! [String : Any])
                }
                // Check if the key is in the map of single entities to store
                else if singleEntityKeysToStoreFunctionMap.keys.contains(key) {
                    storeSingleEntity(key: key, entity: entityMap as! [String: Any])
                }
            }
        }
        
        
    }
}
