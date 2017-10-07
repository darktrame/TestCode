//
//  occurrencesStatisticTableViewCell.m
//  Qulix-Test
//
//  Created by Андрей Трофимов on 25.11.16.
//  Copyright © 2016 Андрей Трофимов. All rights reserved.
//

#import "occurrencesStatisticTableViewCell.h"

@implementation occurrencesStatisticTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

//метод для получения данных
- (ATInformationAnalysis*) getInformationAnalysis {
    return self.objectInformationAnalysis;
}

- (void)showObject {
    ATInformationAnalysis* informationAnalysis = [self getInformationAnalysis];
    
    //номер слова в таблице
    self.numberWordLabel.text = [NSString stringWithFormat:@"%ld", self.indexPath.row + 1];
    
    NSString* word = [informationAnalysis.sortedKeys objectAtIndex:self.indexPath.row];
    
    //само слово
    self.wordLabel.text = word;
    
    //количество вхождений слова в текста
    NSNumber* countEntry = [informationAnalysis.wordsAndCountEntryInText valueForKey:word];
    self.countEntryWordLabel.text = [NSString stringWithFormat:@"%ld", (long)[countEntry integerValue]];
    
    //считаем процентное соотношение кол-во вхождений от общего числа строк
    CGFloat percentageRatio = (CGFloat)(((double)[countEntry integerValue] * 100) / (double)informationAnalysis.countString);
    self.percentageRatioLabel.text = [NSString stringWithFormat:@"%.3f", percentageRatio];
}

@end
