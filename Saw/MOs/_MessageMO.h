// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MessageMO.h instead.

#import <CoreData/CoreData.h>



@class SessionMO;


@interface _MessageMO : NSManagedObject {}


- (NSDate*)date;
- (void)setDate:(NSDate*)value_;

//- (BOOL)validateDate:(id*)value_ error:(NSError**)error_;



- (NSString*)file;
- (void)setFile:(NSString*)value_;

//- (BOOL)validateFile:(id*)value_ error:(NSError**)error_;



- (NSString*)instance;
- (void)setInstance:(NSString*)value_;

//- (BOOL)validateInstance:(id*)value_ error:(NSError**)error_;



- (NSNumber*)line;
- (void)setLine:(NSNumber*)value_;

- (long)lineValue;
- (void)setLineValue:(long)value_;

//- (BOOL)validateLine:(id*)value_ error:(NSError**)error_;



- (NSNumber*)level;
- (void)setLevel:(NSNumber*)value_;

- (short)levelValue;
- (void)setLevelValue:(short)value_;

//- (BOOL)validateLevel:(id*)value_ error:(NSError**)error_;



- (NSString*)function;
- (void)setFunction:(NSString*)value_;

//- (BOOL)validateFunction:(id*)value_ error:(NSError**)error_;



- (NSString*)message;
- (void)setMessage:(NSString*)value_;

//- (BOOL)validateMessage:(id*)value_ error:(NSError**)error_;




- (SessionMO*)session;
- (void)setSession:(SessionMO*)value_;
//- (BOOL)validateSession:(id*)value_ error:(NSError**)error_;


@end
