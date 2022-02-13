//
//  CreatePostViewController.swift
//  Otoklix Test
//
//  Created by Yudha on 13/02/22.
//

import UIKit
import RxSwift

class CreatePostViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    var isEdit = false
    
    let viewModel = MainViewModel()
    var bag = DisposeBag()
    
    var post: BlogPost?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = isEdit ? "Edit Post" : "Create Post"
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        self.navigationItem.rightBarButtonItem = doneButton
        
        self.contentTextView.layer.borderWidth = 1
        self.contentTextView.layer.borderColor = UIColor.systemBackground.cgColor
        
        setupRx()
        
        if isEdit {
            guard let post = self.post else { return }
            self.titleTextField.text = post.title
            self.contentTextView.text = post.content
        }
    }
    
    func setupRx() {
        viewModel.singlePostObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { post in
                self.showAlert()
            })
            .disposed(by: bag)
    }
    
    func showAlert() {
        let message = isEdit ? "Post edited!" : "Post created!"
        
        let ac = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        
        ac.addAction(okAction)
        
        self.navigationController?.present(ac, animated: true, completion: nil)
    }
    
    @objc func doneButtonTapped() {
        guard let text = titleTextField.text, let content = contentTextView.text else { return }
        
        if isEdit {
            guard let post = post else { return }
            viewModel.editPost(id: post.id, title: text, content: content)
        } else {
            viewModel.createPost(title: text, content: content)
        }
    }
}
