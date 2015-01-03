# rdar-19368054

*Example project showing Swift compiler bug, [rdar://19368054](http://openradar.appspot.com/19368054)*

````swift
//  Returns valid Person object in App Target
//  Returns nil in Test Target
let person = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: context) as? Person
````
