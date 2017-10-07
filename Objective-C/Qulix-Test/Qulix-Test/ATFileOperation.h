//
//  ATFileOperation.h
//  Qulix-Test
//
//  Created by Андрей Трофимов on 24.11.16.
//  Copyright © 2016 Андрей Трофимов. All rights reserved.
//

#import <Foundation/Foundation.h>

//модель для работы с файлом
@interface ATFileOperation : NSObject

@property (strong, nonatomic) NSFileManager* fileManager;
@property (strong, nonatomic) NSString* fileName;

- (NSString*) readFromFIle;

@end
