//
//  JMBasicAction.m
//  SaleHouse
//
//  Created by wang animeng on 13-4-3.
//  Copyright (c) 2013年 jam. All rights reserved.
//

#import "JMBasicAction.h"
#import "JMClient.h"
#import "AFJSONRequestOperation.h"

@interface JMBasicAction()

@property (nonatomic,retain) JMClient *client;

@end

@implementation JMBasicAction

- (id)init
{
    self = [super init];
    if (self) {
        self.client = [JMClient shareClient];
        [self.client SetAcceptJsonDictionary];
        self.parameter = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - http action

- (void)getRequestResult:(SuccessInfo)info error:(ErrorInfo)errorInfo
{
    [self.client getPath:self.basicPath parameters:self.parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            info((NSDictionary*)responseObject);
        }
        else{
            NSError *error = [NSError errorWithDomain:errorDescription[ErrorParseJson]
                                                 code:ErrorParseJson userInfo:nil];
            errorInfo(error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorInfo(error);
    }];
}

- (void)postRequestResult:(SuccessInfo)info error:(ErrorInfo)errorInfo
{
    [self.client postPath:self.basicPath parameters:self.parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            info((NSDictionary*)responseObject);
        }
        else{
            NSError *error = [NSError errorWithDomain:errorDescription[ErrorParseJson]
                                                 code:ErrorParseJson userInfo:nil];
            errorInfo(error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorInfo(error);
    }];
}

#pragma mark - subclass implementation 

- (void)requestResult:(SuccessAryInfo)info error:(ErrorInfo)errorInfo
{
    [self.client getPath:self.basicPath parameters:self.parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            info((NSArray*)responseObject);
            JMDEBUGPRINT(@"result:%@",responseObject);
        }
        else{
            NSError *error = [NSError errorWithDomain:errorDescription[ErrorParseJson]
                                                 code:ErrorParseJson userInfo:nil];
            errorInfo(error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        JMDEBUGPRINT(@"%@",error);
        errorInfo(error);
    }];
    JMDEBUGPRINT(@"Create request:%@ parameter:%@",[NSString stringWithFormat:@"%@/%@",self.client.baseURL,self.basicPath],self.parameter);
}

- (void)postResult:(SuccessAryInfo)info error:(ErrorInfo)errorInfo
{
    [self.client postPath:self.basicPath parameters:self.parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSArray *ary = (NSArray*)responseObject;
            NSMutableArray *sentence = [NSMutableArray array];
            for (NSDictionary *dic in ary) {
                [sentence addObject:[dic objectForKey:@"content"]];
            }
            info(sentence);
            JMDEBUGPRINT(@"result:%@",sentence);
        }
        else{
            NSError *error = [NSError errorWithDomain:errorDescription[ErrorParseJson]
                                                 code:ErrorParseJson userInfo:nil];
            errorInfo(error);
            JMDEBUGPRINT(@"%@",error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorInfo(error);
    }];
    JMDEBUGPRINT(@"Create request:%@ parameter:%@",[NSString stringWithFormat:@"%@/%@",self.client.baseURL,self.basicPath],self.parameter);
}

@end
