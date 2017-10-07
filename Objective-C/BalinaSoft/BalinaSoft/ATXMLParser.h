//
//  ATXMLParser.h
//  BalinaSoft
//
//  Created by Андрей Трофимов on 2/13/17.
//  Copyright © 2017 Андрей Трофимов. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ATXMLParser : NSObject <NSXMLParserDelegate>

@property (strong, nonatomic) NSString* connectUnverified;

- (void)parserXMLFile;

+ (ATXMLParser*) sharedXMLParser;

@end
