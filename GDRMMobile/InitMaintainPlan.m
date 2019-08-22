//
//  InitMaintianPlan.m
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/1/12.
//
//
#import "InitMaintainPlan.h"
//#import "UserInfo.h"
#import "TBXML.h"
@implementation InitMaintainPlan

- (void)downMaintainPlan:(NSString *)orgID{
    WebServiceInit;
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * nowstring = [formatter stringFromDate:date];
    [service downloadDataSet:[NSString stringWithFormat: @"select * from MaintainPlan where org_id=%@",orgID]];
//    [service downloadDataSet:[NSString stringWithFormat: @"select * from MaintainPlan where org_id=%@ and '%@' < date_end ",orgID,nowstring]];
//    [service downloadDataSet:@"select * from MaintainPlan" ];
    //[service downloadDataSet:[@"select * from MaintianPlan where org_id = " stringByAppendingString:orgID]];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"MaintainPlan" andInXMLString:webString];
}

@end
