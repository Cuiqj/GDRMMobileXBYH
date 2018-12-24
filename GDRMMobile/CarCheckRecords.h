//
//  CarCheckRecords.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/7/10.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CarCheckRecords : NSManagedObject

@property (nonatomic, retain) NSNumber * isuploaded;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * parent_id;
@property (nonatomic, retain) NSString * checktext;
@property (nonatomic, retain) NSString * checkdesc;
@property (nonatomic, retain) NSString * defaultvalue;
@property (nonatomic, retain) NSString * reason;
@property (nonatomic, retain) NSString * list;
+(NSArray*)allCarCheckRecords;
+(CarCheckRecords*) CarCheckRecordsForID:(NSString*)idString;
+(NSArray*) CarCheckRecordsForParent_ID:(NSString*)PidString;
+(void) DeleteCarCheckRecordsForParent_ID:(NSString*)PidString;
@end
