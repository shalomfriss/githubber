//
//  CoreDataStack.swift
//  CoreDataExamples
//
//  Created by user on 6/22/18.
//  Copyright © 2018 Shalom Friss. All rights reserved.
//

import Foundation
import CoreData
import SQLite3


///  CoreDataStack is an abstraction to core data allowing for easier use
class CoreDataManager:NSObject {
    
    private var _defaultName = "CoreDataExamples"
    private var _moduleName:String = ""
    
    lazy var applicationDocumentDirectory:URL =  {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }()
    
    //The NSManagedObjectModel
    private lazy var managedObjectModel: NSManagedObjectModel = NSManagedObjectModel()
    
    //The NSPersistentStoreCoordinator
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator()
    
    //The NSManagedObjectContext parent and child, used for optimally saving data
    private lazy var parentContext:NSManagedObjectContext = NSManagedObjectContext(coder: NSCoder())!
    private lazy var _context:NSManagedObjectContext = NSManagedObjectContext(coder: NSCoder())!
    public var context:NSManagedObjectContext {
        get {
            return _context
        }
    }
    
    
    //MARK: - SETUP & INIT
    override convenience init() {
        self.init()
    }
    
    
    
    /// Initialize the CoreDataStack
    ///
    /// - Parameter moduleName: the module name, this should be the name of the momd file without the momd extension
    init(_ moduleName:String) {
        super.init()
        
        //Use passed in name or default names
        self._moduleName            = moduleName
        
        //Set up the NSManagedObjectModel
        guard let modelURL = Bundle.main.url(forResource: self._moduleName, withExtension: "momd") else {
            fatalError("Could not find momd file")
        }
        self.managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)!
        
        //Set up the NSPersistentStoreCoordinator
        self.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let persistentStoreURL = self.applicationDocumentDirectory.appendingPathComponent("\(self._moduleName).sqlite")
        do {
            try self.persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistentStoreURL, options: [NSMigratePersistentStoresAutomaticallyOption:true, NSInferMappingModelAutomaticallyOption: true])
        }
        catch {
            fatalError("Persistent store error! \(error)")
        }
        
        //Set up the NSManagedObjectContext objects with a parent and a child
        self.parentContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.parentContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        self._context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self._context.parent = self.parentContext
        
    }
    
    //MARK: - API
    
    /// Save the data
    func save() {
        if _context.hasChanges || parentContext.hasChanges {
            _context.performAndWait(){
                do {
                    try self.context.save()
                } catch {
                    fatalError("Error saving main managed object context! \(error)")
                }
            }
            
            parentContext.perform {
                do {
                    try self.parentContext.save()
                } catch {
                    fatalError("Error saving private managed object context! \(error)")
                }
            }
        }
    }
    
    
    
    /// Fetch from CoreData using a fetch request
    ///
    /// - Parameter fetchRequest: fetchRequest:NSFetchRequest<NSFetchRequestResult> - The fetch request
    /// - Returns:
    func fetch(_ fetchRequest:NSFetchRequest<NSFetchRequestResult>) -> [Any]? {
        do {
            let result = try self.context.fetch(fetchRequest)
            return result
        } catch let error {
            print(error)
            return nil
        }
    }
    
    /**
     Fetch from an NSFetchedResultsController from CoreData using a fetch request
     @param _ fetchRequest:NSFetchRequest<NSFetchRequestResult> - The fetch request
     @return - NSFetchedResultsController
     */
    func fetchController(_ fetchRequest:NSFetchRequest<NSFetchRequestResult>, _ sectionBy:String? = nil, _ cacheBy:String? = nil) -> NSFetchedResultsController<NSFetchRequestResult>? {
        
        let sectionName = sectionBy
        let cacheName = cacheBy
        
        let fetchResultController:NSFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self._context, sectionNameKeyPath: sectionName, cacheName: cacheName)
        do {
            try fetchResultController.performFetch()
            return fetchResultController
        } catch let error {
            print(error)
            return nil
        }
    }
    
    
    /**
        Delete all entities
        @param - The entity type to delete
    */
    func deleteAll(entityName:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try _context.execute(batchDeleteRequest)
        } catch {
            print("ERROR: Could not delete \(entityName) objects")
        }
    }
    
    //MARK: - FUTURE
    
    
     /// Simple get request
     ///
     /// - Parameters:
     ///   - entityName: The entity name
     ///   - key: The key to fetch
     ///   - ascending: Ascending if true
     /// - Returns: [NSFetchRequest<NSFetchRequestResult>]?
     public func get(entityName: String, key:String, ascending:Bool = true) ->  [NSFetchRequest<NSFetchRequestResult>]?{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: key, ascending: ascending)
        ]
        do {
            let result = try self._context.fetch(fetchRequest)
            return result as? [NSFetchRequest<NSFetchRequestResult>]
        }
        catch let error {
            print(error)
            return nil
        }
     }
    
    
    /**
     Fetch data based on an array of keys and orderings
     @param entityName:String - the entity name
     @param keys:[String] - an array of keys
     public func gets(entityName: String, keys:[String], options:[String:Any]) ->  [NSFetchRequest<NSFetchRequestResult>]?{
     let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
     
     var descriptors:[NSSortDescriptor] = [NSSortDescriptor]()
     for i in 0..<keys.count {
     //NSSortDescriptor(key: keys[i], ascending: ascendings[i])
     }
     fetchRequest.sortDescriptors = [
     NSSortDescriptor(key: key, ascending: ascending)
     ]
     do {
     let result = try self._context.fetch(fetchRequest)
     return result as? [NSFetchRequest<NSFetchRequestResult>]
     }
     catch let error {
     print(error)
     return nil
     }
     
     return nil
     }
     */
    
    //MARK: - SQLite (Experimental)
    func openDatabase() -> OpaquePointer? {
        var db: OpaquePointer? = nil
        let persistentStoreURL = self.applicationDocumentDirectory.appendingPathComponent("\(self._moduleName).sqlite")
        if sqlite3_open(persistentStoreURL.absoluteString, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(persistentStoreURL)")
            return db
        } else {
            print("ERROR: Unable to open database at \(persistentStoreURL).")
            return nil
        }
    }
    
    
    func query(queryStatementString:String) {
        let db = self.openDatabase()
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                
                let queryResultCol1 = sqlite3_column_text(queryStatement, 4)
                let name = String(cString: queryResultCol1!)
                
                /*
 let place = Places()
 for i in place.entity.attributesByName {
 print("-------------")
 print(i)
 }
                */
                
                print("Query Result:")
                print("\(id) | \(name)")
                
            } else {
                print("Query returned no results")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        
        sqlite3_finalize(queryStatement)
    }

    
}
