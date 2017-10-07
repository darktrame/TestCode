//
//  ATGeneralStatisticTableViewCell.h
//  Qulix-Test
//
//  Created by Андрей Трофимов on 25.11.16.
//  Copyright © 2016 Андрей Трофимов. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATBaseCellTableViewCell.h"

//ячейка для общей статистики
@interface ATGeneralStatisticTableViewCell : ATBaseCellTableViewCell

@property (weak, nonatomic) IBOutlet UILabel* countTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel* countWordsLabel;

@end
