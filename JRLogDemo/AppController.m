#import "AppController.h"
#define JRLogOverrideNSLog 1
#import "JRLog.h"

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
	//logC();
	NSLog(@"time: %@", [NSCalendarDate date]);
}

@end
