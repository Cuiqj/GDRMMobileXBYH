//
//  BridgeCheckDetail.h
//  GDRMXBYHMobile
//
//  Created by admin on 2019/7/22.
//

#import <CoreData/CoreData.h>

@interface BridgeCheckDetail : NSManagedObject
@property (nullable, nonatomic, copy) NSString *myid;
@property (nullable, nonatomic, copy) NSNumber *isuploaded;
//项目
@property (nullable, nonatomic, copy) NSString *item_id;
//检查路段名称   对应桩号
@property (nullable, nonatomic, copy) NSString *name;
//检查项目    对应 桥涵类型
@property (nullable, nonatomic, copy) NSString *project;
//往东
@property (nullable, nonatomic, copy) NSString *east;
//往西
@property (nullable, nonatomic, copy) NSString *west;
//所属班次
@property (nullable, nonatomic, copy) NSString *classes;
//检查情况
@property (nullable, nonatomic, copy) NSString *check_situation;
//约立方米     对应 数量
@property (nullable, nonatomic, copy) NSString *cubic_m;
//处理情况
@property (nullable, nonatomic, copy) NSString *handle;
//备注
@property (nullable, nonatomic, copy) NSString *remark;
//检查状态   1为已经检查     0 未检查
@property (nullable, nonatomic, copy) NSString *status;
//关联主表的id  parent_id == 主表的id
@property (nullable, nonatomic, copy) NSString *parent_id;
//检查日期，
@property (nullable, nonatomic, copy) NSDate *recordtime;
//检查人    ,隔开
@property (nullable, nonatomic, copy) NSString * checkuser;


+(NSMutableArray*)bridgeCheckDetailForParent_id:(NSString*)parent_id;
+(void)deleteBridgeCheckDetailForPatentID:(NSString*)parent_id;

@end
