//
//  RoadAsset_Check_detail.m
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/7/13.
//
//

#import "RoadAsset_Check_detail.h"


@implementation RoadAsset_Check_detail

@dynamic checkitem_id;
@dynamic isuploaded;
@dynamic myid;
@dynamic order_number;
@dynamic project;
@dynamic name;
@dynamic zh;
@dynamic fw;
@dynamic banci;
@dynamic side;
@dynamic recordtime;
@dynamic problem;
@dynamic handle;
@dynamic redline;
@dynamic remark;
@dynamic status;
@dynamic parent_id;
+(NSArray*)roadAsset_Check_detailForParent_id:(NSString*)PID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RoadAsset_Check_detail" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parent_id=%@", PID];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"myid"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        return  nil;
    }
    return fetchedObjects;
}
+(RoadAsset_Check_detail*)roadAsset_Check_detailForID:(NSString*)ID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RoadAsset_Check_detail" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"myid=%@", ID];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"myid"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        return  nil;
    }
    return [fetchedObjects objectAtIndex:0];
}
+(NSArray*)roadAsset_Check_detailForParent_id:(NSString*)PID DoneOrNot:(BOOL)Done{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RoadAsset_Check_detail" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate=[[NSPredicate alloc]init];
    if(Done)
      predicate = [NSPredicate predicateWithFormat:@"parent_id=%@ && status=1", PID];
    else
      predicate = [NSPredicate predicateWithFormat:@"parent_id=%@ && status=0", PID];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"myid"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        return  nil;
    }
    return fetchedObjects;
}
+(void)ideleteRoadAsset_Check_detailWithPatentID:(NSString*)PID{
    NSArray *dataArray=[self roadAsset_Check_detailForParent_id:PID];
    for (RoadAsset_Check_detail *item in dataArray) {
        [[[AppDelegate App]managedObjectContext] deleteObject:item];
    }
    [[AppDelegate App] saveContext];
}
@end
