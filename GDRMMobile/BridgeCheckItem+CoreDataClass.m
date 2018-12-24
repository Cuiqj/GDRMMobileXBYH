//
//  BridgeCheckItem+CoreDataClass.m
//  GDRMXBYHMobile
//
//  Created by admin on 2018/1/31.
//
//

#import "BridgeCheckItem+CoreDataClass.h"

@implementation BridgeCheckItem
+(NSMutableArray*)allBridgeCheckItem{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext* context=[AppDelegate App].managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BridgeCheckItem" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"<#format string#>", <#arguments#>];
    //[fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"myid"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    return [fetchedObjects mutableCopy];
 }
@end
