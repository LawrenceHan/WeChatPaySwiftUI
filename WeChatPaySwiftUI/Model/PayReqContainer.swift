//
//  PayReqContainer.swift
//  WeChatPaySwiftUI
//
//  Created by Hanguang on 2019/10/15.
//  Copyright © 2019 hanguang. All rights reserved.
//

import Foundation

final class PayReqContainer: Decodable {
    let payRequest: PayReq?
    
    init(payreq: PayReq?) {
        self.payRequest = payreq
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //let appid = try container.decode(String.self, forKey: .appid)
        let partnerid = try container.decode(String.self, forKey: .partnerid)
        let prepayid = try container.decode(String.self, forKey: .prepayid)
        let package = try container.decode(String.self, forKey: .package)
        let noncestr = try container.decode(String.self, forKey: .noncestr)
        let timestamp = try container.decode(UInt32.self, forKey: .timestamp)
        let sign = try container.decode(String.self, forKey: .sign)
        
        let result = PayReq()
        result.partnerId = partnerid
        result.prepayId = prepayid
        result.package = package
        result.nonceStr = noncestr
        result.timeStamp = timestamp
        result.sign = sign
        payRequest = result
    }

    enum CodingKeys: String, CodingKey {
        case appid
        case partnerid
        case prepayid
        case package
        case noncestr
        case timestamp
        case sign
    }
}
