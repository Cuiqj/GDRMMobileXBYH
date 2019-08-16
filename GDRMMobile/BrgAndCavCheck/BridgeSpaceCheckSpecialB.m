//
//  BridgeSpaceCheckSpecialB.m
//  GDRMXBYHMobile
//
//  Created by admin on 2019/7/22.
//

#import "BridgeSpaceCheckSpecialB.h"
#import "UserInfo.h"
#import "OrgInfo.h"

@implementation BridgeSpaceCheckSpecialB

@dynamic recheck;
@dynamic accept_date;
@dynamic acceptor;
@dynamic road_name;
@dynamic org_id;
@dynamic check_user;
@dynamic check_date;
@dynamic finish_date;
@dynamic myid;
@dynamic bsd_id;
@dynamic isuploaded;

+(BridgeSpaceCheckSpecialB *)BridgeSpaceCheckSpecialBforcaseID:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"BridgeSpaceCheckSpecialB" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"myid == %@",caseID];
    fetchRequest.predicate=predicate;
    fetchRequest.entity=entity;
    NSArray * fetchResult=[context executeFetchRequest:fetchRequest error:nil];
    if (fetchResult.count>0) {
        return [fetchResult objectAtIndex:0];
    } else {
        return nil;
    }
}
+(NSArray *)BridgeSpaceCheckSpecialBforArray{
//    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"myid == %@",caseID];
//    fetchRequest.predicate = predicate;
    NSManagedObjectContext * context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription * entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    //[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"org_id == %@",codeName]];
    return [context executeFetchRequest:fetchRequest error:nil];
//    if (result.count>0) {
//        return [result objectAtIndex:0];
//    } else {
//        return nil;
//    }
}


+ (BridgeSpaceCheckSpecialB *)newDataObjectWithEntityName{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"BridgeSpaceCheckSpecialB" inManagedObjectContext:context];
    BridgeSpaceCheckSpecialB * obj = [[NSClassFromString(@"BridgeSpaceCheckSpecialB") alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    if ([obj respondsToSelector:@selector(setMyid:)]) {
        [obj setValue:[NSString randomID] forKey:@"myid"];
    }
    if ([obj respondsToSelector:@selector(isuploaded)]) {
        [obj setValue:@(NO) forKey:@"isuploaded"];
    }
    NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
    NSString *orgID = [[OrgInfo orgInfoForOrgID:[UserInfo userInfoForUserID:currentUserID].organization_id] valueForKey:@"myid"];
    [obj setValue:orgID forKey:@"org_id"];
    obj.check_user = [[UserInfo userInfoForUserID:currentUserID] valueForKey:@"username"];
    //    obj.bsd_id = obj.myid;
    [[AppDelegate App] saveContext];
    return obj;
}
@end
