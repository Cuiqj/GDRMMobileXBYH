//
//  CarCheckItems.h
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/7/10.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CarCheckItems : NSManagedObject

@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * checktext;
@property (nonatomic, retain) NSString * checkdesc;
@property (nonatomic, retain) NSString * defaultvalue;
@property (nonatomic, retain) NSString * list;
@property (nonatomic, retain) NSNumber * order_number;
@property (nonatomic, retain) NSString * reason;
+(NSArray*)allCarCheckItems;
+(CarCheckItems*) CarCheckItemsForID:(NSString*)idString;
@end
