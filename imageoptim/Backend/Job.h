//
//  File.h
//
//  Created by porneL on 8.wrz.07.
//

@import Cocoa;
#import "Workers/Worker.h"

@class ResultsDb, File, TempFile;

@class ImageProcessor;

@class ImageProcessor;

@class ImageProcessor;

NS_ASSUME_NONNULL_BEGIN
@interface Job : NSObject {
    NSURL *filePath;
    NSString *displayName;

    NSString *bestToolName;
    NSMutableDictionary *bestTools;

    NSString *statusImageName;
    NSString *statusText;
    NSInteger statusOrder;

    NSMutableArray *workers;
    NSMutableDictionary *workersPreviousResults;

    NSOperationQueue *fileIOQueue;
    ResultsDb *db;
    uint32_t settingsHash[4];
    uint32_t inputFileHash[4];

    NSInteger targetWidth;
    NSInteger targetHeight;
    NSInteger resizeMode;
    NSInteger outputFormat;
    CGFloat outputQuality;

    NSInteger targetWidth;
    NSInteger targetHeight;
    NSInteger resizeMode;
    NSInteger outputFormat;
    CGFloat outputQuality;

    NSInteger targetWidth;
    NSInteger targetHeight;
    NSInteger resizeMode;
    NSInteger outputFormat;
    CGFloat outputQuality;

    BOOL stopping, lossyConverted;
}

- (BOOL)isBusy;
- (BOOL)isStoppable;
- (BOOL)isOptimized;

- (BOOL)stop;
- (BOOL)revert;

- (NSURL *)previewItemURL;
- (NSString *)previewItemTitle;

@property (readonly) BOOL canRevert;
@property (readonly) BOOL isDone, isFailed;

- (void)enqueueWorkersInCPUQueue:(NSOperationQueue *)queue fileIOQueue:(NSOperationQueue *)fileIOQueue serialQueue:(dispatch_queue_t)serialQueue defaults:(NSUserDefaults *)defaults;

- (BOOL)setFileOptimized:(nullable TempFile *)f toolName:(NSString *)s;

- (nullable instancetype)initWithFilePath:(NSURL *)aPath resultsDatabase:(nullable ResultsDb *)aDb;
- (void)updateStatusOfWorker:(nullable Worker *)currentWorker running:(BOOL)started;

- (void)setFilePath:(NSURL *)s;

@property (readonly, nullable) File *initialInput, *unoptimizedInput, *wipInput, *savedOutput, *revertFile;
@property (readonly, copy) NSString *fileName;

@property (strong, nullable) NSString *statusText, *bestToolName;
@property (strong) NSString *displayName;
@property (strong, nonatomic) NSURL *filePath;
@property (strong) NSString *statusImageName;
@property (readonly, nonatomic) NSNumber *byteSizeOriginal;
@property (readonly, nonatomic) NSNumber *byteSizeOptimized;
@property (readonly, nonatomic) NSNumber *percentOptimized;
@property (assign, readonly) NSInteger statusOrder;
@property (strong, readonly) NSMutableDictionary *workersPreviousResults;

@property (assign) NSInteger targetWidth;
@property (assign) NSInteger targetHeight;
@property (assign) NSInteger resizeMode;
@property (assign) NSInteger outputFormat;
@property (assign) CGFloat outputQuality;

@property (assign) NSInteger targetWidth;
@property (assign) NSInteger targetHeight;
@property (assign) NSInteger resizeMode;
@property (assign) NSInteger outputFormat;
@property (assign) CGFloat outputQuality;

@property (assign) NSInteger targetWidth;
@property (assign) NSInteger targetHeight;
@property (assign) NSInteger resizeMode;
@property (assign) NSInteger outputFormat;
@property (assign) CGFloat outputQuality;

- (void)setStatus:(NSString *)name order:(NSInteger)order text:(NSString *)text;
- (void)setError:(NSString *)text;
- (void)cleanup;

- (void)doEnqueueWorkersInCPUQueue:(NSOperationQueue *)queue serialQueue:(dispatch_queue_t)serialQueue defaults:(NSUserDefaults *)defaults;
@end
NS_ASSUME_NONNULL_END
