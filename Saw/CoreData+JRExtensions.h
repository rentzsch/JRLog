/*******************************************************************************
	CoreData+JRExtensions.h
		Copyright (c) 2006-2007 Jonathan 'Wolf' Rentzsch: <http://rentzsch.com>
		Some rights reserved: <http://opensource.org/licenses/mit-license.php>

	***************************************************************************/

#import <Cocoa/Cocoa.h>

@interface NSManagedObject (JRExtensions)
+ (id)newInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (id)initAndInsertIntoManagedObjectContext:(NSManagedObjectContext*)moc_;

+ (id)rootObjectInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (id)rootObjectInManagedObjectContext:(NSManagedObjectContext*)moc_ error:(NSError**)error_;

+ (NSArray*)fetchAllInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSArray*)fetchAllInManagedObjectContext:(NSManagedObjectContext*)moc_ error:(NSError**)error_;

+ (NSString*)entityNameByHeuristic; // MyCoolObjectMO => @"MyCoolObject".
+ (NSEntityDescription*)entityDescriptionInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSFetchRequest*)fetchRequestForEntityInManagedObjectContext:(NSManagedObjectContext*)moc_;

+ (NSString*)defaultSortKeyWithManagedObjectContext:(NSManagedObjectContext*)moc_;

- (NSString*)objectURLID;
@end

@interface NSManagedObjectContext (JRExtensions)
- (NSArray*)executeFetchRequestNamed:(NSString*)fetchRequestName_;
- (NSArray*)executeFetchRequestNamed:(NSString*)fetchRequestName_ error:(NSError**)error_;
- (NSArray*)executeFetchRequestNamed:(NSString*)fetchRequestName_ substitutionVariables:(NSDictionary*)variables_;
- (NSArray*)executeFetchRequestNamed:(NSString*)fetchRequestName_ substitutionVariables:(NSDictionary*)variables_ error:(NSError**)error_;
- (id)executeSingleResultFetchRequestNamed:(NSString*)fetchRequestName_ substitutionVariables:(NSDictionary*)variables_ error:(NSError**)error_;

- (id)objectWithURLID:(NSString*)url_;
@end

