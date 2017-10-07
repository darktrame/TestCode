//
//  ATGeneralStatisticTableViewCell.m
//  Qulix-Test
//
//  Created by Андрей Трофимов on 25.11.16.
//  Copyright © 2016 Андрей Трофимов. All rights reserved.
//

#import "ATGeneralStatisticTableViewCell.h"

@implementation ATGeneralStatisticTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

//метод для получания данных
- (ATInformationAnalysis*) getInformationAnalysis {
    return self.objectInformationAnalysis;
}

//устанавливаем значения в ячейку
- (void)showObject {
    ATInformationAnalysis* informationAnalysis = [self getInformationAnalysis];
    
    //общее время выполнения анализа
    self.countTimeLabel.text = informationAnalysis.timeAnalysis;
    //общее кол-во слов
    self.countWordsLabel.text = [NSString stringWithFormat:@"%lu",
                                 (unsigned long)[informationAnalysis.wordsAndCountEntryInText count]];
}

@end
