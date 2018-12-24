//
//  RoadAsset_Check_Main.m
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/7/13.
//
//

#import "RoadAsset_Check_Main.h"


@implementation RoadAsset_Check_Main

@dynamic isuploaded;
@dynamic myid;
@dynamic org_id;
@dynamic start_date;
+(NSArray*) allRoadAsset_Check_Main{
    NSManagedObjectContext * context=[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RoadAsset_Check_Main" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"<#format string#>", <#arguments#>];
    //[fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"start_date"
                                                                   ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        return  nil;
    }
    return  fetchedObjects;
 }
@end
