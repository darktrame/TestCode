//
//  ATXMLParser.m
//  BalinaSoft
//
//  Created by Андрей Трофимов on 2/13/17.
//  Copyright © 2017 Андрей Трофимов. All rights reserved.
//

#import "ATXMLParser.h"
#import "ATDataManager.h"

@interface ATXMLParser ()

@property (strong, nonatomic) NSXMLParser* parser;
@property (strong, nonatomic) NSString* element;
@property (strong, nonatomic) NSString* foundCharacter;

@property (assign, nonatomic) NSInteger numberRow;
@property (assign, nonatomic) NSInteger numberRowOffer;

@property (strong, nonatomic) NSManagedObject* objectCategories;
@property (strong, nonatomic) NSManagedObject* objectOffer;

@property (strong, nonatomic) NSMutableDictionary* elementsXML;
@property (strong, nonatomic) NSString* objectPars;

@end

@implementation ATXMLParser

+ (ATXMLParser*) sharedXMLParser {
    static dispatch_once_t onceToken;
    static ATXMLParser* sharedATXMLParser = nil;
    dispatch_once(&onceToken, ^{
        sharedATXMLParser = [[ATXMLParser alloc] init];
    });
    
    return sharedATXMLParser;
}

- (NSURL*)sharedXMLFile {
    static dispatch_once_t onceToken;
    static NSURL* xmlPath = nil;
    dispatch_once(&onceToken, ^{
        xmlPath = [[NSURL alloc] initWithString:@"http://ufa.farfor.ru/getyml/?key=ukAXxeJYZN"];
    });
    
    return xmlPath;
}

- (void)parserXMLFile {
    self.parser = [[NSXMLParser alloc] initWithContentsOfURL:[self sharedXMLFile]];
    self.parser.delegate = self;

    self.numberRow = 0;
    self.numberRowOffer = 0;
    
    self.elementsXML = [NSMutableDictionary dictionary];
    
    [self.parser parse];
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(nullable NSString *)namespaceURI
 qualifiedName:(nullable NSString *)qName
    attributes:(NSDictionary<NSString *, NSString *> *)attributeDict {

    self.element = elementName;
    
    if ([elementName isEqualToString:@"categories"])
        self.objectPars = @"categories";
    else {
        if ([elementName isEqualToString:@"offers"])
            self.objectPars = @"offers";
    }
    
    if ([elementName isEqualToString:@"category"]) {
        self.objectCategories = [NSEntityDescription insertNewObjectForEntityForName:@"ATCategories"
                                                              inManagedObjectContext:[[ATDataManager sharedManager]managedObjectContext]];
        
        NSString* idCatStr = [attributeDict valueForKey:@"id"];
        NSNumber* idCategories = [NSNumber numberWithInteger:[idCatStr integerValue]];
        
        [self.objectCategories setValue:idCategories
                                 forKey:@"id_categories"];
        
        [self.objectCategories setValue:[NSNumber numberWithInteger:self.numberRow]
                                 forKey:@"id_row"];
    } else {
        if ([elementName isEqualToString:@"offer"]) {
            self.objectOffer = [NSEntityDescription insertNewObjectForEntityForName:@"ATOffer"
                                                             inManagedObjectContext:[[ATDataManager sharedManager]managedObjectContext]];
            
            NSString* idOfferStr = [attributeDict valueForKey:@"id"];
            NSNumber* idOffer = [NSNumber numberWithInteger:[idOfferStr integerValue]];
            
            [self.objectOffer setValue:idOffer
                                forKey:@"id_offer"];
            
            [self.objectOffer setValue:[NSNumber numberWithInteger:self.numberRowOffer]
                                forKey:@"id_row"];
        } else {
            if ([elementName isEqualToString:@"param"]) {
                NSString* param = [attributeDict valueForKey:@"name"];
                if ([param isEqualToString:@"Вес"])
                    self.element = @"weight";
            }
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:
                               [NSCharacterSet characterSetWithCharactersInString:@" \n"]];
    
    if ([trimmedString length] > 0) {
        self.foundCharacter = string;
        
        if ([self.objectPars isEqualToString:@"offers"]) {
            ((void (^)())@{
                           @"name": ^{
                [self.elementsXML setValue:string
                                    forKey:@"name"];
            },
                           @"price": ^{
                NSNumber* price = [NSNumber numberWithFloat:[string floatValue]];
                [self.elementsXML setValue:price
                                    forKey:@"price"];
            },
                           @"description": ^{
                [self.elementsXML setValue:string
                                    forKey:@"description"];
            },
                           @"picture": ^{
                [self.elementsXML setValue:string
                                    forKey:@"picture"];
            },
                           @"categoryId": ^{
                NSNumber* categoryId = [NSNumber numberWithInt:[string intValue]];
                [self.elementsXML setValue:categoryId
                                    forKey:@"categoryId"];
            },
                           @"weight": ^{
                if ([string floatValue] > 0) {
                    [self.elementsXML setValue:string
                                        forKey:@"weight"];
                }
            },
                           }[self.element] ?: ^{})();
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(nullable NSString *)namespaceURI
 qualifiedName:(nullable NSString *)qName {
    if ([elementName isEqualToString:@"category"]) {
        [self.objectCategories setValue:self.foundCharacter forKey:@"name"];

        self.numberRow++;
    } else {
        if ([elementName isEqualToString:@"offer"]) {
            NSNumber* offerPrice = [self.elementsXML valueForKey:@"price"];
            NSNumber* idCategory = [self.elementsXML valueForKey:@"categoryId"];
            
            NSString* weight = [self.elementsXML valueForKey:@"weight"];
            
            if (weight)
                weight = [NSString stringWithFormat:@"%@ гр.", weight];

            [self.objectOffer setValue:idCategory
                                forKey:@"categoryId"];
            
            [self.objectOffer setValue:[self.elementsXML valueForKey:@"description"]
                                forKey:@"description_offer"];
            
            [self.objectOffer setValue:[self.elementsXML valueForKey:@"name"]
                                forKey:@"name"];
            
            [self.objectOffer setValue:[self.elementsXML valueForKey:@"picture"]
                                forKey:@"picture_path"];
            
            [self.objectOffer setValue:offerPrice
                                forKey:@"price"];
            
            [self.objectOffer setValue:weight
                                forKey:@"weight"];
            
            [self.elementsXML removeAllObjects];
            
            self.numberRowOffer++;
        }
    }
}

@end
