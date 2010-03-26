/*******************************************************************************
    JRLog.m
        Copyright (c) 2006-2010 Jonathan 'Wolf' Rentzsch: <http://rentzsch.com>
        Some rights reserved: <http://opensource.org/licenses/mit-license.php>

    ***************************************************************************/

#import "JRLog.h"
#include <unistd.h>

#if JRLogOverrideNSLog
id self = nil;
#endif
#undef NSLog

//
//  Statics
//
#pragma mark Statics

static JRLogLevel sDefaultJRLogLevel = JRLogLevel_Debug;

NSString *JRLogLevelNames[] = {
    @"UNSET",
    @"DEBUG",
    @"INFO",
    @"WARN",
    @"ERROR",
    @"ASSERT",
    @"FATAL",
    @"OFF"
};

//
//  JRLogCall
//

@implementation JRLogCall

- (id)initWithLevel:(JRLogLevel)callerLevel_
           instance:(NSString*)instance_
               file:(const char*)file_
               line:(unsigned)line_
           function:(const char*)function_
            message:(NSString*)message_
{
    self = [super init];
    if (self) {
        callerLevel = callerLevel_;
        instance = [instance_ retain];
        file = file_;
        line = line_;
        function = function_;
        message = [message_ retain];
    }
    return self;
}

- (void)dealloc {
    [instance release];
    [message release];
    [formattedMessage release];
    [super dealloc];
}

- (void)setFormattedMessage:(NSString*)formattedMessage_ {
    if (formattedMessage != formattedMessage_) {
        [formattedMessage release];
        formattedMessage = [formattedMessage_ retain];
    }
}

@end

//
//  JRLogDefaultLogger
//

@protocol JRLogDestinationDO
- (oneway void)logWithDictionary:(bycopy NSDictionary*)dictionary_;
@end

@interface JRLogDefaultLogger : NSObject <JRLogLogger> {
    NSString                *sessionUUID;
    BOOL                    tryDO;
    id<JRLogDestinationDO>  destination;
}
+ (id)sharedLogger;
- (void)destinationDOAvailable:(NSNotification*)notification_;
@end
@implementation JRLogDefaultLogger
+ (id)sharedLogger {
    static JRLogDefaultLogger *output = nil;
    if (!output) {
        output = [[JRLogDefaultLogger alloc] init];
    }
    return output;
}
- (id)init {
    self = [super init];
    if (self) {
        CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
#if MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5
        sessionUUID = (id)CFUUIDCreateString(kCFAllocatorDefault, uuid);
#else
        sessionUUID = NSMakeCollectable(CFUUIDCreateString(kCFAllocatorDefault, uuid));
#endif
        CFRelease(uuid);
        [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                            selector:@selector(destinationDOAvailable:)
                                                                name:@"JRLogDestinationDOAvailable"
                                                              object:nil];
        tryDO = YES;
    }
    return self;
}

- (void)destinationDOAvailable:(NSNotification*)notification_ {
    tryDO = YES;
}

- (void)logWithCall:(JRLogCall*)call_ {
    if (tryDO) {
        tryDO = NO;
        destination = [[NSConnection rootProxyForConnectionWithRegisteredName:@"JRLogDestinationDO" host:nil] retain];
    }
    if (destination) {
        NS_DURING
            [destination logWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                [[NSBundle mainBundle] bundleIdentifier], @"bundleID",
                sessionUUID, @"sessionUUID",
                [NSNumber numberWithLong:getpid()], @"pid",
                [NSDate date], @"date",
                [NSNumber numberWithInt:call_->callerLevel], @"level",
                call_->instance, @"instance",
                [NSString stringWithUTF8String:call_->file], @"file",
                [NSNumber numberWithUnsignedInt:call_->line], @"line",
                [NSString stringWithUTF8String:call_->function], @"function",
                call_->message, @"message",
                nil]];
        NS_HANDLER
            if ([[localException name] isEqualToString:NSObjectInaccessibleException]) {
                destination = nil;
            } else {
                [localException raise];
            }
        NS_ENDHANDLER
    } else {
        NSString *formattedMessage = [JRLogGetFormatter() formattedMessageWithCall:call_];
        if (formattedMessage) {
            puts([formattedMessage UTF8String]);
        }
    }
}
@end

//
//  JRLogDefaultFormatter
//

@implementation JRLogDefaultFormatter
+ (id)sharedFormatter {
    static JRLogDefaultFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[JRLogDefaultFormatter alloc] init];
    }
    return formatter;
}
- (id)init {
    self = [super init];
    if (self) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.S"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    }
    return self;
}
- (void)dealloc {
    [dateFormatter release];
    [super dealloc];
}
- (NSString*)formattedMessageWithCall:(JRLogCall*)call_ {
    // "yyy-MM-dd HH:mm:ss.S MyProcess[PID:TASK] INFO MyClass.m:123: blah blah"
    NSString *threadID = [NSString stringWithFormat:@"%lx", mach_thread_self()];
    return [NSString stringWithFormat:@"%@ %@[%ld:%@] %@ %@:%u: %@",
            [dateFormatter stringFromDate:[NSDate date]],
            [[NSProcessInfo processInfo] processName],
            getpid(),
            threadID,
            JRLogLevelNames[call_->callerLevel],
            [[NSString stringWithUTF8String:call_->file] lastPathComponent],
            call_->line,
            call_->message];
}
@end



//
//
//

static JRLogLevel parseJRLogLevel(NSString *level_) {
    static NSDictionary *levelLookup = nil;
    if (!levelLookup) {
        levelLookup = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInt:JRLogLevel_Debug], @"debug",
            [NSNumber numberWithInt:JRLogLevel_Info], @"info",
            [NSNumber numberWithInt:JRLogLevel_Warn], @"warn",
            [NSNumber numberWithInt:JRLogLevel_Error], @"error",
            [NSNumber numberWithInt:JRLogLevel_Assert], @"assert",
            [NSNumber numberWithInt:JRLogLevel_Fatal], @"fatal",
            [NSNumber numberWithInt:JRLogLevel_Off], @"off",
            nil];
    }
    NSNumber *result = [levelLookup objectForKey:[level_ lowercaseString]];
    return result ? [result intValue] : JRLogLevel_UNSET;
}

static void LoadJRLogSettings() {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    //  Load+interpret the Info.plist-based settings.
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    [settings addEntriesFromDictionary:[[NSBundle mainBundle] infoDictionary]];
    [settings addEntriesFromDictionary:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
    
    NSArray *keys = [settings allKeys];
    unsigned keyIndex = 0, keyCount = [keys count];
    for(; keyIndex < keyCount; keyIndex++) {
        NSString *key = [keys objectAtIndex:keyIndex];
        if ([key hasPrefix:@"JRLogLevel"]) {
            JRLogLevel level = parseJRLogLevel([settings objectForKey:key]);
            if (JRLogLevel_UNSET == level) {
                NSLog(@"JRLog: can't parse \"%@\" JRLogLevel value for key \"%@\"", [settings objectForKey:key], key);
            } else {
                NSArray *keyNames = [key componentsSeparatedByString:@"."];
                if ([keyNames count] == 2) {
                    //  It's a pseudo-keypath: JRLogLevel.MyClassName.
                    Class c = NSClassFromString([keyNames lastObject]);
                    if (c) {
                        [c setClassJRLogLevel:level];
                    } else {
                        NSLog(@"JRLog: unknown class \"%@\"", [keyNames lastObject]);
                    }
                } else {
                    //  Just a plain "JRLogLevel": it's for the default level.
                    JRLogSetDefaultLevel(level);
                }
            }
        }
    }
    
    [pool release];
}

BOOL JRLogIsLevelActive(id self_, JRLogLevel callerLevel_) {
    assert(callerLevel_ >= JRLogLevel_Debug && callerLevel_ <= JRLogLevel_Fatal);
    
    static BOOL loadedJRLogSettings = NO;
    if (!loadedJRLogSettings) {
        loadedJRLogSettings = YES;
        LoadJRLogSettings();
    }
    
    //  Setting the default level to OFF disables all logging, regardless of everything else.
    if (JRLogLevel_Off == sDefaultJRLogLevel)
        return NO;
    
    JRLogLevel currentLevel;
    if (self_) {
        currentLevel = [[self_ class] classJRLogLevel];
        if (JRLogLevel_UNSET == currentLevel) { 
            currentLevel = sDefaultJRLogLevel;
        }
    } else {
        currentLevel = sDefaultJRLogLevel;
        // TODO It would be cool if we could use the file's name was a symbol to set logging levels for JRCLog... functions.
    }
    
    return callerLevel_ >= currentLevel;
}

    void
JRLog(
    id          self_,
    JRLogLevel  callerLevel_,
    unsigned    line_,
    const char  *file_,
    const char  *function_,
    NSString    *format_,
    ...)
{
    assert(callerLevel_ >= JRLogLevel_Debug && callerLevel_ <= JRLogLevel_Fatal);
    assert(file_);
    assert(function_);
    assert(format_);
    
    //
    va_list args;
    va_start(args, format_);
    NSString *message = [[[NSString alloc] initWithFormat:format_ arguments:args] autorelease];
    va_end(args);
    
    id<JRLogLogger> logger = JRLogGetLogger();
    JRLogCall *call = [[[JRLogCall alloc] initWithLevel:callerLevel_
                                               instance:self_ ? [NSString stringWithFormat:@"<%@: %p>", [self_ className], self_] : @"nil"
                                                   file:file_
                                                   line:line_
                                               function:function_
                                                message:message] autorelease];
    [logger logWithCall:call];
    
    if (JRLogLevel_Fatal == callerLevel_) {
        exit(1);
    }
}

    void
JRLogAssertionFailure(
    id          self_,
    unsigned    line_,
    const char  *file_,
    const char  *function_,
    const char  *condition_,
    NSString    *format_,
    ...)
{
    assert(file_);
    assert(function_);
    assert(condition_);
    
    NSString *message;
    if (format_) {
        va_list args;
        va_start(args, format_);
        message = [[[NSString alloc] initWithFormat:format_ arguments:args] autorelease];
        va_end(args);
        message = [NSString stringWithFormat:@"%s (%@)", condition_, message];
    } else {
        message = [NSString stringWithUTF8String:condition_];
    }
    
    id<JRLogLogger> logger = JRLogGetLogger();
    JRLogCall *call = [[[JRLogCall alloc] initWithLevel:JRLogLevel_Assert
                                               instance:self_ ? [NSString stringWithFormat:@"<%@: %p>", [self_ className], self_] : @"nil"
                                                   file:file_
                                                   line:line_
                                               function:function_
                                                message:message] autorelease];
    [logger logWithCall:call];
    
    // This is just here so "Stop on Objective-C Exception" will catch assertion failures.
    NS_DURING
        [NSException raise:@"JRLogAssertionFailure" format:nil];
    NS_HANDLER
    NS_ENDHANDLER
}

JRLogLevel JRLogGetDefaultLevel() {
    return sDefaultJRLogLevel;
}

void JRLogSetDefaultLevel(JRLogLevel level_) {
    assert(level_ >= JRLogLevel_Debug && level_ <= JRLogLevel_Off);
    sDefaultJRLogLevel = level_;
}

static id<JRLogLogger> sLogger = nil;

id<JRLogLogger> JRLogGetLogger() {
    return sLogger ? sLogger : [JRLogDefaultLogger sharedLogger];
}

void JRLogSetLogger(id<JRLogLogger> logger_) {
    if (sLogger != logger_) {
        [(id)sLogger release];
        sLogger = [(id)logger_ retain];
    }
}

static id<JRLogFormatter> sFormatter = nil;

id<JRLogFormatter> JRLogGetFormatter() {
    return sFormatter ? sFormatter : [JRLogDefaultFormatter sharedFormatter];
}

void JRLogSetFormatter(id<JRLogFormatter> formatter_) {
    if (sFormatter != formatter_) {
        [(id)sFormatter release];
        sFormatter = [(id)formatter_ retain];
    }
}

@implementation NSObject (JRLogAdditions)

NSMapTable *gClassLoggingLevels = NULL;
+ (void)load {
    if (!gClassLoggingLevels) {
#if MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5
        gClassLoggingLevels = NSCreateMapTable(NSIntMapKeyCallBacks, NSIntMapValueCallBacks, 32);
#else
        gClassLoggingLevels = NSCreateMapTable(NSIntegerMapKeyCallBacks, NSIntegerMapValueCallBacks, 32);
#endif
    }
}

+ (JRLogLevel)classJRLogLevel {
    void *mapValue = NSMapGet(gClassLoggingLevels, self);
    if (mapValue) {
        return (JRLogLevel)mapValue;
    } else {
        Class superclass = [self superclass];
        return superclass ? [superclass classJRLogLevel] : JRLogLevel_UNSET;
    }
}

+ (void)setClassJRLogLevel:(JRLogLevel)level_ {
    if (JRLogLevel_UNSET == level_) {
        NSMapRemove(gClassLoggingLevels, self);
    } else {
        NSMapInsert(gClassLoggingLevels, self, (const void*)level_);
    }
}

@end
