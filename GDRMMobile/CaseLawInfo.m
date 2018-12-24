//
//  CaseLawInfo.m
//  GDRMMobile
//
//  Created by xiaoxiaojia on 17/3/14.
//
//

#import "CaseLawInfo.h"


@implementation CaseLawInfo

@dynamic isuploaded;
@dynamic myid;
@dynamic caseinfo_id;
@dynamic party;
@dynamic location;
@dynamic buildingtype;
@dynamic breaklawdesc;
@dynamic org_id;
@dynamic sendorgname;
@dynamic senddate;
@dynamic linkaddress;
@dynamic linktel;

+(CaseLawInfo*) CaseLawInfoForCaseID:(NSString *)caseID{
    NSManagedObjectContext *context =[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CaseLawInfo" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"caseinfo_id==%@", caseID];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"myid"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"取 违法行为通知书 数据出错");
        return nil;
    }
    if(fetchedObjects.count<1)
        return nil;
    else
        return  [fetchedObjects objectAtIndex:0];

}
@end
