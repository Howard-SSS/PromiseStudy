//
//  SwiftPromise.swift
//  PromiseKitStudy
//
//  Created by Howard-Zjun on 2024/2/5.
//

import UIKit
import PromiseKit

class SwiftPromise: NSObject {

    @objc func seriesMethod() {
        _ = request(urlStr: "http://www.baidu.com").then { str in // 这个`str`的类型来自`Promise`中定的类型
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
    
    func request(urlStr: String) -> Promise<String> {
        .init { resolver in
            guard let url = URL(string: urlStr) else {
                print("[test] --- url:\(urlStr)")
                resolver.reject(MyError())
                return;
            }
            let urlRequest = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    print("[test] --- error\(error)")
                    resolver.reject(error)
                } else if let data = data {
                    let str = String(data: data, encoding: .utf8)!
                    resolver.fulfill(str)
                    // fulfill传入的参数类型为定义`Promise<T>`时的`T`
                } else {
                    print("[test] --- error2")
                    resolver.reject(MyError())
                }
            }
            task.resume()
        }
    }
    
}

struct MyError: Error {
    
    
}
