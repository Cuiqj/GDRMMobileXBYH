//
//  NSManagedObject+TKProcess.m
//  GDRMXBYHMobile
//
//  Created by admin on 2017/12/8.
//
//

#import "NSManagedObject+TKProcess.h"

@implementation NSManagedObject (TKProcess)
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{
             @"myid" : @"id",
             @"username":@"name",
             @"account":@"code"
             };
}

@end
