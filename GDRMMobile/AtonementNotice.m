//
//  AtonementNotice.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-15.
//
//

#import "AtonementNotice.h"
#import "Systype.h"

@implementation AtonementNotice

@dynamic myid;
@dynamic caseinfo_id;
@dynamic citizen_name;
@dynamic code;
@dynamic date_send;
@dynamic check_organization;
@dynamic case_desc;
@dynamic witness;
@dynamic pay_reason;
@dynamic pay_mode;
@dynamic organization_id;
@dynamic remark;
@dynamic isuploaded;

- (NSString *) signStr{
    if (![self.caseinfo_id isEmpty]) {
        return [NSString stringWithFormat:@"caseinfo_id == %@", self.caseinfo_id];
    }else{
        return @"";
    }
}

+ (NSArray *)AtonementNoticesForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id==%@",caseID];
    fetchRequest.predicate = predicate;
    fetchRequest.entity    = entity;
    return [context executeFetchRequest:fetchRequest error:nil];
}

- (NSString *)organization_info{
    NSString*s1=[[self.organization_id stringByReplacingOccurrencesOfString:@"一中队" withString:@""] stringByReplacingOccurrencesOfString :@"二中队" withString:@""];
    NSString * str = [[s1 stringByReplacingOccurrencesOfString:@"三中队" withString:@""] stringByReplacingOccurrencesOfString :@"四中队" withString:@""];
    if (![str containsString:@"大队"]) {
        str = [str stringByAppendingString:@"大队"];
    }
    return str;
}

- (NSString *)bank_name{
//    return self.bank_name;
//    广东省公路管理局西部沿海高速公路路政大队 [[Systype typeValueForCodeName:@"交款地点"] objectAtIndex:0];
    NSString  * all = [[Systype typeValueForCodeName:@"交款地点"] objectAtIndex:0];
    return all;
    NSArray * array = [all componentsSeparatedByString:@"西部沿海"];
    return [NSString stringWithFormat:@"西部沿海%@",array[1]];

//    NSString  * all = [[Systype typeValueForCodeName:@"交款地点"] objectAtIndex:0];
//    return
//    [all stringByReplacingOccurrencesOfString: self.bank_namehead withString:@""];
}
- (NSString *)bank_namehead{
    NSString * full = [[Systype typeValueForCodeName:@"交款地点"] objectAtIndex:0];
    return  [full substringToIndex:10];
}
-(NSString *)new_case_desc{
    return self.case_desc;
    NSArray * temp= [self.case_desc componentsSeparatedByString:@"分"];
    return [temp objectAtIndex:1];
}
-(NSString *)new_pay_reason{
//    测试损坏公路路产的违法事实清楚，其行为违反了的《中华人民共和国公路法》 第五十二条、《中华人民共和国公路法》 第四十六条、《中华人民共和国公路法》 第八十五条第一款、《广东省公路条例》 第二十三条之规定，当事人应当承担民事责任，赔偿路产损失。
//    NSArray *temp=[self.pay_reason componentsSeparatedByString:@"违反了"];
//    NSString * ss=[temp objectAtIndex:1];
//    NSArray *temp2=[ss componentsSeparatedByString:@"的规定"];
//    return @"《中华人民共和国公路法》 第五十二条、《中华人民共和国公路法》 第四十六条、《中华人民共和国公路法》 第八十五条第一款、《广东省公路条例》 第二十三条";
//    return [temp2 objectAtIndex:0];
    return @"《中华人民共和国公路法》第五十二条、第八十五条第一款和《广东省公路条例》第二十三条第一款，并依照《损坏公路路产赔补偿标准》（粤交路[1998]38号、粤交路[1999]263号）";
}
-(NSString*)pay_mode2{
    NSString *s1 = [[self.pay_mode stringByReplacingOccurrencesOfString:@"元" withString:@""]  stringByReplacingOccurrencesOfString:@"元整" withString:@""];
    return [[s1 stringByReplacingOccurrencesOfString:@"整" withString:@""]  stringByReplacingOccurrencesOfString:@"元整" withString:@""];
}
@end
