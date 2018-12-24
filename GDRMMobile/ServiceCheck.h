//
//  ServiceCheck.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/5/3.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ServiceCheck : NSManagedObject

@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSDate * checkdate;
@property (nonatomic, retain) NSString * org_id;
@property (nonatomic, retain) NSString * servicename;
@property (nonatomic, retain) NSString * service_fuzeren;
@property (nonatomic, retain) NSString * check_fuzeren;
@property (nonatomic, retain) NSNumber * isuploaded;
+(NSArray*) allServiceCheck;
+(ServiceCheck*) ServiceCheckForID:(NSString*)ID;

@end
