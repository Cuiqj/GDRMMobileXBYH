//
//  CaseIDHandler.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CaseIDHandler <NSObject>

@optional
-(void)setCaseIDdelegate:(NSString *)caseID;
-(void)setCaseIDdelegate2:(NSString *)caseID;
-(void)setWeather:(NSString *)textWeather;
-(void)setAuotMobilePattern:(NSString *)textPattern;
-(void)setCaseDescArrayDelegate:(NSArray *)aCaseDescArray;
-(void)setBadDesc:(NSString *)textBadDesc;
-(void)setAutoNumber:(NSString *)textAutoNumber;
-(void)setPeccancyType:(NSString *)textPeccancyType;
-(void)setCaseType:(NSString *)textCaseType;
-(void)reloadDocuments;                                     ////新打印文档后，重新载入文书列表
-(void)loadInquireForAnswerer:(NSString *)answererName;
-(void)clearAutoInfo;
-(void)scrollViewNeedsMove;
-(void)deleteCaseAllDataForCase:(NSString *)caseID;
-(NSString *)getCaseIDdelegate;
-(NSString *)getAutoNumberDelegate;
-(NSArray *)getCaseDescArrayDelegate;

-(void)loadTextand:(NSString *)text addTag:(NSInteger)tag;

@end
