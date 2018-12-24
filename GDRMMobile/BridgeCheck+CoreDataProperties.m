//
//  BridgeCheck+CoreDataProperties.m
//  GDRMXBYHMobile
//
//  Created by admin on 2018/1/31.
//
//

#import "BridgeCheck+CoreDataProperties.h"

@implementation BridgeCheck (CoreDataProperties)

+ (NSFetchRequest<BridgeCheck *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"BridgeCheck"];
}

@dynamic myid;
@dynamic isuploaded;
@dynamic org_id;
@dynamic check_date;

@end
