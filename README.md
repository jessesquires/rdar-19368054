# rdar-19368054

*Example project showing Swift compiler bug, [rdar://19368054](http://openradar.appspot.com/19368054)*

### Summary

The following [NSEntityDescription](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/CoreDataFramework/Classes/NSEntityDescription_Class/index.html#//apple_ref/occ/clm/NSEntityDescription/insertNewObjectForEntityForName:inManagedObjectContext:) class function incorrectly returns `nil` in test target.

````swift
class func insertNewObjectForEntityForName(_ entityName: String,
                    inManagedObjectContext context: NSManagedObjectContext) -> AnyObject
````

### Example

````swift
//  Example
//  Returns valid Person object in App Target
//  Returns nil in Test Target
let person = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: context) as? Person
````

### Workaround

````swift
//	Workaround
//  Implement the following convenience initializer
class Person: NSManagedObject {

    convenience init(context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entityForName("Person", inManagedObjectContext: context)!
        self.init(entity: entityDescription, insertIntoManagedObjectContext: context)
    }
    
}
````
