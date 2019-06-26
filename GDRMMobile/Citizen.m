//
//  Citizen.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-19.
//
//

#import "Citizen.h"


@implementation Citizen

@dynamic address;
@dynamic age;
@dynamic automobile_address;
@dynamic automobile_number;
@dynamic automobile_owner;
@dynamic automobile_pattern;
@dynamic bad_desc;
@dynamic card_name;
@dynamic card_no;
@dynamic carowner;
@dynamic carowner_address;
@dynamic proveinfo_id;
@dynamic compensate_money;
@dynamic driver;
@dynamic isuploaded;
@dynamic myid;
@dynamic nation;
@dynamic nationality;
@dynamic nexus;
@dynamic org_name;
@dynamic org_principal;
@dynamic org_principal_duty;
@dynamic org_principal_tel_number;
@dynamic org_tel_number;
@dynamic original_home;
@dynamic party;
@dynamic patry_type;
@dynamic postalcode;
@dynamic profession;
@dynamic proportion;
@dynamic remark;
@dynamic sex;
@dynamic tel_number;
@dynamic org_full_name;

- (NSString *) signStr{
    if (![self.proveinfo_id isEmpty]) {
        return [NSString stringWithFormat:@"proveinfo_id == %@", self.proveinfo_id];
    }else{
        return @"";
    }
}

//当事人职务及电话
- (NSString *)nameAndprincipal_duty{
    if (self.org_name && self.org_principal_duty) {
        return [NSString stringWithFormat:@"%@ %@",self.org_name,self.org_principal_duty];
    }else if (!self.org_name){
        return self.org_principal_duty;
    }else if (self.org_principal_duty){
        return self.org_name;
    }
    return nil;
}


+ (NSArray *)allCitizenNameForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"Citizen" inManagedObjectContext:context];
    fetchRequest.entity=entity;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"proveinfo_id==%@ && nexus==%@",caseID,@"当事人"];
    fetchRequest.predicate=predicate;
    return [context executeFetchRequest:fetchRequest error:nil];
}



+ (Citizen *)citizenForName:(NSString *)autoNumber nexus:(NSString *)nexus case:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    fetchRequest.entity=entity;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"proveinfo_id==%@ && nexus==%@ && automobile_number==%@",caseID,nexus,autoNumber];
    fetchRequest.predicate=predicate;
    if ([context countForFetchRequest:fetchRequest error:nil]>0) {
        return [[context executeFetchRequest:fetchRequest error:nil] lastObject];
    } else {
        return nil;
    }
}


+ (Citizen *)citizenForNilName:(NSString *)name nexus:(NSString *)nexus case:(NSString *)caseID{
    if (self == nil) {
        Citizen * citizen = [[super alloc]init];
        citizen.address = @"";
        citizen.age = 0;
        citizen.automobile_address = @"";
        citizen.automobile_number = 0;
        citizen.automobile_owner = nil;
        citizen.automobile_pattern = @"";
        citizen.bad_desc = @"";
        citizen.card_name= nil;
        citizen.card_no = @"";
        citizen.carowner = @"";
        citizen.carowner_address = @"";
        citizen.compensate_money = 0;
        citizen.driver = nil;
        citizen.isuploaded = 0;
        citizen.myid = @"";
        citizen.nation = @"";
        citizen.nationality = @"";
        citizen.nexus = @"";
        citizen.org_full_name = @"";
        citizen.org_name = @"";
        citizen.org_principal = @"";
        citizen.org_principal_duty = @"";
        citizen.org_principal_tel_number = nil;
        citizen.org_tel_number = nil;
        citizen.original_home = nil;
        citizen.party = @"";
        citizen.patry_type = nil;
        citizen.postalcode = @"";
        citizen.profession = @"";
        citizen.proportion = 0;
        citizen.proveinfo_id = @"";
        citizen.remark = nil;
        citizen.sex = @"";
        citizen.tel_number = @"";
        return citizen;
    }
}



+ (Citizen *)citizenForParty:(NSString *)party case:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    fetchRequest.entity=entity;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"proveinfo_id==%@ && nexus==%@ && party==%@",caseID,@"当事人",party];
    fetchRequest.predicate=predicate;
    if ([context countForFetchRequest:fetchRequest error:nil]>0) {
        return [[context executeFetchRequest:fetchRequest error:nil] lastObject];
    } else {
        return nil;
    }
}
////无当事人传参数时
//+ (Citizen *)citizenForNilNameCaseID:(NSString *)caseID{
//    Citizen * citizen = [[Citizen alloc]init];
//    citizen.org_name = @"逃逸事故";
//    [[AppDelegate App] saveContext];
//    return [self citizenForCitizenName:nil nexus:@"当事人" case:caseID];
//}

//add by lxm 2013.05.10
+ (Citizen *)citizenForCitizenName:(NSString *)name nexus:(NSString *)nexus case:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    fetchRequest.entity=entity;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"proveinfo_id==%@ && nexus==%@",caseID,nexus];
    fetchRequest.predicate=predicate;
    if ([context countForFetchRequest:fetchRequest error:nil]>0) {
        return [[context executeFetchRequest:fetchRequest error:nil] lastObject];
    } else {
        return nil;
    }
}


#pragma mark - 行政处罚  需要注意的是跟【路政案件】的最大区别是 对应一个案件，一个类别(当事人,组织代表等)只有一个对应的当事人，不会有多个，也就说，相对于路政案件，不会有多车辆问题
+ (Citizen *)citizenByCaseID:(NSString *)caseID andNexus:(NSString *)nexus{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"Citizen" inManagedObjectContext:context];
    fetchRequest.entity=entity;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"proveinfo_id==%@ && nexus==%@",caseID,nexus];
    fetchRequest.predicate=predicate;
    if ([context countForFetchRequest:fetchRequest error:nil]>0) {
        return [[context executeFetchRequest:fetchRequest error:nil] lastObject];
    } else {
        return nil;
    }
}
+ (Citizen *)citizenByCaseID:(NSString *)caseID{
    return [Citizen citizenByCaseID:caseID andNexus:@"当事人"];
}
@end


