#import "SourceMO.h"
#import "CoreData+JRExtensions.h"

@implementation SourceMO

+ (SourceMO*)fetchOneSourceWithBundleID:(NSString*)bundleID_ managedObjectContext:(NSManagedObjectContext*)moc_ error:(NSError**)error_ {
	NSDictionary *substitutionVariables = [NSDictionary dictionaryWithObjectsAndKeys:
		bundleID_ ? (id)bundleID_ : (id)[NSNull null], @"bundleID",
		nil];
	
	return [moc_ executeSingleResultFetchRequestNamed:@"sourceByBundleID"
								substitutionVariables:substitutionVariables
												error:error_];
}

@end
