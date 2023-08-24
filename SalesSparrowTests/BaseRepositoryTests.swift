//
//  BaseRepositoryTests.swift
//  SalesSparrowTests
//
//  Created by Mohit Charkha on 31/07/23.
//

import XCTest
import CoreData
@testable import SalesSparrow

class BaseRepositoryTests: XCTestCase {
    // Define a test context for CoreData
     private lazy var testPersistentContainer: NSPersistentContainer = {
         let container = NSPersistentContainer(name: "SalesSparrow")
         let description = NSPersistentStoreDescription()
         description.type = NSInMemoryStoreType
         container.persistentStoreDescriptions = [description]
         container.loadPersistentStores(completionHandler: { (storeDescription, error) in
             if let error = error as NSError? {
                 fatalError("Unresolved error \(error), \(error.userInfo)")
             }
         })
         return container
     }()
    
    // Initialize the TasksRepository using the test context
    private lazy var taskRepository: TasksRepository = {
        let repository = TasksRepository()
         repository.context = testPersistentContainer.viewContext
        return repository
    }()
    
    // Sample entity data for testing
    private let sampleEntityData: [String: Any] = [
        "id": "123",
        "uts": "32913123",
        "status": "active",
    ]
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInsertOrUpdate() throws {
        taskRepository.insertOrUpdate(sampleEntityData)
        
        do{
            // Fetch the entity from the CoreData context
            let fetchedEntity = try XCTUnwrap(taskRepository.getById("123"))
            
            // Validate if the entity is correctly inserted
            XCTAssertEqual(fetchedEntity.status, sampleEntityData["status"] as? String)
        }
        catch{
            print("failed to fetch data")
        }
    }
    
    func testGetById() throws {
        taskRepository.insertOrUpdate(sampleEntityData)
        
        // Fetch the entity from the CoreData context using the getById method
        let fetchedEntity = try XCTUnwrap(taskRepository.getById("123"))
        
        // Validate if the entity is correctly fetched
        XCTAssertEqual(fetchedEntity.uts, sampleEntityData["uts"] as? String)
    }
    
    func testDeleteById() throws {
        taskRepository.insertOrUpdate(sampleEntityData)
        
        // Delete the entity using deleteById method
        taskRepository.deleteById("123") { success in
            self.checkDeleteById(deleteResult: success)
        }
        
        // Validate if the entity is deleted successfully
        
    }
    
    private func checkDeleteById(deleteResult: Bool?) {
        XCTAssertEqual(deleteResult, true)
        XCTAssertNil(try taskRepository.getById("123"))
    }
    
    // MARK: Helper methods for testing

    private func saveContext() {
        do {
            try testPersistentContainer.viewContext.save()
        } catch {
            fatalError("Failed to save test context: \(error)")
        }
    }
}
