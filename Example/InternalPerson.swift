
//  This file IS added to Test Target

import Foundation
import CoreData

internal class InternalPerson: NSManagedObject {
    
    @NSManaged internal var birthDate: NSDate
    @NSManaged internal var name: String
    
    convenience init(insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        let e = NSEntityDescription.entityForName("InternalPerson", inManagedObjectContext: context!)!
        self.init(entity: e, insertIntoManagedObjectContext: context)
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}
