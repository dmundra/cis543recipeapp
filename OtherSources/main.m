//
//  main.m
//  RecipeApp
//
//  Created by Charles Augustine on 11/18/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//


#ifdef DEBUG
#import "NSDebug.h"
#import "GTMStackTrace.h"


void exceptionHandler(NSException *exception) {
	NSLog(@"%@", GTMStackTraceFromException(exception));
}
#endif


int main(int argc, char *argv[]) {
#ifdef DEBUG
	NSLog(@"Debug enabled");
	NSDebugEnabled = YES;
	NSZombieEnabled = YES;
	NSDeallocateZombies = NO;
	NSHangOnUncaughtException = YES;
	[NSAutoreleasePool enableFreedObjectCheck:YES];
	NSSetUncaughtExceptionHandler(&exceptionHandler);
#endif
	
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}