// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SessionMO.m instead.

#import "_SessionMO.h"

@implementation _SessionMO



- (NSString*)sessionUUID {
	[self willAccessValueForKey:@"sessionUUID"];
	NSString *result = [self primitiveValueForKey:@"sessionUUID"];
	[self didAccessValueForKey:@"sessionUUID"];
	return result;
}

- (void)setSessionUUID:(NSString*)value_ {
    [self willChangeValueForKey:@"sessionUUID"];
    [self setPrimitiveValue:value_ forKey:@"sessionUUID"];
    [self didChangeValueForKey:@"sessionUUID"];
}






- (NSDate*)date {
	[self willAccessValueForKey:@"date"];
	NSDate *result = [self primitiveValueForKey:@"date"];
	[self didAccessValueForKey:@"date"];
	return result;
}

- (void)setDate:(NSDate*)value_ {
    [self willChangeValueForKey:@"date"];
    [self setPrimitiveValue:value_ forKey:@"date"];
    [self didChangeValueForKey:@"date"];
}






- (NSNumber*)pid {
	[self willAccessValueForKey:@"pid"];
	NSNumber *result = [self primitiveValueForKey:@"pid"];
	[self didAccessValueForKey:@"pid"];
	return result;
}

- (void)setPid:(NSNumber*)value_ {
    [self willChangeValueForKey:@"pid"];
    [self setPrimitiveValue:value_ forKey:@"pid"];
    [self didChangeValueForKey:@"pid"];
}



- (long)pidValue {
	return [[self pid] longValue];
}

- (void)setPidValue:(long)value_ {
	[self setPid:[NSNumber numberWithLong:value_]];
}






	

- (SourceMO*)source {
	[self willAccessValueForKey:@"source"];
	SourceMO *result = [self primitiveValueForKey:@"source"];
	[self didAccessValueForKey:@"source"];
	return result;
}

- (void)setSource:(SourceMO*)value_ {
	[self willChangeValueForKey:@"source"];
	[self setPrimitiveValue:value_ forKey:@"source"];
	[self didChangeValueForKey:@"source"];
}

	

	
- (void)addMessagesObject:(MessageMO*)value_ {
	NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value_ count:1];
	[self willChangeValueForKey:@"messages" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"messages"] addObject:value_];
    [self didChangeValueForKey:@"messages" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeMessagesObject:(MessageMO*)value_ {
	NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value_ count:1];
	[self willChangeValueForKey:@"messages" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
	[[self primitiveValueForKey:@"messages"] removeObject:value_];
	[self didChangeValueForKey:@"messages" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
	[changedObjects release];
}

- (NSMutableSet*)messagesSet {
	return [self mutableSetValueForKey:@"messages"];
}
	

@end
