//
//  ContentViewModel.swift
//  WeChatPaySwiftUI
//
//  Created by Hanguang on 2019/10/14.
//  Copyright © 2019 hanguang. All rights reserved.
//

import Foundation
import Combine

final class ContentViewModel: ObservableObject {
    
    @Published private(set) var payReq: PayReq?
    @Published private(set) var isLoading: Bool = false
    @Published var payResponse: WXPayResponse?
    
    func prePayRequest() {
        guard let url = URL(string: "https://wxpay.wxutil.com/pub_v2/app/app_pay.php?plat=ios") else {
            return
        }
        isLoading = true
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let response = URLSession.shared.send(request: request)
            .decode(type: PayReqContainer.self, decoder: JSONDecoder())
            .map { Result<PayReqContainer, Error>.success($0) }
            .catch { error -> AnyPublisher<Result<PayReqContainer, Error>, Never> in
                return .just(.success(PayReqContainer(payreq: nil)))
        }
        .eraseToAnyPublisher()
        .receive(on: DispatchQueue.main)
        .share()
        
        response
            .map { _ in false }
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)
        
        response
            .map { result -> PayReq? in
                switch result {
                case let .success(req):
                    return req.payRequest
                case .failure:
                    return nil
                }
        }
        .sink(receiveValue: { payReq in
            self.payReq = payReq
            if let payReq = payReq {
                WXApi.send(payReq) { result in
                    if result {
                        print("success.")
                    } else {
                        print("failed")
                    }
                }
            }
        })
        .store(in: &cancellables)
    }
    
    init() {
        NotificationCenter.default.publisher(for: .newWXPayResp)
            .map { noti -> WXPayResponse? in
                return noti.object as? WXPayResponse
        }
        .receive(on: DispatchQueue.main)
        .assign(to: \.payResponse, on: self)
        .store(in: &cancellables)
    }
    
    // MARK: - Private
    
    private var cancellables: [AnyCancellable] = []
}
