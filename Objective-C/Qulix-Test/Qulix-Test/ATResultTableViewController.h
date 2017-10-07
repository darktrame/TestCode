//
//  ATResultTableViewController.h
//  Qulix-Test
//
//  Created by Андрей Трофимов on 25.11.16.
//  Copyright © 2016 Андрей Трофимов. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ATInformationAnalysis;

//таблица для вывода результатов
@interface ATResultTableViewController : UITableViewController <UITableViewDataSource,
                                                                UITabBarDelegate,
                                                                UISearchBarDelegate>

@property (strong, nonatomic) ATInformationAnalysis *informationAnalysis;

@end
