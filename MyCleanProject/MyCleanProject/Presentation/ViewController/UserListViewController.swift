//
//  UserListViewController.swift
//  MyCleanProject
//
//  Created by elly on 10/14/24.
//

import UIKit

class UserListViewController: UIViewController {
    private let viewModel: UserListviewModelProtocol
    
    init(viewModel: UserListviewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .systemPink
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

