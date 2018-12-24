//
//  TrafficRecord.h
//  GDRMMobile
//
//  Created by coco on 13-7-8.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseManageObject.h"

@interface TrafficRecord : BaseManageObject
//肇事车辆
@property (nonatomic, retain) NSString * car;
//事故处理结束时间
@property (nonatomic, retain) NSDate * clend;
//事故处理开始时间
@property (nonatomic, retain) NSDate * clstart;
//方向
@property (nonatomic, retain) NSString * fix;
//发生时间
@property (nonatomic, retain) NSDate   * happentime;
@property (nonatomic, retain) NSString * myid;
//消息来源
@property (nonatomic, retain) NSString * infocome;
//是否结案
@property (nonatomic, retain) NSString * isend;
//损失金额
@property (nonatomic, retain) NSString * lost;
//索赔方式
@property (nonatomic, retain) NSString * paytype;
//事故性质
@property (nonatomic, retain) NSString * property;
//巡查记录ID
@property (nonatomic, retain) NSString * rel_id;
//备注
@property (nonatomic, retain) NSString * remark;
//封道情况
@property (nonatomic, retain) NSString * roadsituation;
//桩号
@property (nonatomic, retain) NSNumber * station;
//事故分类
@property (nonatomic, retain) NSString * type;
//事故类型
@property (nonatomic, retain) NSString *  case_type;
//伤亡情况
@property (nonatomic, retain) NSString * wdsituation;
@property (nonatomic, retain) NSString * org_id;

@property (nonatomic, retain) NSString * location;
//拯救处理开始时间
@property (nonatomic, retain) NSDate * zjend;
//拯救处理开始时间
@property (nonatomic, retain) NSDate   * zjstart;
@property (nonatomic, retain) NSNumber * isuploaded;
//是否拯救处理
@property (nonatomic, strong) NSNumber * iszj;
//是否事故处理
@property (nonatomic, strong) NSNumber * issg;

//@property (nonatomic, retain) NSString * location;    //nvarchar(500)    事发地点
@property (nonatomic, retain) NSNumber * fleshwound_sum;     //    int    轻伤人数
@property (nonatomic, retain) NSNumber * badwound_sum;      //    int    重伤人数
@property (nonatomic, retain) NSNumber * death_sum;             //int    死亡人数
@property (nonatomic, retain) NSNumber * badcar_sum;     //    int    损坏车辆数






+(NSArray*)allTrafficRecord;
+(TrafficRecord*)trafficRecordForID:(NSString*)ID;
@end
