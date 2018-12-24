//
//  ALinNetworkTool.m
//  MiaowShow
//
//  Created by ALin on 16/6/14.
//  Copyright © 2016年 ALin. All rights reserved.
//

#import "ALinNetworkTool.h"

@implementation ALinNetworkTool
static ALinNetworkTool *_manager;
+ (instancetype)shareTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [ALinNetworkTool manager];
        // 设置超时时间
        _manager.requestSerializer.timeoutInterval = 15.f;
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
        [_manager.requestSerializer setHTTPShouldHandleCookies:YES];
        [_manager.requestSerializer setValue:@"userid=134684; sessionid=01e7gbI27oAL0sGMqWQm; os=ios; osver=10.2; model=iPhone6s; appver=1.0; appcode=200; time=20171026194556; appid=1000; sign=bad409f176e4e26238b3c2d8bf336899; channel=inhouse; coopid=1000; fcappid=milan-live" forHTTPHeaderField:@"Cookie"];    
        //[_manager.requestSerializer setValue:@"userid=28389; sessionid=01e56oWUnvpnmBhnZrRz; os=ios; osver=10.2; model=iPhone6s; appver=1.0; appcode=200; time=20171019171535; appid=1000; sign=4baa63f490d1e10f20748edde8b5cfdd; channel=inhouse; coopid=1000; fcappid=milan-live" forHTTPHeaderField:@"cookie"];
    });
    return _manager;
}

// 判断网络类型
+ (NetworkStates)getNetworkStates
{
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    // 保存网络状态
    NetworkStates states = NetworkStatesNone;
    for (id child in subviews) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏码
            int networkType = [[child valueForKeyPath:@"dataNetworkType"] intValue];
            switch (networkType) {
                case 0:
                    states = NetworkStatesNone;
                    //无网模式
                    break;
                case 1:
                    states = NetworkStates2G;
                    break;
                case 2:
                    states = NetworkStates3G;
                    break;
                case 3:
                    states = NetworkStates4G;
                    break;
                case 5:
                {
                    states = NetworkStatesWIFI;
                }
                    break;
                default:
                    break;
            }
        }
    }
    //根据状态选择
    return states;
}
@end
