
import XCTest
import CoreData

class ExampleTestsFailing: XCTestCase {
    
    func test_that_fails() {
        let stack = CoreDataStack()
        
        //  internal class in App Target
        //  added to Test Target for testing
        
        let object = NSEntityDescription.insertNewObjectForEntityForName("InternalPerson", inManagedObjectContext: stack.context)
        
        println("\n*** FAILING OBJECT CLASS == \(NSStringFromClass(object_getClass(object)))\n")
        
        if let person = object as? InternalPerson {
            XCTAssert(true, "Cast succeeded")
        }
        else {
            XCTFail("Cast failed!")
        }
    }
    
}
