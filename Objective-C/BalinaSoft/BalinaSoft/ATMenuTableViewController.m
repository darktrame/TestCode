//
//  ATMenuTableViewController.m
//  BalinaSoft
//
//  Created by Андрей Трофимов on 2/11/17.
//  Copyright © 2017 Андрей Трофимов. All rights reserved.
//

#import "ATMenuTableViewController.h"

@interface ATMenuTableViewController ()
@end

@implementation ATMenuTableViewController

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
