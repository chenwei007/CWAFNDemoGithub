//
//  DQRequestUrl.h
//  QeelinGold-iOS
//
//  Created by MacBook on 2017/5/17.
//  Copyright © 2017年 ChenWei. All rights reserved.
//

#ifndef DQRequestUrl_h
#define DQRequestUrl_h

#ifdef DEBUG
#define API_Public_Link     @"http://www.baidu/"
#else
#define API_Public_Link     @"http://www.baidu/"
#endif

//系统版本号
#define kCurrentSystemVersion [NSString stringWithFormat:@"%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]]
//app版本号
#define kCurrentAppVersion      [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
//版本标示
#define kUa @"iOS"
//idfa
#define IDFA_String [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]

/**
 *      首页
 */
#define DEF_GetHomepage         @"system/getNoticeList.do"

#endif /* DQRequestUrl_h */
