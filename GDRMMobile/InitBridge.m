//
//  InitBridge.m
//  GDRMMobile
//
//  Created by xiaoxiaojia on 16/12/20.
//
//

#import "InitBridge.h"
//#import "UserInfo.h"
#import "TBXML.h"
#import "Table101.h"
@implementation InitBridge

- (void)downLoadBridge:(NSString *)orgID{
    WebServiceInit;
    //[service downloadDataSet:@"select * from UserInfo" orgid:orgID];
    [service downloadDataSet:[@"select * from BridgeCheckItem where org_id = " stringByAppendingString:orgID]];
}

- (NSDictionary *)xmlParser:(NSString *)webString{
    return [self autoParserForDataModel:@"Table101" andInXMLString:webString];
}

@end
 
