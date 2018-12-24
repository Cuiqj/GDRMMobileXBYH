//
//  ServiceCheckDetail.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/5/3.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ServiceCheckDetail : NSManagedObject

@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * parent_id;
@property (nonatomic, retain) NSString * target;
@property (nonatomic, retain) NSString * item;
@property (nonatomic, retain) NSString * standard;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSNumber * sorts;
@property (nonatomic, retain) NSNumber * grade;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSNumber * isuploaded;

+(NSArray*)ServiceCheckDetailForID:(NSString*)ID;
@end
