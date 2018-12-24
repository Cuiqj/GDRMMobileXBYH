//
//  CheckInstitutions.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/7/10.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CheckInstitutions : NSManagedObject

@property (nonatomic, retain) NSNumber * isuploaded;
@property (nonatomic, retain) NSString * org_id;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * carno;
@property (nonatomic, retain) NSString * check_person;
@property (nonatomic, retain) NSDate * check_time;
@property (nonatomic, retain) NSString * recheck_person;
@property (nonatomic, retain) NSDate * recheck_time;
+(NSArray*)allCheckInstitutions;
+(CheckInstitutions*) CheckInstitutionsForID:(NSString*)idString;
@end
