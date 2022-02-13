//
//  BlogPostDetailViewController.swift
//  Otoklix Test
//
//  Created by Yudha on 13/02/22.
//

import UIKit
import RxSwift

class BlogPostDetailViewController: UIViewController {

    var post: BlogPost!
    
    var viewModel = MainViewModel()
    var bag = DisposeBag()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publishedLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        self.navigationItem.rightBarButtonItem = editButton
        
        setupRx()
        
        titleLabel.text = ""
        publishedLabel.text = ""
        textView.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getPost(id: post.id)
    }
    
    func setupView() {
        titleLabel.text = post.title
        publishedLabel.text = convertDate(post.published_at)
        textView.text = post.content
    }
    
    func setupRx() {
        viewModel.singlePostObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { post in
                self.post = post
                
                self.setupView()
            })
            .disposed(by: bag)
    }
    
    @objc func editButtonTapped() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "CreatePostViewController") as! CreatePostViewController
        vc.isEdit = true
        vc.post = self.post
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func convertDate(_ date: String) -> String {
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withFullDate, .withFullTime, .withFractionalSeconds]
        let newDate = iso.date(from: date) ?? Date()
        
        let df = DateFormatter()
        df.dateFormat = "HH:mm, dd-MM-yyyy"
        return df.string(from: newDate)
    }
}
