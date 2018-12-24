//
//  InsuranceNotice.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/3/2.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface InsuranceNotice : NSManagedObject

@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * caseinfo_id;
@property (nonatomic, retain) NSString * insured;
@property (nonatomic, retain) NSString * insurance_object;
@property (nonatomic, retain) NSString * insurance_money;
@property (nonatomic, retain) NSDate * startdate;
@property (nonatomic, retain) NSDate * enddate;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSDate * insurance_date;
@property (nonatomic, retain) NSNumber * money;
@property (nonatomic, retain) NSString * insurance_desc;
@property (nonatomic, retain) NSString * receiver;
@property (nonatomic, retain) NSString * account_name;
@property (nonatomic, retain) NSString * bank;
@property (nonatomic, retain) NSString * account;
@property (nonatomic, retain) NSString * linker;
@property (nonatomic, retain) NSString * tel;
@property (nonatomic, retain) NSNumber * isuploaded;

@end
