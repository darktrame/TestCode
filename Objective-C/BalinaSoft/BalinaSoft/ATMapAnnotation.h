//
//  ATMapAnnotation.h
//  BalinaSoft
//
//  Created by Андрей Трофимов on 2/14/17.
//  Copyright © 2017 Андрей Трофимов. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface ATMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
