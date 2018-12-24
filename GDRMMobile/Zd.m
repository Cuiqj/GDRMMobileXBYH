//
//  Zd.m
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/3/10.
//
//

#import "Zd.h"


@implementation Zd

@dynamic myid;
@dynamic sfz_id;
@dynamic zd_name;
@dynamic sf;
@dynamic side;
@dynamic remark;
+(NSArray*)ZdByShoufzID:(NSString *)sfzID{
    NSManagedObjectContext *context =[[AppDelegate App ] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Zd" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sfz_id==%@", sfzID];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"myid"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSMutableArray *fetchedObjects = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if (fetchedObjects == nil) {
        NSLog(@"取匝道数据失败");//Error handling code
    }else{
        fetchedObjects=[[fetchedObjects valueForKey:@"zd_name"] mutableCopy];
    }
    return [NSArray arrayWithArray:fetchedObjects];
}
@end
