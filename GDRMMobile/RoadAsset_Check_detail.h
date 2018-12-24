//
//  RoadAsset_Check_detail.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/7/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RoadAsset_Check_detail : NSManagedObject

@property (nonatomic, retain) NSString * checkitem_id;
@property (nonatomic, retain) NSNumber * isuploaded;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSNumber * order_number;
@property (nonatomic, retain) NSString * project;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * zh;
@property (nonatomic, retain) NSString * fw;
@property (nonatomic, retain) NSString * banci;
@property (nonatomic, retain) NSString * side;
@property (nonatomic, retain) NSDate * recordtime;
@property (nonatomic, retain) NSString * problem;
@property (nonatomic, retain) NSString * handle;
@property (nonatomic, retain) NSString * redline;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * parent_id;
+(NSArray*)roadAsset_Check_detailForParent_id:(NSString*)PID;
+(RoadAsset_Check_detail*)roadAsset_Check_detailForID:(NSString*)ID;
+(NSArray*)roadAsset_Check_detailForParent_id:(NSString*)PID DoneOrNot:(BOOL)Done;
+(void)ideleteRoadAsset_Check_detailWithPatentID:(NSString*)PID;
@end
