//
//  Globlal.h
//  SaleHouse
//
//  Created by wang animeng on 13-4-3.
//  Copyright (c) 2013年 jam. All rights reserved.
//

#ifndef Football_Globlal_h
#define Football_Globlal_h

#import "UIView+GeometryAddition.h"
#import "UIView+AnimationAddition.h"
#import "NSString+Addition.h"
#import "JMDebug.h"
#import "JMAppDelegate.h"
#import "URLDefine.h"

/*************macro************/

//method macro

#define SplitViewCtr [(JMAppDelegate *)[UIApplication sharedApplication].delegate splitViewController]

#define KeyWindow [UIApplication sharedApplication].keyWindow

#define COLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

#define COLORALPHA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/255.0]

#define IOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]

/*************end macro*******/

#define IFLY_APPID @"5184cf0e"
#define IFLY_ENGINE_URL @"http://dev.voicecloud.cn/index.htm"

/*************enum************/

typedef enum REQUEST_ERROR
{
    ErrorParseJson,
    AllErrorType,
}RequestError;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"

static NSString * errorDescription[AllErrorType]={
    @"解析json错误"
};

#pragma clang diagnostic pop

/*************end enum************/

#endif
