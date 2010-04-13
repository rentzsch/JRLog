/*******************************************************************************
    JRLog.h
        Copyright (c) 2006-2010 Jonathan 'Wolf' Rentzsch: <http://rentzsch.com>
        Some rights reserved: <http://opensource.org/licenses/mit-license.php>

    ***************************************************************************/

#import <Foundation/Foundation.h>

//  What you need to remember: Debug > Info > Warn > Error > Assert > Fatal.

typedef enum {
    JRLogLevel_UNSET,
    JRLogLevel_Debug,
    JRLogLevel_Info,
    JRLogLevel_Warn,
    JRLogLevel_Error,
    JRLogLevel_Assert,
    JRLogLevel_Fatal,
    JRLogLevel_Off,
} JRLogLevel;

extern NSString *JRLogLevelNames[]; // JRLogLevelNames[JRLogLevel_Debug] => @"DEBUG".

#ifndef NS
    #ifdef NS_NAMESPACE
        #define JRNS_CONCAT_TOKENS(a,b) a##_##b
        #define JRNS_EVALUATE(a,b) JRNS_CONCAT_TOKENS(a,b)
        #define NS(original_name) JRNS_EVALUATE(NS_NAMESPACE, original_name)
    #else
        #define NS(original_name) original_name
    #endif
#endif

@interface NS(JRLogCall) : NSObject {
@public
    JRLogLevel  callerLevel;
    NSString    *instance;
    const char  *file;
    unsigned    line;
    const char  *function;
    NSString    *message;
    NSString    *formattedMessage;
}
- (id)initWithLevel:(JRLogLevel)callerLevel_
           instance:(NSString*)instance_
               file:(const char*)file_
               line:(unsigned)line_
           function:(const char*)function_
            message:(NSString*)message_;
- (void)setFormattedMessage:(NSString*)formattedMessage_;
@end
#define JRLogCall NS(JRLogCall)

@protocol NS(JRLogLogger)
- (void)logWithCall:(JRLogCall*)call_;
@end
#define JRLogLogger NS(JRLogLogger)

@protocol NS(JRLogFormatter)
- (NSString*)formattedMessageWithCall:(JRLogCall*)call_;
@end
#define JRLogFormatter NS(JRLogFormatter)

@interface NS(JRLogDefaultFormatter) : NSObject<JRLogFormatter> {
    NSDateFormatter *dateFormatter;
}
+ (id)sharedFormatter;
@end
#define JRLogDefaultFormatter NS(JRLogDefaultFormatter)

#ifdef  __cplusplus
    extern "C" {
#endif
    
BOOL                JRLogIsLevelActive(id self_, JRLogLevel level_);
    
void                JRLog(id self_, JRLogLevel level_, unsigned line_, const char *file_, const char *function_, NSString *format_, ...);
void                JRLogAssertionFailure(id self_, unsigned line_, const char *file_, const char *function_, const char *condition_, NSString *format_, ...);
    
JRLogLevel          JRLogGetDefaultLevel();
void                JRLogSetDefaultLevel(JRLogLevel level_);
        
JRLogLevel          JRLogGetClassLevel(Class class_);
void                JRLogSetClassLevel(Class class_, JRLogLevel level_);

id<JRLogLogger>     JRLogGetLogger();
void                JRLogSetLogger(id<JRLogLogger> logger_);

id<JRLogFormatter>  JRLogGetFormatter();
void                JRLogSetFormatter(id<JRLogFormatter> formatter_);

#ifdef  __cplusplus
    }
#endif

#define JRLOG_CONDITIONALLY(sender, LEVEL, format, ...) \
    do{ \
        if (JRLogIsLevelActive(sender, LEVEL)){ \
            JRLog(sender, LEVEL, __LINE__, __FILE__, __PRETTY_FUNCTION__, (format), ##__VA_ARGS__); \
        } \
    }while(0)

#define JRLOGASSERT_CONDITIONALLY(sender, condition, format, ...) \
    do { \
        if (JRLogIsLevelActive(sender, JRLogLevel_Assert) && !(condition)) { \
            JRLogAssertionFailure(sender, __LINE__, __FILE__, __PRETTY_FUNCTION__, #condition, (format), ##__VA_ARGS__); \
        } \
    }while(0);

#if JRLogOverrideNSLog
    id self;
    #define NSLog JRLogInfo
#endif

//
//  Scary macros!
//  The 1st #if is a filter, which you can read "IF any of the symbols are defined, THEN don't log for that level, ELSE log for that level."
//

#if defined(JRLOGLEVEL_OFF) || defined(JRLOGLEVEL_FATAL) || defined(JRLOGLEVEL_ASSERT) || defined(JRLOGLEVEL_ERROR) || defined(JRLOGLEVEL_WARN) || defined(JRLOGLEVEL_INFO)
    #define JRLogDebug(format,...)
    #define JRCLogDebug(format,...)
#else
    #define JRLogDebug(format,...)              JRLOG_CONDITIONALLY(self, JRLogLevel_Debug, format, ##__VA_ARGS__)
    #define JRCLogDebug(format,...)             JRLOG_CONDITIONALLY(nil, JRLogLevel_Debug, format, ##__VA_ARGS__)
#endif

#if defined(JRLOGLEVEL_OFF) || defined(JRLOGLEVEL_FATAL) || defined(JRLOGLEVEL_ASSERT) || defined(JRLOGLEVEL_ERROR) || defined(JRLOGLEVEL_WARN)
    #define JRLogInfo(format,...)
    #define JRCLogInfo(format,...)
#else
    #define JRLogInfo(format,...)               JRLOG_CONDITIONALLY(self, JRLogLevel_Info, format, ##__VA_ARGS__)
    #define JRCLogInfo(format,...)              JRLOG_CONDITIONALLY(nil, JRLogLevel_Info, format, ##__VA_ARGS__)
#endif

#if defined(JRLOGLEVEL_OFF) || defined(JRLOGLEVEL_FATAL) || defined(JRLOGLEVEL_ASSERT) || defined(JRLOGLEVEL_ERROR)
    #define JRLogWarn(format,...)
    #define JRCLogWarn(format,...)
#else
    #define JRLogWarn(format,...)               JRLOG_CONDITIONALLY(self, JRLogLevel_Warn, format, ##__VA_ARGS__)
    #define JRCLogWarn(format,...)              JRLOG_CONDITIONALLY(nil, JRLogLevel_Warn, format, ##__VA_ARGS__)
#endif

#if defined(JRLOGLEVEL_OFF) || defined(JRLOGLEVEL_FATAL) || defined(JRLOGLEVEL_ASSERT)
    #define JRLogError(format,...)
    #define JRCLogError(format,...)
#else
    #define JRLogError(format,...)              JRLOG_CONDITIONALLY(self, JRLogLevel_Error, format, ##__VA_ARGS__)
    #define JRCLogError(format,...)             JRLOG_CONDITIONALLY(nil, JRLogLevel_Error, format, ##__VA_ARGS__)
#endif

#if defined(JRLOGLEVEL_OFF) || defined(JRLOGLEVEL_FATAL)
    #define JRLogAssert(condition)
    #define JRCLogAssert(condition,format,...)
#else
    #define JRLogAssert(condition,format,...)   JRLOGASSERT_CONDITIONALLY(self, condition, format, ##__VA_ARGS__)
    #define JRCLogAssert(condition,format,...)  JRLOGASSERT_CONDITIONALLY(nil, condition, format, ##__VA_ARGS__)
#endif

#if defined(JRLOGLEVEL_OFF)
    #define JRLogFatal(format,...)
    #define JRCLogFatal(format,...)
#else
    #define JRLogFatal(format,...)              JRLOG_CONDITIONALLY(self, JRLogLevel_Fatal, format, ##__VA_ARGS__)
    #define JCRLogFatal(format,...)             JRLOG_CONDITIONALLY(nil, JRLogLevel_Fatal, format, ##__VA_ARGS__)
#endif


#define JRLogNSError(ERROR) if(ERROR){JRLogError(@"%@ %@", ERROR, [ERROR userInfo]);}
