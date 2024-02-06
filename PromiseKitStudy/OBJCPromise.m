//
//  OBJCPromise.m
//  PromiseKitStudy
//
//  Created by Howard-Zjun on 2024/2/5.
//

#import "OBJCPromise.h"
#import "PromiseKit.h"

@implementation OBJCPromise

- (void)seriesMethod1 {
    [self requestWithUrlStr:@"http://www.baidu.com"].then(^(NSString *str) { // 这个`str`的类型来自`Promise`中定的类型
        NSLog(@"[%@] --- content:%@", NSStringFromClass(OBJCPromise.class), str);
        return [self requestWithUrlStr:@"https://api.apiopen.top/api/getHaoKanVideo?page=0&size=10"];
    }).then(^(NSString *str) {
        NSLog(@"[%@] --- content:%@", NSStringFromClass(OBJCPromise.class), str);
        return [self requestWithUrlStr:@"https://api.apiopen.top/api/getImages?type=food&page=0&size=10"];
    }).then(^(NSString *str) {
        NSLog(@"[%@] --- content:%@", NSStringFromClass(OBJCPromise.class), str);
        return [self requestWithUrlStr:@"https://api.apiopen.top/api/getMiniVideo?page=0&size=10"];
    }).then(^(NSString *str){
        NSLog(@"[%@] --- content:%@", NSStringFromClass(OBJCPromise.class), str);
    }).catch(^(NSError *error) {
        NSLog(@"[%@] --- content:%@", NSStringFromClass(OBJCPromise.class), error.localizedDescription);
    });
}

- (AnyPromise *)requestWithUrlStr:(NSString *)urlStr {
    return [AnyPromise promiseWithAdapterBlock:^(PMKAdapter  _Nonnull adapter) {
        NSURL *url = [NSURL URLWithString:urlStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSessionDataTask *task = [NSURLSession.sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error != nil) {
                adapter(nil, error);
            } else if (data != nil) {
                NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                adapter(str, nil);
            } else {
                NSError *error = [[NSError alloc] init];
                adapter(nil, error);
            }
        }];
        [task resume];
    }];
}

@end
