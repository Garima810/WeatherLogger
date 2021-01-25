//
//  CoreDataHelper.swift
//  WeatherBlogger
//
//  Created by Garima Ashish Bisht on 24/01/21.
//  Copyright © 2021 Garima Kushwah. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHelper: NSObject {

    static var instance:CoreDataHelper?
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return URL(fileURLWithPath: documentsPath)
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        //TODO: ADD DATABASE
        let modelURL = Bundle.main.url(forResource: "WeatherBlogger", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("Weather.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            let options = [ NSInferMappingModelAutomaticallyOption : true,
                            NSMigratePersistentStoresAutomaticallyOption : true]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
   class func sharedInstance() -> CoreDataHelper
    {
        if CoreDataHelper.instance == nil{
            
            CoreDataHelper.instance = CoreDataHelper()
        }
        return CoreDataHelper.instance!
    }

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
   func createEntityWithName(_ entityName:String ,uniqueKey primaryKey:String? ,value keyValue:String?) -> NSManagedObject
    {
        if let key = primaryKey ,let value = keyValue
        {
          let  predicate =  NSPredicate(format: "\(key) == %@", value)

          let arrayRecords =   CoreDataHelper.sharedInstance().getListOfEntityWithName(entityName, withPredicate:predicate , sortKey: nil, isAscending: true)
            if arrayRecords?.count ?? 0 > 0
            {
                return arrayRecords![0] as! NSManagedObject
            }
        }
        let entity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext)
        return entity
    }

    func getListOfEntityWithName(_ entityName:String, withPredicate predicate:NSPredicate?, sortKey key:String? , isAscending asc:Bool) -> [AnyObject]?
    {
        let  request:NSFetchRequest = self.getFetchRequest(entityName)
        
        if let strPredicate = predicate
        {
            request.predicate = strPredicate
        }
        
        
        if let sortKey = key
        {
            let sortDescriptor = NSSortDescriptor(key: sortKey, ascending: asc)
            request.sortDescriptors = [sortDescriptor]
            
        }
        
        var result:[AnyObject]?
        
        do
        {
            try result = managedObjectContext.fetch(request)
            
            
        }catch
        {
            NSLog("Error occured in fetching the data")
        }
        
        guard let data = result else
        {
            return nil
        }
        
        return data

    }
    
   
    func getFetchRequest(_ entityName:String) -> NSFetchRequest<NSFetchRequestResult>
    {
        let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)
        fetchRequest.entity = entity
        return fetchRequest
    }
    
    func deleteObject(_ managedObject : NSManagedObject)
    {
        self.managedObjectContext.delete(managedObject)
        self.saveContext()
    }
}

