//
//  BridgeCheckItem+CoreDataProperties.m
//  GDRMXBYHMobile
//
//  Created by admin on 2018/1/31.
//
//

#import "BridgeCheckItem+CoreDataProperties.h"

@implementation BridgeCheckItem (CoreDataProperties)

+ (NSFetchRequest<BridgeCheckItem *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"BridgeCheckItem"];
}

@dynamic myid;
@dynamic name;
@dynamic project;
@dynamic east;
@dynamic west;
@dynamic classes;
@dynamic org_id;

@end
