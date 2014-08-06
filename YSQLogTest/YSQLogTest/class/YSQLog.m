//
//  YSQLog.m
//  YSQLogTest
//
//  Created by ysq on 14/8/6.
//  Copyright (c) 2014年 ysq. All rights reserved.
//

#import "YSQLog.h"

static void handleRootException( NSException* exception );//系统崩溃回调函数
static NSString *const LogDirectoryString = @"com.ysq.ysq.errorLog";

/**
 *  获取日志保存的文件夹路径
 *
 *  @return 路径
 */
static NSString *getLogDirectory();

/**
 *  获取日志需要保存的文件路径
 *
 *  @return 路径
 */
static NSString *getLogFilePath();

/**
 *  写入文件
 *
 *  @param logString 崩溃信息
 */
static void logToFile(NSString *logString);


/**
 *  上传崩溃文件到服务器
 */
static void uploadLogFile();
static void uploadLogFileWithPath(NSString *path);


void YSQLogInit()
{
    NSSetUncaughtExceptionHandler(handleRootException);
    uploadLogFile();
}


static void handleRootException( NSException* exception )
{
    NSString* name = [ exception name ];
    NSString* reason = [ exception reason ];
    NSArray* symbols = [ exception callStackSymbols ];
    NSMutableString* strSymbols = [ [ NSMutableString alloc ] init ];
    for ( NSString* item in symbols )
    {
        [ strSymbols appendString: item ];
        [ strSymbols appendString: @"\r\n" ];
    }
    
    NSString*   errorInfo = [NSString stringWithFormat:@" *** Terminating app due to uncaught exception %@ , reason: %@  \r\n  *** First throw call stack: \r\n(\r\n  %@\r\n)", name, reason, strSymbols];
    
    logToFile(errorInfo);
    
}


static NSString *getLogDirectory(){
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory =  [documentsDirectory stringByAppendingPathComponent:LogDirectoryString];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if ( !([fileManager fileExistsAtPath:documentsDirectory isDirectory:&isDir] && isDir ) ){
        [fileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return documentsDirectory;
}


static NSString *getLogFilePath(){
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *t = [NSString stringWithFormat:@"%@/error_%@.txt",getLogDirectory(),currentDateStr];
    
    return t;
}



static void logToFile(NSString *logString){
    
    FILE * file = NULL;
    file = fopen([getLogFilePath() UTF8String],"w");
    if (nil == file) {
        return;
    }
    
    const char*   ch = [logString UTF8String];
    int writeResult = fputs(ch, file);
    if (writeResult == EOF) {
#if DEBUG
        NSLog(@"log write file failed.");
#endif
    }
    fclose(file);
    file = NULL;
}


static void uploadLogFile(){
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray* array = [fileManager contentsOfDirectoryAtPath:getLogDirectory() error:nil];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_apply([array count], dispatch_get_global_queue(0, 0), ^(size_t i) {
            NSString *fullPath = [getLogDirectory() stringByAppendingPathComponent:[array objectAtIndex:i]];
            BOOL isDir;
            if ( !([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) ){
                uploadLogFileWithPath(fullPath);
            }
        });
    });
    
}

static void uploadLogFileWithPath(NSString *path){
    //read path file
    //server upload code
    
    //if success
    //    NSFileManager *fileManager = [NSFileManager defaultManager];
    //    [fileManager removeItemAtPath:path error:NULL];
    //
}