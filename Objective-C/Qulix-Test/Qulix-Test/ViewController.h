//
//  ViewController.h
//  Qulix-Test
//
//  Created by Андрей Трофимов on 24.11.16.
//  Copyright © 2016 Андрей Трофимов. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ATInformationAnalysis;

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton* resultButton;

@property (strong, nonatomic) ATInformationAnalysis* informationAnalysis;

- (IBAction)actionStartAnalysis:(UIButton *)sender;

@end

