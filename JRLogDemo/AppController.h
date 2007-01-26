//
//  AppController.h
//  JRLogDemo
//
//  Created by wolf on 1/2/07.
//  Copyright __MyCompanyName__ 2007. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#define JRLogOverrideNSLog 1
#import "JRLog.h"

@interface AppController : NSObject <JRLogLogger> {
}

- (void)logWithLevel:(JRLogLevel)callerLevel_
			instance:(NSString*)instance_
				file:(const char*)file_
				line:(unsigned)line_
			function:(const char*)function_
			 message:(NSString*)message_;
@end
