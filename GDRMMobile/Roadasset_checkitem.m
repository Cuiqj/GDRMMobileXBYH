//
//  Roadasset_checkitem.m
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/7/13.
//
//

#import "Roadasset_checkitem.h"


@implementation Roadasset_checkitem

@dynamic myid;
@dynamic org_id;
@dynamic project;
@dynamic name;
@dynamic zh;
@dynamic fw;
@dynamic banci;
@dynamic side;
@synthesize order_number;
+(NSArray*) allRoadasset_checkitem{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity  = [NSEntityDescription entityForName:@"Roadasset_checkitem" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"<#format string#>", <#arguments#>];
    //[fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order_number" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error          = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        return nil;
    }
    return fetchedObjects;
}
@end
