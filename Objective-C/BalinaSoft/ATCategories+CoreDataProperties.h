//
//  ATCategories+CoreDataProperties.h
//  BalinaSoft
//
//  Created by Андрей Трофимов on 2/17/17.
//  Copyright © 2017 Андрей Трофимов. All rights reserved.
//

#import "ATCategories+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ATCategories (CoreDataProperties)

+ (NSFetchRequest<ATCategories *> *)fetchRequest;

@property (nonatomic) int32_t id_row;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int32_t id_categories;

@end

NS_ASSUME_NONNULL_END
