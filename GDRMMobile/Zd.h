//
//  Zd.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/3/10.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Zd : NSManagedObject

@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * sfz_id;
@property (nonatomic, retain) NSString * zd_name;
@property (nonatomic, retain) NSString * sf;
@property (nonatomic, retain) NSString * side;
@property (nonatomic, retain) NSString * remark;
+(NSArray*)ZdByShoufzID:(NSString*)sfzID;
@end
