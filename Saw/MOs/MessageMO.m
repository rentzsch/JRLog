#import "MessageMO.h"

@implementation MessageMO

- (NSString*)fileName {
	return [[self file] lastPathComponent];
}

@end
