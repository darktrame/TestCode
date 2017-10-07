//
//  ATBaseCellTableViewCell.h
//  Qulix-Test
//
//  Created by Андрей Трофимов on 25.11.16.
//  Copyright © 2016 Андрей Трофимов. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATInformationAnalysis.h"

//базовая ячейка, от которой будут наследоваться наши кастомные ячейки
@interface ATBaseCellTableViewCell : UITableViewCell

@property (strong, nonatomic) ATInformationAnalysis* objectInformationAnalysis;
@property (strong, nonatomic) NSIndexPath *indexPath;

//этот метод будем перегружать для каждой кастомной ячейки
- (void) showObject;

@end
