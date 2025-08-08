#import "GetQueueCountCommand.h"
#import "BearHugController.h"
#import "FilesController.h"

@implementation GetQueueCountCommand

- (id)performDefaultImplementation {
    BearHugController *bearhug = (BearHugController *)[[NSApplication sharedApplication] delegate];

    return bearhug.filesController.queueCount;
}

@end
