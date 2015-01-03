
//  This file IS added to Test Target

import Foundation
import CoreData

internal class InternalPerson: NSManagedObject {
    
    @NSManaged internal var birthDate: NSDate
    @NSManaged internal var name: String
    
    convenience internal init(context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entityForName("InternalPerson", inManagedObjectContext: context)!
        self.init(entity: entityDescription, insertIntoManagedObjectContext: context)
    }
    
    override internal init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}
