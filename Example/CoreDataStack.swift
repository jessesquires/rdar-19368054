
import Foundation
import CoreData

class CoreDataStack {
    
    let context: NSManagedObjectContext
    let persistentStoreCoordinator: NSPersistentStoreCoordinator
    
    init(inMemory: Bool = true) {
        let modelURL = NSBundle.mainBundle().URLForResource("Example", withExtension: "momd")!
        
        let model = NSManagedObjectModel(contentsOfURL: modelURL)!
        
        let documentsDirectoryURL = NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory,
            inDomain: .UserDomainMask, appropriateForURL: nil, create: true, error: nil)
        
        let storeURL = documentsDirectoryURL!.URLByAppendingPathComponent("Example.sqlite")
        
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        persistentStoreCoordinator.addPersistentStoreWithType(inMemory ? NSInMemoryStoreType : NSSQLiteStoreType,
            configuration: nil, URL: inMemory ? nil : storeURL, options: nil, error: nil)
        
        context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
    }
}
