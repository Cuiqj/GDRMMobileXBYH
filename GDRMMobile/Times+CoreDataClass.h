//
//  Times+CoreDataClass.h
//  GDRMXBYHMobile
//
//  Created by admin on 2018/2/28.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Times : NSManagedObject
+(NSArray*)TimesByParent_id:(NSString*)parent_id;
@end

NS_ASSUME_NONNULL_END

#import "Times+CoreDataProperties.h"
