#import "SDAsyncLoop.h"

SDLoopableTask SDCreateAsyncLoop(NSEnumerator *collectionEnum, void(^actionBlock)(id obj, dispatch_block_t iterateBlock, dispatch_block_t optionalDoneBlock)) {
	SDLoopableTask *task = malloc(sizeof(SDLoopableTask));
	*task = Block_copy(^(dispatch_block_t doneBlock) {
		id nextObj = [collectionEnum nextObject];
		if (nextObj) {
			if (actionBlock)
				actionBlock(nextObj, ^{ (*task)(doneBlock); }, doneBlock);
		}
		else {
			if (doneBlock)
				doneBlock();
			Block_release(*task);
			free(task);
		}
	});
	return *task;
}


void SDExecuteInOrder(NSArray *tasks) {
	NSEnumerator *tasksEnum = [tasks objectEnumerator];
	
	dispatch_block_t *wrapperForTask = malloc(sizeof(dispatch_block_t));
	*wrapperForTask = Block_copy(^() {
		void(^task)(dispatch_block_t doneBlock) = [tasksEnum nextObject];
		if (task)
			task(*wrapperForTask);
		else {
			Block_release(*wrapperForTask);
			free(wrapperForTask);
		}
	});
	
	(*wrapperForTask)();
}
