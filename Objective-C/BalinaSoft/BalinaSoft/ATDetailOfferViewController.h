//
//  ATDetailOfferViewController.h
//  BalinaSoft
//
//  Created by Андрей Трофимов on 2/13/17.
//  Copyright © 2017 Андрей Трофимов. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATDetailOfferViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (assign, nonatomic) NSInteger offerID;

@end
