//
//  CaseInfo.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseManageObject.h"
FOUNDATION_EXPORT NSString * const CaseTypeIDPei;// @"11"
FOUNDATION_EXPORT NSString * const CaseTypeIDFa;// @"12"
FOUNDATION_EXPORT NSString * const CaseTypeIDDefault;
FOUNDATION_EXPORT NSString * const CaseTypeIDBaoxian;

typedef enum:NSUInteger {
    kGDRMCaseTypeStartIndex = 10,
    kGDRMCaseTypeCompensation,
    kGDRMCaseTypeCriminalPunishment
} kGDRMCaseType;

@interface CaseInfo : BaseManageObject

@property (nonatomic, retain) NSString * badcar_sum;
@property (nonatomic, retain) NSString * badwound_sum;
@property (nonatomic, retain) NSString * case_mark2;
@property (nonatomic, retain) NSString * case_mark3;
@property (nonatomic, retain) NSString * case_reason;
@property (nonatomic, retain) NSString * case_style;
@property (nonatomic, retain) NSString * case_type;
@property (nonatomic, retain) NSString * case_type_id;
@property (nonatomic, retain) NSString * death_sum;
@property (nonatomic, retain) NSString * fleshwound_sum;
@property (nonatomic, retain) NSDate * happen_date;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * organization_id;
@property (nonatomic, retain) NSString * place;
@property (nonatomic, retain) NSString * roadsegment_id;
@property (nonatomic, retain) NSString * side;
@property (nonatomic, retain) NSNumber * station_end;
@property (nonatomic, retain) NSNumber * station_start;
@property (nonatomic, retain) NSString * weater;
@property (nonatomic, retain) NSNumber * isuploaded;
//已反馈 1 已反馈 0 没有反馈     处罚结果
@property (nonatomic, retain) NSNumber * case_character;
//当事人 是否在场  默认在场  0为在场    1为不在场
@property (nonatomic, retain) NSNumber * is_from_civilaction;

@property (nonatomic, retain) NSString * project_id;
@property (nonatomic, retain) NSString * peccancy_type;
//6 未立案  7 已立案未结案  8  已结案
@property (nonatomic, retain) NSNumber * case_disposal;

@property (nonatomic, retain) NSString * car_bump_part;
@property (nonatomic, retain) NSString * bump_object;
@property (nonatomic, retain) NSString * car_stop_status;
@property (nonatomic, retain) NSString * car_stop_side;
@property (nonatomic, retain) NSString * head_side;
@property (nonatomic, retain) NSString * body_side;
@property (nonatomic, retain) NSString * tail_side;
@property (nonatomic, retain) NSString * car_looks;
@property (nonatomic, retain) NSString * insurance_company;
@property (nonatomic, retain) NSString * insurance_no;
@property (nonatomic, retain) NSString * sfz_id;


//读取案号对应的案件信息记录
+(CaseInfo *)caseInfoForID:(NSString *)caseID;

//删除对应案号的信息记录
+ (void)deleteCaseInfoForID:(NSString *)caseID;

//删除无用的空记录
+ (void)deleteEmptyCaseInfo;

+ (NSInteger)maxCaseMark3;
+ (NSInteger)maxCaseMark3ForAdministrativePenalty;
- (NSString *)station_start_km;
- (NSString *)station_start_m;
- (NSString *)side_short;
- (NSString *)full_roadName;
- (NSString *)full_case_mark3;

- (NSString *)full_happen_place;

- (NSString *)organization_label;
- (NSString *)count_place;
- (NSString *)roadnameAndPlace;
@end
