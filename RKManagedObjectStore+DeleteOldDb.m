//
//  RKManagedObjectStore+DeleteOldDb.m
//  MHDClinicians
//
//  Created by Caleb Madrigal on 2/22/12.
//  Copyright (c) 2012 SpiderLogic. All rights reserved.
//

#import "RKManagedObjectStore+DeleteOldDb.h"

@implementation RKManagedObjectStore (DeleteOldDb)

- (void)deleteOldDb:(NSURL *)dbURL {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    [fileManager removeItemAtURL:dbURL error:&error];
}

- (void)createPersistentStoreCoordinator {
	NSURL *storeUrl = [NSURL fileURLWithPath:self.pathToStoreFile];
    
	NSError *error;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
	
	// Allow inferred migration from the original version of the application.
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
							 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
							 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
	
	if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
		if (self.delegate != nil && [self.delegate respondsToSelector:@selector(managedObjectStore:didFailToCreatePersistentStoreCoordinatorWithError:)]) {
			[self.delegate managedObjectStore:self didFailToCreatePersistentStoreCoordinatorWithError:error];
		} else {
            [self deleteOldDb:storeUrl];
            if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
                NSAssert(NO, @"Managed object store failed to create persistent store coordinator (even after attempted delete): %@", error);
            }
        }
    }
}

@end
