//
//  ServiceCheckItems.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/5/3.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ServiceCheckItems : NSManagedObject

@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * target;
@property (nonatomic, retain) NSString * item;
@property (nonatomic, retain) NSString * standard;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSNumber * sorts;
+(NSArray*)allServiceCheckItemsTarget;
+(NSArray*)serviceCheckItemsItemForTarget:(NSString*)target;
+(ServiceCheckItems*)serviceCheckItemsItemForTarget:(NSString*)target andItems:(NSString*)item;

@end
