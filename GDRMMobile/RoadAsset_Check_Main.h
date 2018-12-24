//
//  RoadAsset_Check_Main.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/7/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RoadAsset_Check_Main : NSManagedObject

@property (nonatomic, retain) NSNumber * isuploaded;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * org_id;
@property (nonatomic, retain) NSDate * start_date;
+(NSArray*) allRoadAsset_Check_Main;
@end
