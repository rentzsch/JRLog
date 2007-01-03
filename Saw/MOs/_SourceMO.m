// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SourceMO.m instead.

#import "_SourceMO.h"

@implementation _SourceMO



- (NSString*)name {
	[self willAccessValueForKey:@"name"];
	NSString *result = [self primitiveValueForKey:@"name"];
	[self didAccessValueForKey:@"name"];
	return result;
}

- (void)setName:(NSString*)value_ {
    [self willChangeValueForKey:@"name"];
    [self setPrimitiveValue:value_ forKey:@"name"];
    [self didChangeValueForKey:@"name"];
}






- (NSString*)bundleID {
	[self willAccessValueForKey:@"bundleID"];
	NSString *result = [self primitiveValueForKey:@"bundleID"];
	[self didAccessValueForKey:@"bundleID"];
	return result;
}

- (void)setBundleID:(NSString*)value_ {
    [self willChangeValueForKey:@"bundleID"];
    [self setPrimitiveValue:value_ forKey:@"bundleID"];
    [self didChangeValueForKey:@"bundleID"];
}






	
- (void)addSessionsObject:(SessionMO*)value_ {
	NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value_ count:1];
	[self willChangeValueForKey:@"sessions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"sessions"] addObject:value_];
    [self didChangeValueForKey:@"sessions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeSessionsObject:(SessionMO*)value_ {
	NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value_ count:1];
	[self willChangeValueForKey:@"sessions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
	[[self primitiveValueForKey:@"sessions"] removeObject:value_];
	[self didChangeValueForKey:@"sessions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
	[changedObjects release];
}

- (NSMutableSet*)sessionsSet {
	return [self mutableSetValueForKey:@"sessions"];
}
	

@end
