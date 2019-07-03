//
//  CaseProveInfo.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-29.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseManageObject.h"

@interface CaseProveInfo : BaseManageObject

@property (nonatomic, retain) NSString * case_desc_id;
@property (nonatomic, retain) NSString * case_short_desc;
@property (nonatomic, retain) NSString * case_long_desc;
@property (nonatomic, retain) NSString * caseinfo_id;
@property (nonatomic, retain) NSString * citizen_name;
@property (nonatomic, retain) NSDate * end_date_time;
@property (nonatomic, retain) NSString * event_desc;
@property (nonatomic, retain) NSString * event_desc_found;   //违章现场笔录要用到
@property (nonatomic, retain) NSString * invitee;
@property (nonatomic, retain) NSString * invitee_org_duty;
@property (nonatomic, retain) NSNumber * isuploaded;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * organizer;
@property (nonatomic, retain) NSString * organizer_org_duty;
@property (nonatomic, retain) NSString * party;
@property (nonatomic, retain) NSString * party_org_duty;
@property (nonatomic, retain) NSString * prover;
@property (nonatomic, retain) NSString * secondProver;
@property (nonatomic, retain) NSString * recorder;
@property (nonatomic, retain) NSString * recorder_org_duty;
@property (nonatomic, retain) NSDate * start_date_time;
@property (nonatomic, retain) NSString * remark;



//读取案号对应的勘验记录
+(CaseProveInfo *)proveInfoForCase:(NSString *)caseID;

+ (NSString *)generateDefaultDeformation:(NSString *)caseID; //勘验图文字备注b列表信息

+ (NSString *)generateEventDescForCase:(NSString *)caseID;
+ (NSString *)generateEventDescForCaseMap:(NSString *)caseID addCNSString:(NSString *)text;
+ (NSString *)generateEventDescForNotices:(NSString *)caseID;
+ (NSString *)generateEventDescForInquire:(NSString *)caseID;
+ (NSString *)generateWoundDesc:(NSString *)caseID;
+ (NSString*)generateDefaultPayReason:(NSString *)caseID;
+ (NSString *)generateBaoAnZhengminDescWithCaseID:(NSString *)caseID;
- (NSString *) case_mark2;
- (NSString *) full_case_mark3;
- (NSString *) weater;
- (NSString *) prover1;
- (NSString *) prover1_org_duty;
- (NSString *) prover2;
- (NSString *) prover2_org_duty;
- (NSString *) prover3;
- (NSString *) prover3_org_duty;
    
//勘验检查人执法证号
- (NSString *)prover1_exelawid;
//勘验检查人执法证号
- (NSString *)prover2_exelawid;
- (NSString *) citizen_org_duty;
- (NSString *) recorder_org_duty;
- (NSString *)caseMapRemark;


@end
