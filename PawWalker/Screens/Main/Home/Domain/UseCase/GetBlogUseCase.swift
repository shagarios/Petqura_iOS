//
//  GetBlogUseCase.swift
//  PawWalker
//
//  Created by shagar on 09/07/26.
//

import Foundation

final class GetBlogUseCase  {
    private var blogRepository : HomeRepository
    init(blogRepository: HomeRepository) {
        self.blogRepository = blogRepository
    }
    
    func execute() async throws -> [Blog]{
        do {
            let response : BlogListModel = try await blogRepository.fetchBlog()
            guard let blogs = response.result?.blogs else {
                throw AppError.notFound
            }
            return blogs
        }
    }
}
