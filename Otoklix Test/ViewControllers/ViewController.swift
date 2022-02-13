//
//  ViewController.swift
//  Otoklix Test
//
//  Created by Yudha on 13/02/22.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    var viewModel = MainViewModel()
    var bag = DisposeBag()
    
    var posts: [BlogPost] = []
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "Blog"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createPost))
        self.navigationItem.rightBarButtonItem = addButton
        
        setupRx()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getPosts()
    }
    
    func setupRx() {
        viewModel.postsObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { items in
                self.posts = items
                
                self.posts = self.posts.sorted { self.convertDate(date: $0.published_at).compare(self.convertDate(date: $1.published_at)) == .orderedDescending }
                
                self.tableView.reloadData()
                
            })
            .disposed(by: bag)
        
        viewModel.singlePostObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { item in
                self.viewModel.getPosts()
            })
            .disposed(by: bag)
    }
    
    func convertDate(date: String) -> Date {
        let df = ISO8601DateFormatter()
        df.formatOptions = [.withFullDate, .withFullTime, .withFractionalSeconds]
        return df.date(from: date) ?? Date()
    }
    
    @objc func createPost() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "CreatePostViewController") as! CreatePostViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        let item = posts[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = item.title
        content.secondaryText = item.content
        
        content.secondaryTextProperties.numberOfLines = 2
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let ac = UIAlertController(title: "Delete Post", message: "Are you sure you want to delete post?", preferredStyle: .alert)
            let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
            let yesAction = UIAlertAction(title: "Yes", style: .destructive) { ac in
                self.viewModel.deletePost(id: self.posts[indexPath.row].id)
            }
            
            ac.addAction(noAction)
            ac.addAction(yesAction)
            
            self.navigationController?.present(ac, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "BlogPostDetailViewController") as! BlogPostDetailViewController
        vc.post = posts[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

