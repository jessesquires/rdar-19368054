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
//  Workaround
//  Implement the following convenience initializer
class Person: NSManagedObject {

    convenience init(context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entityForName("Person", inManagedObjectContext: context)!
        self.init(entity: entityDescription, insertIntoManagedObjectContext: context)
    }
    
}
````

### Swift extensions will not work

-------------------------------

### Update!
The following extension *will* work:

````swift
extension NSManagedObject {

    class func entityName() -> String {
        let fullClassName = NSStringFromClass(object_getClass(self))
        let classNameComponents: [String] = split(fullClassName) { $0 == "." }
        return last(classNameComponents)!
    }

    convenience init(context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entityForName(self.dynamicType.entityName(), inManagedObjectContext: context)!
        self.init(entity: entityDescription, insertIntoManagedObjectContext: context)
    }
}
````

--------------------------------

It would be nice to generalize this by putting this convenience initializer in an extension. Unfortunately, that will not work. Here are some attempts:

(1) A common strategy in Objective-C. Add a class method `entityName()` using `NSStringFromClass()` and a class factory method for a inserting new managed object
````swift
//  THIS DOES NOT WORK
//  This is the original bug!
extension NSManagedObject {
 
    class public func entityName() -> String {
        //  Swift managed object class are prefixed with module name, 'ModuleName.ClassName'
        //  For this to work with Core Data, we need to parse 'ClassName' only
        let fullClassName: String = NSStringFromClass(object_getClass(self))
        let classNameComponents: [String] = split(fullClassName) { $0 == "." }
        return last(classNameComponents)!
    }
    
    //  Returns nil in Test Target, which prevents you from testing your model
    class public func insertNewObjectInContext(context: NSManagedObjectContext) -> AnyObject {
        return NSEntityDescription.insertNewObjectForEntityForName(entityName(), inManagedObjectContext: context)
    }
    
}
````

(2) Add a **class** func `entityName()` and convenience initializer
````swift
//  THIS DOES NOT WORK
//  In the initializer, NSManagedObject.entityName() throws the assert even if you override entityName()
//  This is because it calls the method on NSManagedObject, not your subclass
extension NSManagedObject {
    
    class func entityName() -> String {
        //  always throws
        assert(false, "Subclasses must override this method")
        return ""
    }
    
    convenience init(context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entityForName(NSManagedObject.entityName(), inManagedObjectContext: context)!
        self.init(entity: entityDescription, insertIntoManagedObjectContext: context)
    }
}
````

(3) Add an **instance** func `entityName()` and convenience initializer
````swift
//  THIS DOES NOT WORK
//  Error: use of 'self' in delegating initializer before self.init is called
extension NSManagedObject {
    
    func entityName() -> String {
        assert(false, "Subclasses must override this method")
        return ""
    }
    
    convenience init(context: NSManagedObjectContext) {
        //  can't use 'self' before calling 'self.init' in a convenience init
        let entityDescription = NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: context)!
        self.init(entity: entityDescription, insertIntoManagedObjectContext: context)
    }
}

````

(4) Add a **class** func `entityName()` **using `NSStringFromClass()`** and convenience initializer
````swift
//  THIS DOES NOT WORK
//  Fatal error: unexpectedly found nil while unwrapping an Optional value
//  Same situation as (2)
//  In the initializer, NSManagedObject.entityName() calls the method on NSManagedObject, not your subclass
extension NSManagedObject {
    
    class func entityName() -> String {
        //  returns NSManagedObject, Cocoa classes ARE NOT PREFIXED
        let fullClassName: String = NSStringFromClass(object_getClass(self))
        
        //  returns [NSManagedObject]
        let classNameComponents: [String] = split(fullClassName) { $0 == "." }
        
        //  exception (fatal error above)
        return last(classNameComponents)!
    }
    
    convenience init(context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entityForName(NSManagedObject.entityName(), inManagedObjectContext: context)!
        self.init(entity: entityDescription, insertIntoManagedObjectContext: context)
    }
}
````
