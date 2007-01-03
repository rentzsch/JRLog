// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SourceMO.h instead.

#import <CoreData/CoreData.h>



@class SessionMO;


@interface _SourceMO : NSManagedObject {}


- (NSString*)name;
- (void)setName:(NSString*)value_;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;



- (NSString*)bundleID;
- (void)setBundleID:(NSString*)value_;

//- (BOOL)validateBundleID:(id*)value_ error:(NSError**)error_;




- (void)addSessionsObject:(SessionMO*)value_;
- (void)removeSessionsObject:(SessionMO*)value_;
- (NSMutableSet*)sessionsSet;


@end
