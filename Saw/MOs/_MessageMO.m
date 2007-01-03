// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MessageMO.m instead.

#import "_MessageMO.h"

@implementation _MessageMO



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






- (NSString*)file {
	[self willAccessValueForKey:@"file"];
	NSString *result = [self primitiveValueForKey:@"file"];
	[self didAccessValueForKey:@"file"];
	return result;
}

- (void)setFile:(NSString*)value_ {
    [self willChangeValueForKey:@"file"];
    [self setPrimitiveValue:value_ forKey:@"file"];
    [self didChangeValueForKey:@"file"];
}






- (NSString*)instance {
	[self willAccessValueForKey:@"instance"];
	NSString *result = [self primitiveValueForKey:@"instance"];
	[self didAccessValueForKey:@"instance"];
	return result;
}

- (void)setInstance:(NSString*)value_ {
    [self willChangeValueForKey:@"instance"];
    [self setPrimitiveValue:value_ forKey:@"instance"];
    [self didChangeValueForKey:@"instance"];
}






- (NSNumber*)line {
	[self willAccessValueForKey:@"line"];
	NSNumber *result = [self primitiveValueForKey:@"line"];
	[self didAccessValueForKey:@"line"];
	return result;
}

- (void)setLine:(NSNumber*)value_ {
    [self willChangeValueForKey:@"line"];
    [self setPrimitiveValue:value_ forKey:@"line"];
    [self didChangeValueForKey:@"line"];
}



- (long)lineValue {
	return [[self line] longValue];
}

- (void)setLineValue:(long)value_ {
	[self setLine:[NSNumber numberWithLong:value_]];
}






- (NSNumber*)level {
	[self willAccessValueForKey:@"level"];
	NSNumber *result = [self primitiveValueForKey:@"level"];
	[self didAccessValueForKey:@"level"];
	return result;
}

- (void)setLevel:(NSNumber*)value_ {
    [self willChangeValueForKey:@"level"];
    [self setPrimitiveValue:value_ forKey:@"level"];
    [self didChangeValueForKey:@"level"];
}



- (short)levelValue {
	return [[self level] shortValue];
}

- (void)setLevelValue:(short)value_ {
	[self setLevel:[NSNumber numberWithShort:value_]];
}






- (NSString*)function {
	[self willAccessValueForKey:@"function"];
	NSString *result = [self primitiveValueForKey:@"function"];
	[self didAccessValueForKey:@"function"];
	return result;
}

- (void)setFunction:(NSString*)value_ {
    [self willChangeValueForKey:@"function"];
    [self setPrimitiveValue:value_ forKey:@"function"];
    [self didChangeValueForKey:@"function"];
}






- (NSString*)message {
	[self willAccessValueForKey:@"message"];
	NSString *result = [self primitiveValueForKey:@"message"];
	[self didAccessValueForKey:@"message"];
	return result;
}

- (void)setMessage:(NSString*)value_ {
    [self willChangeValueForKey:@"message"];
    [self setPrimitiveValue:value_ forKey:@"message"];
    [self didChangeValueForKey:@"message"];
}






	

- (SessionMO*)session {
	[self willAccessValueForKey:@"session"];
	SessionMO *result = [self primitiveValueForKey:@"session"];
	[self didAccessValueForKey:@"session"];
	return result;
}

- (void)setSession:(SessionMO*)value_ {
	[self willChangeValueForKey:@"session"];
	[self setPrimitiveValue:value_ forKey:@"session"];
	[self didChangeValueForKey:@"session"];
}

	

@end
