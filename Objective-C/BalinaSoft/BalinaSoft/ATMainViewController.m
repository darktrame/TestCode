//
//  ATMainViewController.m
//  BalinaSoft
//
//  Created by Андрей Трофимов on 2/11/17.
//  Copyright © 2017 Андрей Трофимов. All rights reserved.
//

#import "ATMainViewController.h"
#import "SWRevealViewController.h"
#import "ATXMLParser.h"
#import "ATCategoryViewController.h"
#import "ATDataManager.h"

@interface ATMainViewController ()

@property (strong, nonatomic) NSDictionary* categoryImagesArray;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@property (assign, nonatomic) BOOL checkConnect;

@end

@implementation ATMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.activity setHidden:NO];
    [self.activity startAnimating];
    
    self.checkConnect = NO;
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController){
        [self.revealButtonItem setTarget:self.revealViewController];
        [self.revealButtonItem setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.categoryImagesArray = @{
                                 @"Патимейкер" : @"potime.png",
                                 @"Пицца" : @"pizza.png",
                                 @"Сеты" : @"sets.png",
                                 @"Роллы" : @"roll.png",
                                 @"Добавки" : @"dobavki.png",
                                 @"Закуски" : @"zakus.png",
                                 @"Десерты" : @"desert.png",
                                 @"Напитки" : @"drink.png",
                                 @"Шашлыки" : @"saslik.png",
                                 @"Лапша" : @"lap.png",
                                 @"Супы" : @"sup.png",
                                 @"Салаты" : @"salat.png",
                                 @"Теплое" : @"hot.png",
                                 @"Комбо" : @"combo.png",
                                 @"Суши" : @"sushi.png"};
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *urlString = @"http://www.google.com/";
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:urlString]
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                                                if (statusCode == 200) {
                                                    [[ATDataManager sharedManager] removeAll];
                                                    dispatch_queue_t queue = dispatch_queue_create("qwe", DISPATCH_QUEUE_CONCURRENT);
                                                    dispatch_async(queue, ^{
                                                        [[ATXMLParser sharedXMLParser] parserXMLFile];
                                                        [[[ATDataManager sharedManager] managedObjectContext] save:nil];
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            [self.activity stopAnimating];
                                                            [self.activity setHidden:YES];
                                                            
                                                            self.checkConnect = YES;
                                                            [[ATXMLParser sharedXMLParser] setConnectUnverified:@"YES"];
                                                            
                                                            [self.collectionView reloadData];
                                                        });
                                                    });
                                                } else {
                                                    [self.activity setHidden:YES];
                                                    [self.activity stopAnimating];
                                                    
                                                    self.checkConnect = YES;
                                                    [[ATXMLParser sharedXMLParser] setConnectUnverified:@"NO"];
                                                    
                                                    [self.collectionView reloadData];
                                                }
                                            }];
        [task resume];
    });
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.checkConnect) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"ATCategories"
                                       inManagedObjectContext:[[ATDataManager sharedManager] managedObjectContext]]];
        
        [request setIncludesSubentities:NO];

        return [[[ATDataManager sharedManager] managedObjectContext] countForFetchRequest:request
                                                                                    error:nil];
    } else {
        return 0;
    }
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"ATCategories"];
    NSPredicate* idPredicate = [NSPredicate predicateWithFormat:
                                    @"id_row == %d", indexPath.row];
    
    [request setPredicate:idPredicate];
    
    NSArray* array = [[[ATDataManager sharedManager] managedObjectContext] executeFetchRequest:request
                                                                                         error:nil];
    
    NSManagedObject* currentObject = [array firstObject];
    
    static NSString* identifier = @"cell";
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier
                                                                           forIndexPath:indexPath];
    UIImageView* imageView = (UIImageView*)[cell viewWithTag:100];
    imageView.image = [UIImage imageNamed:[self.categoryImagesArray valueForKey:[currentObject valueForKey:@"name"]]];
    
    UILabel* nameLabel = (UILabel*)[cell viewWithTag:101];
    
    nameLabel.text = [currentObject valueForKey:@"name"];
    
    NSNumber* number = [currentObject valueForKey:@"id_categories"];
    
    cell.tag = [number integerValue];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ATCategoryViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"10"];
    
    vc.category = [[collectionView cellForItemAtIndexPath:indexPath] tag];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
