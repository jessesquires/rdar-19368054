
import XCTest
import CoreData

class ExampleTestsFailing: XCTestCase {
    
    func test_that_fails() {
        let stack = CoreDataStack()
        
        //  internal class in App Target
        //  added to Test Target for testing
        //  this test should pass
        
        let object = NSEntityDescription.insertNewObjectForEntityForName("InternalPerson", inManagedObjectContext: stack.context)
        
        println("\n*** FAILING OBJECT CLASS == \(NSStringFromClass(object_getClass(object)))\n")
        
        if let person = object as? InternalPerson {
            XCTAssert(true, "Cast succeeded")
        }
        else {
            XCTFail("Cast failed!")
        }
    }
    
    func test_workaround_that_passes() {
        let stack = CoreDataStack()
        
        //  Using this convenience initializer works
        let person = InternalPerson(context: stack.context)
        XCTAssertNotNil(person, "Person should not be nil")
        
        //  This also works, but is less convenient than above
        let entityDescription = NSEntityDescription.entityForName("InternalPerson", inManagedObjectContext: stack.context)!
        let person2 = InternalPerson(entity: entityDescription, insertIntoManagedObjectContext: stack.context)
        XCTAssertNotNil(person2, "Person should not be nil")
    }
    
}
