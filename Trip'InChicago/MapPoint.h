//
//  MapPoint.h
//  Trip'InChicago
//
//  Created by Marion Ano on 4/15/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapPoint : NSObject <MKAnnotation>
@property (copy) NSString *name;
@property (copy) NSString *address;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;


- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;



@end
