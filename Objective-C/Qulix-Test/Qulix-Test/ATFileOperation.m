//
//  ATFileOperation.m
//  Qulix-Test
//
//  Created by Андрей Трофимов on 24.11.16.
//  Copyright © 2016 Андрей Трофимов. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATFileOperation.h"

@implementation ATFileOperation

//метод считывания всего текста
- (NSString*) readFromFIle {
    NSString* pathInFile = [[NSBundle mainBundle] pathForResource:self.fileName
                                                           ofType:nil];
    NSError* errorReadInFile;
    NSString* textInFile = [NSString stringWithContentsOfFile:pathInFile
                                                     encoding:NSUTF8StringEncoding
                                                        error:&errorReadInFile];
    
    if (errorReadInFile) {
        NSLog(@"%@", [errorReadInFile description]);
    }
    
    return textInFile;
}

@end
