#import "_SessionMO.h"

@interface SessionMO : _SessionMO {}

+ (SessionMO*)fetchOneSessionWithUUID:(NSString*)sessionUUID_ managedObjectContext:(NSManagedObjectContext*)moc_ error:(NSError**)error_;

@end
