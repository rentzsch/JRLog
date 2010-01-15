#import "AppController.h"

@implementation AppController

- (void)applicationDidFinishLaunching:(NSNotification*)notification_ {
	[NSTimer scheduledTimerWithTimeInterval:1.0
									 target:self
								   selector:@selector(log:)
								   userInfo:nil
									repeats:YES];
}

static void logC() {
	NSLog(@"logging!");
}

- (void)log:(NSTimer*)timer_ {
    static int i = 0;
    i++;
    if ((i % 2) == 0)
        [AppController setJRLogLogger: self];
    else
        [AppController setJRLogLogger: nil];  // Set to default logger

	//logC();
	JRLogInfo(@"time: %@", [NSCalendarDate date]);
}


- (void)logWithLevel:(JRLogLevel)callerLevel_
			instance:(NSString*)instance_
				file:(const char*)file_
				line:(unsigned)line_
			function:(const char*)function_
			 message:(NSString*)message_;
{
    // NSLog is overridden to JRLog and will cause infinite recursion
    fprintf(stderr, "custom log: %s\n", [message_ UTF8String]);
}

@end
