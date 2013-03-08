//// clang -lobjc -framework Cocoa SDAsyncLoop.m example.m
//
//#import <Cocoa/Cocoa.h>
//#import "SDAsyncLoop.h"
//
//int main() {
//	[NSAutoreleasePool new];
//	
//	NSArray *collection1 = [@"1,2,3,4,5,6,7" componentsSeparatedByString:@","];
//	SDLoopableTask task1 = SDCreateAsyncLoop([collection1 objectEnumerator], ^(NSString *substr, dispatch_block_t nextIteration, dispatch_block_t doneBlock) {
//		NSLog(@"the number = [%@]", substr);
//		nextIteration();
//	});
//	
//	NSArray *collection2 = [@"a,b,c,d,e,f,g" componentsSeparatedByString:@","];
//	SDLoopableTask task2 = SDCreateAsyncLoop([collection2 objectEnumerator], ^(NSString *substr, dispatch_block_t nextIteration, dispatch_block_t doneBlock) {
//		NSLog(@"the letter = [%@]", substr);
//		nextIteration();
//	});
//	
//	SDExecuteInOrder([NSArray arrayWithObjects:task1, ^(dispatch_block_t doneBlock) { NSLog(@"finished with first one"); if (doneBlock) doneBlock(); }, task2, ^(dispatch_block_t doneBlock) {
//		NSLog(@"ok done");
//		if (doneBlock)
//			doneBlock();
//	}, nil]);
//	
//	return 0;
//}

#import <Cocoa/Cocoa.h>

typedef void(^SDLoopableTask)(dispatch_block_t doneBlock);

SDLoopableTask SDCreateAsyncLoop(NSEnumerator *collectionEnum, void(^actionBlock)(id obj, dispatch_block_t iterateBlock, dispatch_block_t optionalDoneBlock));
void SDExecuteInOrder(NSArray *tasks);
