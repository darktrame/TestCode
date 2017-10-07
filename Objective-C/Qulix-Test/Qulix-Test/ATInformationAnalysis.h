//
//  ATInformationAnalysis.h
//  Qulix-Test
//
//  Created by Андрей Трофимов on 25.11.16.
//  Copyright © 2016 Андрей Трофимов. All rights reserved.
//

#import <Foundation/Foundation.h>

//модель данных проведенного частотного анализа
@interface ATInformationAnalysis : NSObject

@property (strong, nonatomic) NSMutableDictionary* wordsAndCountEntryInText;
@property (strong, nonatomic) NSArray* sortedKeys;
@property (strong, nonatomic) NSString* timeAnalysis;
@property (assign, nonatomic) NSInteger countString;

@end
