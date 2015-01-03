
//  This file IS added to Test Target

import Foundation
import CoreData

internal class InternalPerson: NSManagedObject {

    @NSManaged internal var birthDate: NSDate
    @NSManaged internal var name: String

}
