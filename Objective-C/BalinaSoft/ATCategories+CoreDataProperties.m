//
//  ATCategories+CoreDataProperties.m
//  BalinaSoft
//
//  Created by Андрей Трофимов on 2/17/17.
//  Copyright © 2017 Андрей Трофимов. All rights reserved.
//

#import "ATCategories+CoreDataProperties.h"

@implementation ATCategories (CoreDataProperties)

+ (NSFetchRequest<ATCategories *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ATCategories"];
}

@dynamic id_row;
@dynamic name;
@dynamic id_categories;

@end
