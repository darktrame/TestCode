//
//  ATCategoryViewController.m
//  BalinaSoft
//
//  Created by Андрей Трофимов on 2/13/17.
//  Copyright © 2017 Андрей Трофимов. All rights reserved.
//

#import "ATCategoryViewController.h"
#import "ATXMLParser.h"
#import "ATDetailOfferViewController.h"
#import "ATDataManager.h"

@interface ATCategoryViewController ()

@property (strong, nonatomic) NSArray* offersArray;

@end

@implementation ATCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([[[ATXMLParser sharedXMLParser] connectUnverified] isEqualToString:@"YES"]) {
        dispatch_queue_t queue = dispatch_queue_create("qwe", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(queue, ^{
            NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"ATOffer"];
            
            NSPredicate* idPredicate = [NSPredicate predicateWithFormat:
                                        @"categoryId == %ld", self.category];
            
            [request setPredicate:idPredicate];
            
            [request setIncludesSubentities:NO];
            
            NSArray* offers = [[[ATDataManager sharedManager] managedObjectContext] executeFetchRequest:request
                                                                                                  error:nil];
            
            for (NSManagedObject* currentObject in offers) {
                NSString* pathP = [currentObject valueForKey:@"picture_path"];
                NSURL* pathPicture;
                
                if (pathP)
                    pathPicture = [[NSURL alloc] initWithString:pathP];
                
                id checkNil = [currentObject valueForKey:@"picture"];
                
                if (!checkNil) {
                    UIImage* picture = [UIImage imageWithData:[NSData dataWithContentsOfURL:pathPicture]];
                    picture = [self imageWithImage:picture
                                     convertToSize:CGSizeMake(202, 160)];
                    
                    [currentObject setValue:UIImagePNGRepresentation(picture)
                                     forKey:@"picture"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.collectionView reloadData];
                        
                        [[[ATDataManager sharedManager] managedObjectContext] save:nil];
                    });
                }
            }
        });
    }
}

- (UIImage*)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return destImage;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"ATOffer"];
    
    NSPredicate* idPredicate = [NSPredicate predicateWithFormat:
                                @"categoryId == %ld", (long)self.category];
    
    [request setPredicate:idPredicate];

    [request setIncludesSubentities:NO];
    
    self.offersArray = [[[ATDataManager sharedManager] managedObjectContext] executeFetchRequest:request
                                                                                           error:nil];
    
    return [[[ATDataManager sharedManager] managedObjectContext] countForFetchRequest:request
                                                                                error:nil];
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject* currentObject = [self.offersArray objectAtIndex:indexPath.row];
    
    static NSString* identifier = @"cell";
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier
                                                                           forIndexPath:indexPath];
    UIImageView* imageView = (UIImageView*)[cell viewWithTag:100];
    
    imageView.image = [UIImage imageWithData:[currentObject valueForKey:@"picture"]];
    
    UILabel* nameLabel = (UILabel*)[cell viewWithTag:101];
    UILabel* weightLabel = (UILabel*)[cell viewWithTag:102];
    UILabel* priceLabel = (UILabel*)[cell viewWithTag:103];
    
    nameLabel.text = [currentObject valueForKey:@"name"];
    weightLabel.text = [currentObject valueForKey:@"weight"];
    
    NSNumber* priceNumber = [currentObject valueForKey:@"price"];
    
    priceLabel.text = [NSString stringWithFormat:@"%0.2f руб.", [priceNumber floatValue]];

    NSNumber* number = [currentObject valueForKey:@"id_offer"];
    
    cell.tag = [number integerValue];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ATDetailOfferViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"20"];
    vc.offerID = [[collectionView cellForItemAtIndexPath:indexPath] tag];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
