//
//  ConstructionCorrect.h
//  GDRMXBYHMobile
//
//  Created by admin on 2018/8/8.
//
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseManageObject.h"

@interface ConstructionCorrect : BaseManageObject


@property (nonatomic, retain) NSString * caseinfo_id;
@property (nonatomic, retain) NSString * correct_name;          //需改正单位或个人
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSNumber * isuploaded;            //是否上传
@property (nonatomic, retain) NSString * breakLaw_one;         //违法事实  一
@property (nonatomic, retain) NSString * breakLaw_two;
@property (nonatomic, retain) NSString * breakLaw_three;
@property (nonatomic, retain) NSString * breakLaw_four;
@property (nonatomic, retain) NSString * demand_one;           //改正内容和要求
@property (nonatomic, retain) NSString * demand_two;
@property (nonatomic, retain) NSString * demand_three;
@property (nonatomic, retain) NSString * demand_four;
@property (nonatomic, retain) NSString * law;
@property (nonatomic, retain) NSString * at_once;               //需要立刻改动问题
@property (nonatomic, retain) NSString * later;                //可以之后改正问题
@property (nonatomic, retain) NSDate   * end_date_time;         //改正完毕时间
@property (nonatomic, retain) NSString * smallplace;
@property (nonatomic, retain) NSString * mark;




+ (ConstructionCorrect *)newCaseConstructionCorrectForCase:(NSString *)caseID;//新建
+ (ConstructionCorrect *)caseConstructionCorrectForCase:(NSString *)caseID;  //获取

@end
