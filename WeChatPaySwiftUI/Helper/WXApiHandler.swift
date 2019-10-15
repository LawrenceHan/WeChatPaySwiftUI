//
//  WXApiHandler.swift
//  WeChatPaySwiftUI
//
//  Created by Hanguang on 2019/10/11.
//  Copyright © 2019 hanguang. All rights reserved.
//

import Foundation
import SwiftUI

final class WXApiHandler: NSObject, WXApiDelegate {
    
    static let `default` = WXApiHandler()
    
    func onReq(_ req: BaseReq) {
    }
    
    func onResp(_ resp: BaseResp) {
        let title = "我来组成标题"
        var message = ""
        
        switch resp.errCode {
        case WXSuccess.rawValue:
            message = "支付结果：成功！(code: \(resp.errCode)"
        default:
            message = "支付结果：失败！(code = \(resp.errCode), retstr = \(resp.errStr))"
        }
        
        let payload = WXPayResponse(title: title, message: message)
        NotificationCenter.default.post(name: .newWXPayResp, object: payload)
    }
}

extension NSNotification.Name {
    static let newWXPayResp = NSNotification.Name("newWXPayResp")
}

struct WXPayResponse: Identifiable {
    var id: String {
        return "WXPayResponse-" + title + message
    }
    
    let title: String
    let message: String
}
