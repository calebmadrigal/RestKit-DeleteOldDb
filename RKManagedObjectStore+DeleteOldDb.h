//
//  RKManagedObjectStore+DeleteOldDb.h
//  MHDClinicians
//
//  Created by Caleb Madrigal on 2/22/12.
//  Copyright (c) 2012 SpiderLogic. All rights reserved.
//

#import <RestKit/CoreData.h>

@interface RKManagedObjectStore (DeleteOldDb)
- (void)createPersistentStoreCoordinator;
@end
