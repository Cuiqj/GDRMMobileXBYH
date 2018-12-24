//
//  Remark.h
//  GDRMXBYHMobile
//
//  Created by admin on 2018/7/5.
//
#import "TrafficRecord.h"
#import "InspectionRecord.h"
#import <Foundation/Foundation.h>


@interface TrafficRemark : NSObject

+ (void)createTrafficwithRemark:(TrafficRecord *)trafficRecord;
+ (NSString * )createTrafficRecordForRemark:(TrafficRecord *)trafficRecord;
@end
