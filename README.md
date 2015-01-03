# rdar-19368054

*Example project showing Swift compiler bug, [rdar://19368054](http://openradar.appspot.com/19368054)*

````swift
//  Returns valid Person object in App Target
//  Returns nil in Test Target
let person = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: context) as? Person

//	Workaround, implement the following convenience initializers
class Person: NSManagedObject {
    
    convenience init(context: NSManagedObjectContext?) {
        let e = NSEntityDescription.entityForName("Person", inManagedObjectContext: context!)!
        self.init(entity: e, insertIntoManagedObjectContext: context)
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}
````
