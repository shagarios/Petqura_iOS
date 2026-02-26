//
//  BlogDetailViewModel.swift
//  PawWalker
//
//  Created by shagar on 14/05/25.
//

import Foundation
import Combine

class BlogDetailViewModel : ObservableObject {
    @Published var blog : Blog?
    @Published var blogId : String = ""
    @Injected var apiClient : ApiClientProtocol
    @Injected var internet : NetworkMonitor
    private var cancellable = Set<AnyCancellable>()
    @Published var isLoading : Bool = false
    
    init(blogId : String) {
        self.blogId = blogId
    }
    
    func fetchBlogData() {
        if internet.isConnectedToInternet {
            isLoading = true
            apiClient.APIRequest(router: .blogDetail(blogId: blogId), responseType: BlogDetailModel.self)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.isLoading = false
                        ToastCenter.shared.showToast(error.backendError?.message ?? TextResource.apiError)
                    }
                } receiveValue: { response in
                    self.isLoading = false
                    if let result = response.result {
                        self.blog = result
                    }
                }
                .store(in: &cancellable)
        }
    }
}
