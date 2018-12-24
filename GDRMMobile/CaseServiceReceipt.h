//
//  CaseServiceReceipt.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseManageObject.h"

@interface CaseServiceReceipt : BaseManageObject

@property (nonatomic, retain) NSString * caseinfo_id;
@property (nonatomic, retain) NSString * citizen_name;
@property (nonatomic, retain) NSString * incepter_name;         //受送达人
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * service_position;       //送达地点
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * service_company;          //送达单位
@property (nonatomic, retain) NSNumber * isuploaded;            //是否上传
@property (nonatomic, retain) NSString * agent_name;            //代收人


+ (CaseServiceReceipt *)newCaseServiceReceiptForCase:(NSString *)caseID;

+ (CaseServiceReceipt *)caseServiceReceiptForCase:(NSString *)caseID;

- (NSArray *)file_list;
- (NSString *)case_short_desc;
@end
