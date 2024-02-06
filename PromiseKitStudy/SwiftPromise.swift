//
//  SwiftPromise.swift
//  PromiseKitStudy
//
//  Created by Howard-Zjun on 2024/2/5.
//

import UIKit
import PromiseKit

class SwiftPromise: NSObject {

    @objc func seriesMethod1() {
        _ = request(urlStr: "http://www.baidu.com").then { str in // 这个`str`的类型来自返回`Promise`中定的类型
            print("[\(NSStringFromClass(SwiftPromise.self))] --- content:\(str)")
            return self.request(urlStr: "https://api.apiopen.top/api/getHaoKanVideo?page=0&size=10")
        }.then({ str in
            print("[\(NSStringFromClass(SwiftPromise.self))] --- content:\(str)")
            return self.request(urlStr: "https://api.apiopen.top/api/getImages?type=food&page=0&size=10")
        }).then({ str in
            print("[\(NSStringFromClass(SwiftPromise.self))] --- content:\(str)")
            return self.request(urlStr: "https://api.apiopen.top/api/getMiniVideo?page=0&size=10")
        }).done({ str in
            print("[\(NSStringFromClass(SwiftPromise.self))] --- content:\(str)")
        }).catch({ error in
            print("[\(NSStringFromClass(SwiftPromise.self))] --- \(error.localizedDescription)")
        })
    }
    
    @objc func seriesMethod2() {
        _ = firstly {
            request(urlStr: "http://www.baidu.com")
        }.then { str in
            print("[\(NSStringFromClass(SwiftPromise.self))] --- content:\(str)")
            return self.request(urlStr: "https://api.apiopen.top/api/getImages?type=food&page=0&size=10")
        }.then({ str in
            print("[\(NSStringFromClass(SwiftPromise.self))] --- content:\(str)")
            return self.request(urlStr: "https://api.apiopen.top/api/getImages?type=food&page=0&size=10")
        }).then({ str in
            print("[\(NSStringFromClass(SwiftPromise.self))] --- content:\(str)")
            return self.request(urlStr: "https://api.apiopen.top/api/getMiniVideo?page=0&size=10")
        }).done({ str in
            print("[\(NSStringFromClass(SwiftPromise.self))] --- content:\(str)")
        }).catch({ error in
            print("[\(NSStringFromClass(SwiftPromise.self))] --- \(error.localizedDescription)")
        })
    }
    
    func request(urlStr: String) -> Promise<String> {
        // Promise<T>的范型与resolver<T>一直
        .init { resolver in
            /*
             resolver方法:
             1.fulfill/reject,两者都是间接构造Result枚举值,fulfill构建fulfilled枚举值,reject构建rejected枚举值
             2.resolve直接传入Result枚举值
             如果Result结果是fulfilled,则会继续执行下一个then,如果Result结果是rejected,则会跳过then直接执行catch
             */
            guard let url = URL(string: urlStr) else {
                resolver.reject(MyError())
                return;
            }
            let urlRequest = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    resolver.reject(error)
                } else if let data = data {
                    let str = String(data: data, encoding: .utf8)!
                    resolver.fulfill(str)
                } else {
                    resolver.reject(MyError())
                }
            }
            task.resume()
        }
    }
    
}

struct MyError: Error {
    
    
}
