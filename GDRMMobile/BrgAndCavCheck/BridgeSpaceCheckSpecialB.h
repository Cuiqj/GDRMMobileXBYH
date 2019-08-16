//
//  BridgeSpaceCheckSpecialB.h
//  GDRMXBYHMobile
//
//  Created by admin on 2019/7/22.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface BridgeSpaceCheckSpecialB : NSManagedObject
@property(nonatomic,retain) NSString * road_name;          //路段名称
@property(nonatomic,retain) NSString * org_id;          //管理单位id
@property(nonatomic,retain) NSString * check_user;      //检查人员
//@property(nonatomic,retain) NSString * check_user_two;      //检查人员二
@property(nonatomic,retain) NSDate   * check_date;        //检查日期
@property(nonatomic,retain) NSDate   * finish_date;     //完成整改日期
@property(nonatomic,retain) NSString * myid;        //      主键
@property(nonatomic,retain) NSString * bsd_id;     //     关联另一个表
//@property(nonatomic,retain) NSString * check_mana;          //检查负责人
//@property(nonatomic,retain) NSString * check_org_id;        //受检单位
@property (nonatomic,retain) NSNumber * isuploaded;
@property (nonatomic,retain) NSString * recheck;           //复查验证情况
@property (nonatomic,retain) NSString * acceptor;           //  验证人
@property (nonatomic,retain) NSDate * accept_date;          //  验收日期






+(BridgeSpaceCheckSpecialB *)BridgeSpaceCheckSpecialBforcaseID:(NSString *)caseID;
+(NSArray *)BridgeSpaceCheckSpecialBforArray;
+ (BridgeSpaceCheckSpecialB *)newDataObjectWithEntityName;

@end
