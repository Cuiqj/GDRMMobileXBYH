//
//  BridgeCheck+CoreDataClass.h
//  GDRMXBYHMobile
//
//  Created by admin on 2018/1/31.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface BridgeCheck : NSManagedObject
+(NSMutableArray*)allBridgeCheck;
@end

NS_ASSUME_NONNULL_END

#import "BridgeCheck+CoreDataProperties.h"
