//
//  ATBaseCellTableViewCell.m
//  Qulix-Test
//
//  Created by Андрей Трофимов on 25.11.16.
//  Copyright © 2016 Андрей Трофимов. All rights reserved.
//

#import "ATBaseCellTableViewCell.h"

@implementation ATBaseCellTableViewCell

- (void)setObjectInformationAnalysis:(ATInformationAnalysis*)object {
    _objectInformationAnalysis = object;
    
    [self showObject];
}

- (void)showObject {
    
}

@end
