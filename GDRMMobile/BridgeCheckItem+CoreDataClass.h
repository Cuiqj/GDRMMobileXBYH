//
//  BridgeCheckItem+CoreDataClass.h
//  GDRMXBYHMobile
//
//  Created by admin on 2018/1/31.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface BridgeCheckItem : NSManagedObject
+(NSMutableArray*)allBridgeCheckItem;
@end

NS_ASSUME_NONNULL_END

#import "BridgeCheckItem+CoreDataProperties.h"
