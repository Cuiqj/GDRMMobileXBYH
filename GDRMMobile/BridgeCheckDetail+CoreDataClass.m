//
//  BridgeCheckDetail+CoreDataClass.m
//  GDRMXBYHMobile
//
//  Created by admin on 2018/1/31.
//
//

#import "BridgeCheckDetail+CoreDataClass.h"

@implementation BridgeCheckDetail
+(NSMutableArray*)bridgeCheckDetailForParent_id:(NSString*)parent_id{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext*context=[AppDelegate App].managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BridgeCheckDetail" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parent_id=%@", parent_id];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"myid"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    return [fetchedObjects mutableCopy];
}
+(void)deleteBridgeCheckDetailForPatentID:(NSString*)parent_id{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext*context=[AppDelegate App].managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BridgeCheckDetail" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parent_id=%@", parent_id];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"myid"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (!error && fetchedObjects && [fetchedObjects count])
    {
        for (NSManagedObject *obj in fetchedObjects)
        {
            [context deleteObject:obj];
        }
        if (![context save:&error])
        {
            NSLog(@"删除BridgeCheckDetail表时出错：error:%@",error);
        }  
    }
}
@end
