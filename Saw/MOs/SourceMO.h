#import "_SourceMO.h"

@interface SourceMO : _SourceMO {}

+ (SourceMO*)fetchOneSourceWithBundleID:(NSString*)bundleID_ managedObjectContext:(NSManagedObjectContext*)moc_ error:(NSError**)error_;

@end
