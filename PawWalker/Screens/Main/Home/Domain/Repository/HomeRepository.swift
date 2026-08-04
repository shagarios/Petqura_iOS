//
//  HomeRepository.swift
//  PawWalker
//
//  Created by shagar on 08/07/26.
//

protocol HomeRepository {
    func fetchHome() async throws -> HomeModel
    func fetchBlog() async throws -> BlogListModel
    func fetchUser() 
}
