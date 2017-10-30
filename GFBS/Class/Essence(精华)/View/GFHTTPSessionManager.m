//
//  GFHTTPSessionManager.m
//  GFBS
//
//  Created by apple on 2016/11/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "GFHTTPSessionManager.h"
#define KBaseUrl @""

@implementation GFHTTPSessionManager

+ (instancetype)shareManager {
    
    static GFHTTPSessionManager *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURL *url = [NSURL URLWithString:KBaseUrl];
        instance = [[GFHTTPSessionManager alloc]initWithBaseURL:url];
        
        instance.responseSerializer = [AFJSONResponseSerializer serializer];
        instance.requestSerializer = [[AFJSONRequestSerializer alloc] init];
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                              @"text/json",
                                                              @"image/jpeg",
                                                              @"image/png",
                                                              @"text/javascript",
                                                              @"text/html",
                                                              @"text/plain",
                                                              nil];
        instance.requestSerializer.timeoutInterval = 15;
        
    });
    return instance;
}


#pragma mark - GET 请求
- (void)GETWithURLString:(NSString *)URLString
              parameters:(id)parameters
                 success:(void (^)(id data))success
                  failed:(void (^)(NSError *error))failed{
    
    [self GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failed) {
            failed(error);
        }
    }];
}


#pragma mark - POST 请求
- (void)POSTWithURLString:(NSString *)URLString
               parameters:(id)parameters
                  success:(void (^)(id data))success
                   failed:(void (^)(NSError *error))failed{
    [self POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failed) {
            failed(error);
        }
    }];
    
}



@end

