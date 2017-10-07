//
//  occurrencesStatisticTableViewCell.h
//  Qulix-Test
//
//  Created by Андрей Трофимов on 25.11.16.
//  Copyright © 2016 Андрей Трофимов. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATBaseCellTableViewCell.h"

//ячейчка для информации по каждому слову
@interface occurrencesStatisticTableViewCell : ATBaseCellTableViewCell

@property (weak, nonatomic) IBOutlet UILabel* numberWordLabel;
@property (weak, nonatomic) IBOutlet UILabel* wordLabel;
@property (weak, nonatomic) IBOutlet UILabel* countEntryWordLabel;
@property (weak, nonatomic) IBOutlet UILabel* percentageRatioLabel;

@end
