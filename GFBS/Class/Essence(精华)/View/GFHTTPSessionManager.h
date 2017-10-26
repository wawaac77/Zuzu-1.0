//
//  GFHTTPSessionManager.h
//  GFBS
//
//  Created by apple on 2016/11/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface GFHTTPSessionManager : AFHTTPSessionManager


/**
 *  工具类
 *
 *  @return 返回的工具不是单例，但里面的sessionManager是单例
 */
+(id)shareManager;


/**
 *  Get请求
 *
 *  @param URLString  URLString
 *  @param parameters 参数
 *  @param success    成功的回调二进制
 *  @param failed     失败的回调
 */
- (void)GETWithURLString:(NSString *)URLString
              parameters:(id)parameters
                 success:(void (^)(id data))success
                  failed:(void (^)(NSError *error))failed;


/**
 *  POST 请求
 *
 *  @param URLString  URLString
 *  @param parameters 参数
 *  @param success    成功的回调二进制
 *  @param failed     失败的回调
 */
- (void)POSTWithURLString:(NSString *)URLString
               parameters:(id)parameters
                  success:(void (^)(id data))success
                   failed:(void (^)(NSError *error))failed;


@end
