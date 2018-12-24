//
//  BridgeCheckDetail+CoreDataClass.h
//  GDRMXBYHMobile
//
//  Created by admin on 2018/1/31.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface BridgeCheckDetail : NSManagedObject
+(NSMutableArray*)bridgeCheckDetailForParent_id:(NSString*)parent_id;
+(void)deleteBridgeCheckDetailForPatentID:(NSString*)parent_id;
@end

NS_ASSUME_NONNULL_END

#import "BridgeCheckDetail+CoreDataProperties.h"
