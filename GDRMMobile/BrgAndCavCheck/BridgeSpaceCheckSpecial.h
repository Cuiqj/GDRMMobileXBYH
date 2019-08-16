//
//  BridgeSpaceCheckSpecial.h
//  GDRMXBYHMobile
//
//  Created by admin on 2019/7/22.
//

#import <CoreData/CoreData.h>

@interface BridgeSpaceCheckSpecial : NSManagedObject

@property(nonatomic,retain) NSString * check_project;               //检查项目
@property(nonatomic,retain) NSString * check_content;               //检查内容
@property(nonatomic,retain) NSString * check_require;               //检查要求
@property(nonatomic,retain) NSString * check_result;                //检查结果
@property(nonatomic,retain) NSString * b_id;                        //标明哪个检查内容
@property(nonatomic,retain) NSString * bsd_id;                      //关联另一个表
@property (nonatomic, retain) NSNumber * isuploaded;

@property (nonatomic,retain) NSString * myid;

+(BridgeSpaceCheckSpecial *)BridgeSpaceCheckSpecialForCase:(NSString *)caseID addforb_id:(NSString *)smallID;
+(NSArray *)caseBridgeSpaceCheckSpecialForCase:(NSString *)caseID;
+ (BridgeSpaceCheckSpecial *)newDataObjectWithEntityNameforcaseID:(NSString *)caseID addBiaoShiID:(NSString *)smallID addresult:(NSString *)result;

@end
