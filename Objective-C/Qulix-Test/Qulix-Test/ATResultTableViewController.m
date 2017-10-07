//
//  ATResultTableViewController.m
//  Qulix-Test
//
//  Created by Андрей Трофимов on 25.11.16.
//  Copyright © 2016 Андрей Трофимов. All rights reserved.
//

#import "ATResultTableViewController.h"
#import "ATBaseCellTableViewCell.h"
#import "ViewController.h"

#define count_sections 2
#define height_generalCell 186
#define height_occurrencesCell 236

//идентифаеры для наших кастомных ячеек
static NSString* const generalCellIdentifier = @"generalStatisticCell";
static NSString* const occurrencesCellIdentifier = @"occurrencesStatisticsCell";

@interface ATResultTableViewController ()

@property (strong, nonatomic) NSOperation* currentOperation; //NS операция для поиска
@property (strong, nonatomic) NSArray* filterWords; //массив найденых элементов

@property (assign, nonatomic) BOOL isFilter;

@end

@implementation ATResultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //вытягиваем из контроллера результаты частотного анализа
    ViewController* mainViewController = [self.navigationController.viewControllers firstObject];
    self.informationAnalysis = mainViewController.informationAnalysis;
    
    self.filterWords = [NSArray arrayWithArray:self.informationAnalysis.sortedKeys];
    
    self.isFilter = NO;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

//метод выполняющий поиск в таблице по словам
- (void) generateInBackgroundFromArray:(NSArray*)array andWithFilter:(NSString*)filter {
    //если у нас проводился поиск по одной строке, а потом она изменилась
    //то дальше поиск по старой строке нет смысла проводить
    //отменяем операцию
    [self.currentOperation cancel];
    
    //создаем слабую ссылку на наш контроллер, для блока
    __weak ATResultTableViewController* weakATResultController = self;
    
    //формируем нашу NS операцию
    self.currentOperation = [NSBlockOperation blockOperationWithBlock:^{
        //фильтруем таблицу по словам
        NSArray* filterWords = [weakATResultController generateWordsWithArray:array andWithFilter:filter];
        
        //выполняем апдейт таблице в потоке
        dispatch_async(dispatch_get_main_queue(), ^{
            weakATResultController.informationAnalysis.sortedKeys = filterWords;
            [weakATResultController.tableView reloadData];
            
            self.currentOperation = nil;
        });
    }];
    
    //запускаем NS операцию
    [self.currentOperation start];
}

//фильтруем таблице
- (NSArray*) generateWordsWithArray:(NSArray*)array andWithFilter:(NSString*)filter {
    NSMutableArray* sectionArray = [NSMutableArray array];
    
    //если в строке поиска что-то есть
    if (filter) {
        filter = [filter lowercaseString];
        self.isFilter = YES;
    } else {
        self.isFilter = NO;
    }
    
    //проверям соответсвует ли слово нашему запросу по поиску
    for (NSString* string in array) {
        if (filter) {
            if ([string rangeOfString:filter].location == NSNotFound) {
                continue;
            }
        }
        
        //если соответствует, то добавляем данное слово
        [sectionArray addObject:string];
    }
    
    return sectionArray;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return count_sections - self.isFilter;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //если мы что-то ищем в таблице, то секцию с основной информацией не показываем
    if (section == 0 && !self.isFilter)
        return 1;
    else
        return [self.informationAnalysis.sortedKeys count];
}

//название секций
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0 && !self.isFilter)
        return @"Общая статистика";
    else
        return @"Статистика вхождений";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ATBaseCellTableViewCell *cell;
    
    //переиспользуем ячейки
    if (indexPath.section == 0 && !self.isFilter) {
        cell = [tableView dequeueReusableCellWithIdentifier:generalCellIdentifier];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:occurrencesCellIdentifier];
    }
    
    //заполняем информацию в ячейках и добавляем его на таблицу
    cell.indexPath = indexPath;
    [cell setObjectInformationAnalysis:self.informationAnalysis];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//устанавливаем высоту ячеек
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && !self.isFilter) {
        return height_generalCell;
    } else {
        return height_occurrencesCell;
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

//фильтруем таблицу по вводу новых символов в строку поиска
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText length] > 0) {
        [self generateInBackgroundFromArray:self.filterWords
                              andWithFilter:searchText];
    } else {
        [self generateInBackgroundFromArray:self.filterWords
                              andWithFilter:nil];
    }
}

//убираем клавиатуру
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

@end
