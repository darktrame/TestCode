//
//  ATDataManager.h
//  BSTrofimov
//
//  Created by Андрей Трофимов on 2/17/17.
//  Copyright © 2017 Андрей Трофимов. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ATDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (void)removeAll;

- (NSURL *)applicationDocumentsDirectory;

+ (ATDataManager*) sharedManager;

@end
