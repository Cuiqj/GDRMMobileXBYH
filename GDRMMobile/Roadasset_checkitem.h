//
//  Roadasset_checkitem.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/7/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Roadasset_checkitem : NSManagedObject

@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * org_id;
@property (nonatomic, retain) NSString * project;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * zh;
@property (nonatomic, retain) NSString * fw;
@property (nonatomic, retain) NSString * banci;
@property (nonatomic, retain) NSString * side;
@property (nonatomic, retain) NSNumber * order_number;
+(NSArray*) allRoadasset_checkitem;
@end
