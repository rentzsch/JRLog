//
//  Saw_AppDelegate.h
//  Saw
//
//  Created by wolf on 11/30/06.
//  Copyright __MyCompanyName__ 2006 . All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Saw_AppDelegate : NSObject 
{
    IBOutlet NSWindow *window;
	IBOutlet NSTextView	*textView;
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSManagedObjectModel *)managedObjectModel;
- (NSManagedObjectContext *)managedObjectContext;

- (IBAction)saveAction:sender;

@end
