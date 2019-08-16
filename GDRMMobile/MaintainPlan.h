//
//  MaintianPlan.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/1/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MaintainPlan : NSManagedObject

@property (nonatomic, retain) NSString * myid;
//项目名称
@property (nonatomic, retain) NSString * project_name;
//施工单位
@property (nonatomic, retain) NSString * construct_org;
//施工负责人或安全员
@property (nonatomic, retain) NSString * org_principal;
//施工开始时间
@property (nonatomic, retain) NSDate * date_start;
//施工结束时间
@property (nonatomic, retain) NSDate * date_end;
//施工路段
@property (nonatomic, retain) NSString * project_address;
//施工占道情况
@property (nonatomic, retain) NSString * close_desc;
//联系电话
@property (nonatomic, retain) NSString * tel_number;
//备注
@property (nonatomic, retain) NSString * remark;

//施工路段方向
@property (nonatomic, retain) NSString * project_direction;
//所属机构
@property (nonatomic, retain) NSString * org_id;
//施工证号
@property (nonatomic, retain) NSString * code;

//@property (nonatomic, retain) NSDate * realy_end_time;
//@property (nonatomic, retain) NSNumber * is_finish;
//@property (nonatomic, retain) NSNumber * station_start;
//@property (nonatomic, retain) NSNumber * station_end;

+(NSArray*) allMaintainPlan;
+(NSString*)maintainPlanNameForID:(NSString*)maintainID;
+(MaintainPlan*)maintainPlanInfoForID:(NSString*)maintainID;
@end
