#import "SessionMO.h"
#import "CoreData+JRExtensions.h"

@implementation SessionMO

+ (SessionMO*)fetchOneSessionWithUUID:(NSString*)sessionUUID_ managedObjectContext:(NSManagedObjectContext*)moc_ error:(NSError**)error_ {
	NSDictionary *substitutionVariables = [NSDictionary dictionaryWithObjectsAndKeys:
		sessionUUID_ ? (id)sessionUUID_ : (id)[NSNull null], @"sessionUUID",
		nil];
	
	return [moc_ executeSingleResultFetchRequestNamed:@"sessionWithUUID"
								substitutionVariables:substitutionVariables
												error:error_];
}

@end
