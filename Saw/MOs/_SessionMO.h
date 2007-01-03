// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SessionMO.h instead.

#import <CoreData/CoreData.h>



@class SourceMO;

@class MessageMO;


@interface _SessionMO : NSManagedObject {}


- (NSString*)sessionUUID;
- (void)setSessionUUID:(NSString*)value_;

//- (BOOL)validateSessionUUID:(id*)value_ error:(NSError**)error_;



- (NSDate*)date;
- (void)setDate:(NSDate*)value_;

//- (BOOL)validateDate:(id*)value_ error:(NSError**)error_;



- (NSNumber*)pid;
- (void)setPid:(NSNumber*)value_;

- (long)pidValue;
- (void)setPidValue:(long)value_;

//- (BOOL)validatePid:(id*)value_ error:(NSError**)error_;




- (SourceMO*)source;
- (void)setSource:(SourceMO*)value_;
//- (BOOL)validateSource:(id*)value_ error:(NSError**)error_;



- (void)addMessagesObject:(MessageMO*)value_;
- (void)removeMessagesObject:(MessageMO*)value_;
- (NSMutableSet*)messagesSet;


@end
