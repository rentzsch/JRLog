/*******************************************************************************
	JRLog.h
		Copyright (c) 2006-2010 Jonathan 'Wolf' Rentzsch: <http://rentzsch.com>
		Some rights reserved: <http://opensource.org/licenses/mit-license.php>

	***************************************************************************/

#import <Foundation/Foundation.h>

//	What you need to remember: Debug > Info > Warn > Error > Fatal.

typedef enum {
	JRLogLevel_UNSET,
    JRLogLevel_Debug,
    JRLogLevel_Info,
    JRLogLevel_Warn,
    JRLogLevel_Error,
    JRLogLevel_Fatal,
	JRLogLevel_Off,
} JRLogLevel;

@protocol JRLogLogger

- (void)logWithLevel:(JRLogLevel)callerLevel_
			instance:(NSString*)instance_
				file:(const char*)file_
				line:(unsigned)line_
			function:(const char*)function_
			 message:(NSString*)message_;

@end

@protocol JRLogFormatter

- (NSString*)formattedMessageWithLevel:(JRLogLevel)callerLevel_
                              instance:(NSString*)instance_
                                  file:(const char*)file_
                                  line:(unsigned)line_
                              function:(const char*)function_
                               message:(NSString*)message_;

@end

@interface NSObject (JRLogAdditions)
+ (JRLogLevel)classJRLogLevel;
+ (void)setClassJRLogLevel:(JRLogLevel)level_;

+ (JRLogLevel)defaultJRLogLevel;
+ (void)setDefaultJRLogLevel:(JRLogLevel)level_;

+ (void)setJRLogLogger: (id<JRLogLogger>) logger_;
+ (id<JRLogLogger>)JRLogLogger;
+ (id<JRLogLogger>)defaultJRLogLogger;

+ (void)setJRLogFormatter:(id<JRLogFormatter>)formatter_;
+ (id<JRLogFormatter>)JRLogFormatter;
+ (id<JRLogFormatter>)defaultJRLogFormatter;
@end

#ifdef  __cplusplus
extern "C" {
#endif
    
BOOL IsJRLogLevelActive(id self_, JRLogLevel level_);
void JRLog(id self_, JRLogLevel level_, unsigned line_, const char *file_, const char *function_, NSString *format_, ...);

#ifdef  __cplusplus
}
#endif

#define JRLOG_CONDITIONALLY(sender,LEVEL,format,...) \
	do{if(IsJRLogLevelActive(sender,LEVEL)){JRLog(sender,LEVEL,__LINE__,__FILE__,__PRETTY_FUNCTION__,(format),##__VA_ARGS__);}}while(0)

#if JRLogOverrideNSLog
id self;
#define NSLog	JRLogInfo
#endif

//
//	Scary macros!
//	The 1st #if is a filter, which you can read "IF any of the symbols are defined, THEN don't log for that level, ELSE log for that level."
//

#if defined(JRLOGLEVEL_OFF) || defined(JRLOGLEVEL_FATAL) || defined(JRLOGLEVEL_ERROR) || defined(JRLOGLEVEL_WARN) || defined(JRLOGLEVEL_INFO)
	#define JRLogDebug(format,...)
	#define JRCLogDebug(format,...)
#else
	#define JRLogDebug(format,...)		JRLOG_CONDITIONALLY(self, JRLogLevel_Debug, format, ##__VA_ARGS__)
	#define JRCLogDebug(format,...)		JRLOG_CONDITIONALLY(nil, JRLogLevel_Debug, format, ##__VA_ARGS__)
#endif

#if defined(JRLOGLEVEL_OFF) || defined(JRLOGLEVEL_FATAL) || defined(JRLOGLEVEL_ERROR) || defined(JRLOGLEVEL_WARN)
	#define JRLogInfo(format,...)
	#define JRCLogInfo(format,...)
#else
	#define JRLogInfo(format,...)		JRLOG_CONDITIONALLY(self, JRLogLevel_Info, format, ##__VA_ARGS__)
	#define JRCLogInfo(format,...)		JRLOG_CONDITIONALLY(nil, JRLogLevel_Info, format, ##__VA_ARGS__)
#endif

#if defined(JRLOGLEVEL_OFF) || defined(JRLOGLEVEL_FATAL) || defined(JRLOGLEVEL_ERROR)
	#define JRLogWarn(format,...)
	#define JRCLogWarn(format,...)
#else
	#define JRLogWarn(format,...)		JRLOG_CONDITIONALLY(self, JRLogLevel_Warn, format, ##__VA_ARGS__)
	#define JRCLogWarn(format,...)		JRLOG_CONDITIONALLY(nil, JRLogLevel_Warn, format, ##__VA_ARGS__)
#endif

#if defined(JRLOGLEVEL_OFF) || defined(JRLOGLEVEL_FATAL)
	#define JRLogError(format,...)
	#define JRCLogError(format,...)
#else
	#define JRLogError(format,...)		JRLOG_CONDITIONALLY(self, JRLogLevel_Error, format, ##__VA_ARGS__)
	#define JRCLogError(format,...)		JRLOG_CONDITIONALLY(nil, JRLogLevel_Error, format, ##__VA_ARGS__)
#endif

#if defined(JRLOGLEVEL_OFF)
	#define JRLogFatal(format,...)
	#define JRCLogFatal(format,...)
#else
	#define JRLogFatal(format,...)		JRLOG_CONDITIONALLY(self, JRLogLevel_Fatal, format, ##__VA_ARGS__)
	#define JCRLogFatal(format,...)		JRLOG_CONDITIONALLY(nil, JRLogLevel_Fatal, format, ##__VA_ARGS__)
#endif


#define JRLogNSError(ERROR) if(ERROR){JRLogError(@"%@ %@", ERROR, [ERROR userInfo]);}
