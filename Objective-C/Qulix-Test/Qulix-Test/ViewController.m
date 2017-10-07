//
//  ViewController.m
//  Qulix-Test
//
//  Created by Андрей Трофимов on 24.11.16.
//  Copyright © 2016 Андрей Трофимов. All rights reserved.
//

#import "ViewController.h"
#import "ATFileOperation.h"
#import "ATInformationAnalysis.h"
#import "ATResultTableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.resultButton setHidden:YES];
    
    self.informationAnalysis = [[ATInformationAnalysis alloc] init];
}

#pragma mark - Methods

//Метод разбиения текста на слова
- (NSArray*) separatedString:(NSString*)string ByCharactersInSet:(NSCharacterSet*) characterSet {
    NSArray* separatedTextInWords = [string componentsSeparatedByCharactersInSet:characterSet];
    
    //фильтруем пустые строки
    separatedTextInWords = [separatedTextInWords filteredArrayUsingPredicate:
                            [NSPredicate predicateWithFormat:@"length > 0"]];
    
    //получаем кол-во строк для посчета %
    self.informationAnalysis.countString = [separatedTextInWords count];
    
    NSMutableArray* wordsInText = [NSMutableArray array];
    NSCharacterSet* separatedSet = [NSCharacterSet characterSetWithCharactersInString:@" .,:;\r\n"];
    for (NSString* string in separatedTextInWords) {
        NSArray* wordsInString = [string componentsSeparatedByString:@" "];
        
        for (NSString* word in wordsInString) {
            if (word.length > 1) {
                //проверям, содержит ли последовательность символов необходимые символы
                //проверка от второго до предпоследнего символа
                //потому что например the; является словом, а t;he - нет
                NSRange rangeInWord = NSMakeRange(1, word.length - 2);
                
                NSRange findPinctuationInWordRange = [word rangeOfCharacterFromSet:separatedSet
                                                                           options:NSCaseInsensitiveSearch
                                                                             range:rangeInWord];
                
                //если содержит, то пропускаем слово
                //например http:\\www.....
                if (findPinctuationInWordRange.location != NSNotFound) {
                    continue;
                } else {
                    //если нет, то оставляем слово
                    [wordsInText addObject:word];
                }
            } else {
                //проверка на придлоги
                if (word.length != 0) {
                    NSRange findPinctuationInWordRange = [word rangeOfCharacterFromSet:separatedSet
                                                                               options:NSCaseInsensitiveSearch];
                    
                    if (findPinctuationInWordRange.location != NSNotFound) {
                        continue;
                    } else {
                        [wordsInText addObject:word];
                    }
                }
            }
        }
    }

    /*Соединяем слово которое перенесено на новую строку. В тексте оно всего одно
     pub-
     lished
     */
    
    NSInteger indexStartWord = 0;
    NSInteger indexEndWord = 0;
    
    NSString* newWord = [NSString string];
    
    for (NSString* word in wordsInText) {
        NSRange range = [word rangeOfString:@"-" options:NSAnchoredSearch | NSBackwardsSearch];
        
        if (range.location == 3) {
            indexStartWord = [wordsInText indexOfObject:word];
            indexEndWord = indexStartWord + 1;
            
            newWord = [word stringByReplacingCharactersInRange:range
                                                    withString:@""];
            
            newWord = [newWord stringByAppendingString:[wordsInText objectAtIndex:indexEndWord]];
            
            break;
        }
    }
    
    /*Работаем с /. После обработки текста их осталось 2
     s/he - соединяем в she
     trademark/copyright - разбиваем на 2 слова
     */
    
    [wordsInText removeObjectsInRange:NSMakeRange(indexStartWord, indexEndWord)];
    [wordsInText addObject:newWord];
    
    separatedTextInWords = [NSArray arrayWithArray:wordsInText];
    [wordsInText removeAllObjects];
    for (NSString* word in separatedTextInWords) {
        NSRange range = [word rangeOfString:@"/"];
        if (range.location != NSNotFound) {
            if (word.length > 4) {
                [wordsInText addObjectsFromArray:[word componentsSeparatedByString:@"/"]];
            } else {
                newWord = [word stringByReplacingCharactersInRange:range
                                                        withString:@""];
                [wordsInText addObject:newWord];
            }
        } else {
            [wordsInText addObject:word];
        }
    }
    
    /*Удаляем из слов остаточные символы, которые не могут быть частью слова.
     Используем все кроме "-" и "'"
     */
    
    separatedTextInWords = [NSArray arrayWithArray:wordsInText];
    [wordsInText removeAllObjects];
    
    separatedSet = [NSCharacterSet characterSetWithCharactersInString:@"!?@#$%^&*()_=+\"%№%*[]{},.:;"];
    for (NSString* word in separatedTextInWords) {
        NSRange range = [word rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
        
        if (range.location != NSNotFound)
            continue; //если есть цифра, то считается что это не слово
        
        range = [word rangeOfCharacterFromSet:separatedSet];
        
        [wordsInText addObject:[self string:word editWithRange:range andCharacterSet:separatedSet]];
    }
    
    /*Обрабатываем "-", самое непонятное. Т.к задание мне досталось на выходные,
     а срок к понедельнику, то у HR не удалось уточнить по этому поводу. Пришлось
     самостоятельно принимать решение*/
    /*
     Принял так, если слово состоит только из "-", то это не слово и его необходимо удалить
     Если слово начинается или заканчивается с "-", то символ "-" удаляем.
     Например --to, получим просто to.
     Если "-" в слове не 1-й и не последний символ, то разделяем на несколько слов".
     Например morose-looking, получим 2 слова,
     если doing--no--there, то 3 слова
     и тд..
     */
    
    separatedTextInWords = [NSArray arrayWithArray:wordsInText];
    NSMutableArray* appendWords = [NSMutableArray array];
    for (int i = 0; i < [separatedTextInWords count]; i++) {
        NSString* word = [separatedTextInWords objectAtIndex:i];
        NSRange range = [word rangeOfString:@"-"];
        
        if (range.location != NSNotFound) {
            //если слово состоит только из "-", то пропускаем его
            if ([self compareAllString:word withSymbol:@"-"])
                continue;
            
            NSRange findPinctuationInEndWordRange = [word rangeOfString:@"-"
                                                                options:NSAnchoredSearch | NSBackwardsSearch];
            
            NSRange findPinctuationInStartWordRange = [word rangeOfString:@"-"
                                                                  options:NSAnchoredSearch];
            
            /*Если "-" внутри символов, значит разбиваем на несколько слов*/
            if (findPinctuationInEndWordRange.location == NSNotFound
                && findPinctuationInStartWordRange.location == NSNotFound) {
                if (![word isEqualToString:@"e-mail"]) { //оставим только e-mail
                    [appendWords addObjectsFromArray:[word componentsSeparatedByString:@"-"]];
                    continue;
                }
            } else {
                //Если дошли до сюда, значит "-" только с по бокам
                NSRange range = findPinctuationInStartWordRange.location != NSNotFound ? findPinctuationInStartWordRange : findPinctuationInEndWordRange;
                
                [appendWords addObject:[self string:word
                                      editWithRange:range
                                    andCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"-"]]];
            }
        }
    }
    
    //Удаляем все слова где есть "-", только "e-mail" пощадим) посчитаем за слово
    NSMutableArray* removeArray = [NSMutableArray arrayWithArray:wordsInText];
    for (NSString* word in wordsInText) {
        if (![word isEqualToString:@"e-mail"]) {
            NSRange range = [word rangeOfString:@"-"];
        
            if (range.location != NSNotFound) {
                [removeArray removeObject:word];
            }
        }
    }

    wordsInText = [NSMutableArray arrayWithArray:removeArray];
    [wordsInText addObjectsFromArray:appendWords];
    
    /*Осталось обработать только символ "'", для начала и конца..
     такие ситуации как 'it, превратятся в it
     если символ "'" внутри слова, то не трогаем (it's and etc.)
     */
    
    separatedTextInWords = [NSArray arrayWithArray:wordsInText];
    [wordsInText removeAllObjects];

    for (NSString* word in separatedTextInWords) {
        NSRange range = [word rangeOfString:@"'"];
        
        if (range.location != NSNotFound) {
            //если слово состоит только из "'", то пропускаем его
            if ([self compareAllString:word withSymbol:@"'"])
                continue;
            
            NSRange findPinctuationInEndWordRange = [word rangeOfString:@"'"
                                                                options:NSAnchoredSearch | NSBackwardsSearch];
            
            NSRange findPinctuationInStartWordRange = [word rangeOfString:@"'"
                                                                  options:NSAnchoredSearch];
            
            /*Если "'" внутри символов, значит его не трогаем (it's and etc.)*/
            if (findPinctuationInEndWordRange.location == NSNotFound
                && findPinctuationInStartWordRange.location == NSNotFound) {
                [wordsInText addObject:word];
                continue;
            } else {
                //Если дошли до сюда, значит "'" только по бокам слова, удаляем их
                NSRange range = findPinctuationInStartWordRange.location != NSNotFound ? findPinctuationInStartWordRange : findPinctuationInEndWordRange;
                
                [wordsInText addObject:[self string:word
                                      editWithRange:range
                                    andCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"'"]]];
            }
        } else {
            [wordsInText addObject:word];
        }
    }
    
    //последняя фильтрация
    separatedTextInWords = [wordsInText filteredArrayUsingPredicate:
                            [NSPredicate predicateWithFormat:@"length > 0"]];
    
    return separatedTextInWords;
}

//метод сравнения одного символа, со всеми символами в строке
- (BOOL)compareAllString:(NSString*)string withSymbol:(NSString*) symbol {
    BOOL flag = YES;
    for (int i = 0; i < string.length; i++) {
        if (![symbol isEqualToString:[string substringWithRange:NSMakeRange(i, 1)]]) {
            flag = NO;
            break;
        }
    }
    
    return flag;
}

//метод замены всех встречающихся символов в строке
- (NSString*)string:(NSString*)string editWithRange:(NSRange)range andCharacterSet:(NSCharacterSet*)set {
    NSString* word = string;
    //выполняем пока символ, который необходимо удалить есть в строке
    while (range.location != NSNotFound) {
        word = [word stringByReplacingCharactersInRange:range
                                             withString:@""];
        range = [word rangeOfCharacterFromSet:set];
    }
    
    return word;
}

//метод выполняющий частотный анализ
- (NSMutableDictionary*) frequencyAnalysisWords:(NSArray*) wordsArray {
    
    //Считаем сколько раз каждое слово встречается в тексте
    
    NSMutableDictionary* wordAndCountEntryDictionary = [NSMutableDictionary dictionary];
    for (NSString* word in wordsArray) {
        NSNumber* keyInWord = [wordAndCountEntryDictionary valueForKey:word];
        NSInteger countEntry = [keyInWord integerValue] + 1;

        [wordAndCountEntryDictionary setValue:[NSNumber numberWithInteger:countEntry]
                                       forKey:word];
    }
    
    return wordAndCountEntryDictionary;
}

#pragma mark - Actions

//экшен нажатия на кнопку "Старт"
- (IBAction)actionStartAnalysis:(UIButton *)sender {
    //Нчинаем отсчет времени для получения времени выполнения анализа
    NSDate *startTime = [NSDate date];
    
    //считываем файл с текстам
    ATFileOperation* fileOperationObject = [[ATFileOperation alloc] init];
    [fileOperationObject setFileName:@"Qulix-Test Task_iOS _CS Dep_book.txt"];
    
    NSString* textInFile = [fileOperationObject readFromFIle];
    textInFile = [textInFile lowercaseString];
  
    //Разбиваем текст по переносу строки, для того чтобы посчитать процентное соотношение
    NSCharacterSet* characterSetInSeparated = [NSCharacterSet characterSetWithCharactersInString:@"\r\n"];
    
    //получаем все слова в тексте
    NSArray* wordsInFileArray = [self separatedString:textInFile
                                    ByCharactersInSet:characterSetInSeparated];
    
    //начинаем частотный анализ слов
    self.informationAnalysis.wordsAndCountEntryInText = [self frequencyAnalysisWords:wordsInFileArray];
    
    //сортируем слова по частоте встречания в тексте от большего к меньшему
    self.informationAnalysis.sortedKeys = [self.informationAnalysis.wordsAndCountEntryInText
                                           keysSortedByValueUsingComparator:
                                           ^(id obj1, id obj2) {
                                               if ([obj1 integerValue] < [obj2 integerValue]) {
                                                   return (NSComparisonResult)NSOrderedDescending;
                                               }
                                               
                                               if ([obj1 integerValue] > [obj2 integerValue]) {
                                                   return (NSComparisonResult)NSOrderedAscending;
                                               }
                                               
                                               return (NSComparisonResult)NSOrderedSame;
                                           }];
    
    [self.resultButton setHidden:NO];

    //получаем время выполнения анализа
    NSDate *endTime = [NSDate date];
    
    NSTimeInterval executionTime = [endTime timeIntervalSinceDate:startTime];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:executionTime];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:ss SSSS"];
    
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    self.informationAnalysis.timeAnalysis = formattedDate;
}

@end
