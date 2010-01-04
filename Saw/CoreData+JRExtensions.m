/*******************************************************************************
	CoreData+JRExtensions.m
		Copyright (c) 2006-2007 Jonathan 'Wolf' Rentzsch: <http://rentzsch.com>
		Some rights reserved: <http://opensource.org/licenses/mit-license.php>

	***************************************************************************/

#import "CoreData+JRExtensions.h"

@implementation NSManagedObject (JRExtensions)

+ (id)newInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	return [[self alloc] initAndInsertIntoManagedObjectContext:moc_];
}

- (id)initAndInsertIntoManagedObjectContext:(NSManagedObjectContext*)moc_ {
	return [NSEntityDescription insertNewObjectForEntityForName:[[[self class] entityDescriptionInManagedObjectContext:moc_] name]
										 inManagedObjectContext:moc_];
}

+ (id)rootObjectInManagedObjectContext:(NSManagedObjectContext*)moc_ error:(NSError**)error_ {
	NSError *error = nil;
	NSArray *objects = [moc_ executeFetchRequest:[self fetchRequestForEntityInManagedObjectContext:moc_] error:&error];
	NSAssert( objects, @"-[NSManagedObjectContext executeFetchRequest] returned nil" );
	
	id result = nil;
	
	switch( [objects count] ) {
		case 0:
			[[moc_ undoManager] disableUndoRegistration];
			result = [self newInManagedObjectContext:moc_];
			[moc_ processPendingChanges];
			[[moc_ undoManager] enableUndoRegistration];
			break;
		case 1:
			result = [objects objectAtIndex:0];
			break;
		default:
			NSAssert2( NO, @"0 or 1 %@ objects expected, %d found", [self className], [objects count] );
	}
	
	if (error_) {
		*error_ = error;
	}
	
	return result;
}

+ (id)rootObjectInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSError *error = nil;
	id result = [self rootObjectInManagedObjectContext:moc_ error:&error];
	if (error) {
		[NSApp presentError:error];
	}
	return result;
}

+ (NSString*)entityNameByHeuristic {
	NSString *result = [self className];
	if( [result hasSuffix:@"MO"] ) {
		result = [result substringToIndex:([result length]-2)];
	}
	return result;
}

+ (NSEntityDescription*)entityDescriptionInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSEntityDescription *result = [NSEntityDescription entityForName:[self entityNameByHeuristic] inManagedObjectContext:moc_];
	if( nil == result ) {
		// Heuristic failed. Do it the hard way.
		NSString *className = [self className];
		NSManagedObjectModel *managedObjectModel = [[moc_ persistentStoreCoordinator] managedObjectModel];
		NSArray *entities = [managedObjectModel entities];
		unsigned entityIndex = 0, entityCount = [entities count];
		for( ; nil == result && entityIndex < entityCount; ++entityIndex ) {
			if( [[[entities objectAtIndex:entityIndex] managedObjectClassName] isEqualToString:className] ) {
				result = [entities objectAtIndex:entityIndex];
			}
		}
		NSAssert1( result, @"no entity found with a managedObjectClassName of %@", className );
	}
	return result;
}

+ (NSFetchRequest*)fetchRequestForEntityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSFetchRequest *result = [[[NSFetchRequest alloc] init] autorelease];
	[result setEntity:[self entityDescriptionInManagedObjectContext:moc_]];
	NSString *defaultSortKey = [self defaultSortKeyWithManagedObjectContext:moc_];
	if (defaultSortKey) {
		[result setSortDescriptors:[NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:defaultSortKey ascending:YES] autorelease]]];
	}
	return result;
}

+ (NSArray*)fetchAllInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSError *error = nil;
	NSArray *result = [self fetchAllInManagedObjectContext:moc_ error:nil];
	if (error) {
		[NSApp presentError:error];
	}
	return result;
}

+ (NSArray*)fetchAllInManagedObjectContext:(NSManagedObjectContext*)moc_ error:(NSError**)error_ {
	return [moc_ executeFetchRequest:[self fetchRequestForEntityInManagedObjectContext:moc_]
							   error:error_];
}

+ (NSString*)defaultSortKeyWithManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSString *result = nil;
	NSEntityDescription *entityDesc = [self entityDescriptionInManagedObjectContext:moc_];
	if (entityDesc) {
		result = [[entityDesc userInfo] objectForKey:@"defaultSortKey"];
		if (!result && [[[entityDesc propertiesByName] allKeys] containsObject:@"position_"]) {
			result = @"position_";
		}
	}
	return result;
}

- (NSString*)objectURLID {
	return [[[self objectID] URIRepresentation] absoluteString];
}

@end

@implementation NSManagedObjectContext (JRExtensions)

- (NSArray*)executeFetchRequestNamed:(NSString*)fetchRequestName_ {
	return [self executeFetchRequestNamed:fetchRequestName_ substitutionVariables:nil];
}

- (NSArray*)executeFetchRequestNamed:(NSString*)fetchRequestName_ error:(NSError**)error_ {
	return [self executeFetchRequestNamed:fetchRequestName_ substitutionVariables:nil error:error_];
}

- (NSArray*)executeFetchRequestNamed:(NSString*)fetchRequestName_ substitutionVariables:(NSDictionary*)variables_ {
	NSError *error = nil;
	NSArray *result = [self executeFetchRequestNamed:fetchRequestName_ substitutionVariables:variables_ error:&error];
	if (error) {
		[NSApp presentError:error];
	}
	return result;
}

#define FetchRequestSortDescriptorsSeemsBroken	1

- (NSArray*)executeFetchRequestNamed:(NSString*)fetchRequestName_ substitutionVariables:(NSDictionary*)variables_ error:(NSError**)error_ {
	NSManagedObjectModel *model = [[self persistentStoreCoordinator] managedObjectModel];
	NSFetchRequest *fetchRequest = [model fetchRequestFromTemplateWithName:fetchRequestName_
													 substitutionVariables:variables_ ? variables_ : [NSDictionary dictionary]];
	NSAssert1(fetchRequest, @"Can't find fetch request named \"%@\".", fetchRequestName_);
	
	NSString *defaultSortKey = nil;
	Class entityClass = NSClassFromString([[fetchRequest entity] managedObjectClassName]);
	if ([entityClass respondsToSelector:@selector(defaultSortKeyWithManagedObjectContext:)]) {
		defaultSortKey = [entityClass defaultSortKeyWithManagedObjectContext:self];
	}
	
#if !FetchRequestSortDescriptorsSeemsBroken
	if (defaultSortKey) {
		NSAssert([[fetchRequest sortDescriptors] count] == 0, @"Model-based fetch requests can't have sortDescriptors.");
		[fetchRequest setSortDescriptors:[NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:defaultSortKey ascending:YES] autorelease]]];
	}
#endif
	
	NSArray *result = [self executeFetchRequest:fetchRequest error:error_];
	
#if FetchRequestSortDescriptorsSeemsBroken
	if (defaultSortKey) {
		result = [result sortedArrayUsingDescriptors:[NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:defaultSortKey ascending:YES] autorelease]]];
	}
#endif
	return result;
}

- (id)executeSingleResultFetchRequestNamed:(NSString*)fetchRequestName_ substitutionVariables:(NSDictionary*)variables_ error:(NSError**)error_ {
	id		result = nil;
	NSError	*error = nil;
	
	NSArray *objects = [self executeFetchRequestNamed:fetchRequestName_ substitutionVariables:variables_ error:&error];
	NSAssert(objects, nil);
	
	if (!error) {
		switch ([objects count]) {
			case 0:
				//	Nothing found matching the fetch request. That's cool, though: we'll just return nil.
				break;
			case 1:
				result = [objects objectAtIndex:0];
				break;
			default:
				NSAssert2(NO, @"%@: 0 or 1 objects expected, %u found", fetchRequestName_, [objects count]);
		}
	}
	
	if (error_) *error_ = error;
	return result;
}

- (id)objectWithURLID:(NSString*)url_ {
	NSParameterAssert(url_);
	NSURL *url = [NSURL URLWithString:url_];
	NSAssert1(url, @"[NSURL URLWithString:@\"%@\"] failed", url_);
	NSManagedObjectID *objectID = [[self persistentStoreCoordinator] managedObjectIDForURIRepresentation:url];
	return objectID ? [self objectRegisteredForID:objectID] : nil;
}

@end
