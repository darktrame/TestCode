//
//  ATDetailOfferViewController.m
//  BalinaSoft
//
//  Created by Андрей Трофимов on 2/13/17.
//  Copyright © 2017 Андрей Трофимов. All rights reserved.
//

#import "ATDetailOfferViewController.h"
#import "ATDataManager.h"

@interface ATDetailOfferViewController ()

@end

@implementation ATDetailOfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"ATOffer"];
    NSPredicate* idPredicate = [NSPredicate predicateWithFormat:
                                @"id_offer == %ld", self.offerID];
    
    [request setPredicate:idPredicate];
    
    NSArray* array = [[[ATDataManager sharedManager] managedObjectContext] executeFetchRequest:request
                                                                                         error:nil];
    
    NSManagedObject* currentObject = [array firstObject];
    
    self.image.image = [UIImage imageWithData:[currentObject valueForKey:@"picture"]];

    self.nameLabel.text = [currentObject valueForKey:@"name"];
    self.weightLabel.text = [currentObject valueForKey:@"weight"];
    
    NSNumber* price = [currentObject valueForKey:@"price"];
    
    self.priceLabel.text = [NSString stringWithFormat:@"%0.2f руб.", [price floatValue]];
    
    self.descriptionLabel.text = [currentObject valueForKey:@"description_offer"];
}

@end
