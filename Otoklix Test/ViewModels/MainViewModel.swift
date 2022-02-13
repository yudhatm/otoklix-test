//
//  MainViewModel.swift
//  Otoklix Test
//
//  Created by Yudha on 13/02/22.
//

import Foundation
import RxSwift
import RxCocoa

protocol MainViewModelType {
    var postsObservable: Observable<[BlogPost]> { get }
    var errorObservable: Observable<Error> { get }
    var singlePostObservable: Observable<BlogPost> { get }
}

final class MainViewModel: MainViewModelType {
    
    var disposeBag = DisposeBag()
    
    var postsSubject = PublishSubject<[BlogPost]>()
    var errorSubject = PublishSubject<Error>()
    var singlePostSubject = PublishSubject<BlogPost>()
    
    lazy var postsObservable: Observable<[BlogPost]> = self.postsSubject.asObservable()
    lazy var errorObservable: Observable<Error> = self.errorSubject.asObservable()
    lazy var singlePostObservable: Observable<BlogPost> = self.singlePostSubject.asObservable()
    
    func getPosts() {
        let url = "https://limitless-forest-49003.herokuapp.com/posts"
        
        let observable: Observable<[BlogPost]> = NetworkManager.shared.getRequest(url, parameters: [:])
        
        observable.subscribe(onNext: { posts in
            print("posts model ---")
            print(posts)
            
            self.postsSubject.onNext(posts)
        }, onError: { error in
            self.errorSubject.onNext(error)
        }, onCompleted: {
            print("get posts completed")
        }).disposed(by: disposeBag)
    }
    
    func getPost(id: Int) {
        let url = "https://limitless-forest-49003.herokuapp.com/posts/\(id)"
        
        let observable: Observable<BlogPost> = NetworkManager.shared.getRequest(url, parameters: [:])
        
        observable.subscribe(onNext: { post in
            print("single posts model ---")
            print(post)
            
            self.singlePostSubject.onNext(post)
        }, onError: { error in
            self.errorSubject.onNext(error)
        }, onCompleted: {
            print("get single post completed")
        }).disposed(by: disposeBag)
    }
    
    func createPost(title: String, content: String) {
        let url = "https://limitless-forest-49003.herokuapp.com/posts"
        let param = ["title": title, "content": content]
        
        let observable: Observable<BlogPost> = NetworkManager.shared.postRequest(url, parameters: param)
        
        observable.subscribe(onNext: { post in
            print("create post model ---")
            print(post)
            
            self.singlePostSubject.onNext(post)
        }, onError: { error in
            self.errorSubject.onNext(error)
        }, onCompleted: {
            print("create posts completed")
        }).disposed(by: disposeBag)
    }
    
    func deletePost(id: Int) {
        let url = "https://limitless-forest-49003.herokuapp.com/posts/\(id)"
        
        let observable: Observable<BlogPost> = NetworkManager.shared.deleteRequest(url, parameters: [:])
        
        observable.subscribe(onNext: { post in
            print("delete model ---")
            print(post)
            
            self.singlePostSubject.onNext(post)
        }, onError: { error in
            self.errorSubject.onNext(error)
        }, onCompleted: {
            print("delete posts completed")
        }).disposed(by: disposeBag)
    }
    
    func editPost(id: Int, title: String, content: String) {
        let url = "https://limitless-forest-49003.herokuapp.com/posts/\(id)"
        let param = ["title": title, "content": content]
        
        let observable: Observable<BlogPost> = NetworkManager.shared.putRequest(url, parameters: param)
        
        observable.subscribe(onNext: { post in
            print("edit post model ---")
            print(post)
            
            self.singlePostSubject.onNext(post)
        }, onError: { error in
            self.errorSubject.onNext(error)
        }, onCompleted: {
            print("edit posts completed")
        }).disposed(by: disposeBag)
    }
}
