//
//  UserListViewController.swift
//  MyCleanProject
//
//  Created by elly on 10/14/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class UserListViewController: UIViewController {
    private let viewModel: UserListViewModelProtocol
    private let disposeBag = DisposeBag()
    private let saveFavorite = PublishRelay<UserListItem>()
    private let deleteFavorite = PublishRelay<Int>()
    private let fetchMore = PublishRelay<Void>()
    
    private let searchTextField = {
        let textfield = UITextField()
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = UIColor.systemGray.cgColor
        textfield.layer.cornerRadius = 6
        textfield.placeholder = "검색어를 입력해주세요"
        let image = UIImageView(image: .init(systemName: "magnifyingglass"))
        image.frame = .init(x: 0, y: 0, width: 20, height: 20)
        textfield.leftView = image
        textfield.leftViewMode = .always
        textfield.tintColor = .black
        return textfield
    }()
    
    private let tabButtonView = TabButtonView(tabList: [.api, .favorite])
    
    private let tableView = {
        let tableView = UITableView()
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.id)
        return tableView
    }()
    
    init(viewModel: UserListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        setUI()
        bindView()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let tabButtonType = tabButtonView.selectedType.compactMap { $0 }
        let query = searchTextField.rx.text.orEmpty.debounce(.microseconds(300), scheduler: MainScheduler.instance)
        let output = viewModel.transform(input: UserListViewModel.Input(tabButtonType: tabButtonType, query: query, saveFavorite: saveFavorite.asObservable(), deleteFavorite: deleteFavorite.asObservable(), fetchMore: fetchMore.asObservable()))
        
        output.cellData
            .observe(on: MainScheduler.instance)
            .do(onNext: { cellData in
                print("Received cellData: \(cellData)") // cellData 수신 확인
            })
            .bind(to: tableView.rx.items) { [weak self] tableView, index, cellData in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.id) as? UserTableViewCell else { return UITableViewCell() }
            cell.apply(cellData: cellData)
            return cell
        }.disposed(by: disposeBag)
        
        output.error
            .observe(on: MainScheduler.instance)
            .bind { [weak self] errorMessage in
            let alert = UIAlertController(title: "에러", message: errorMessage, preferredStyle: .alert)
            alert.addAction(.init(title: "확인", style: .default))
            self?.present(alert, animated: true)
        }.disposed(by: disposeBag)
    }
    
    private func bindView() {
//        tabButtonView.selectedType.bind { type in
//            print("Type \(type)")
//        }.disposed(by: disposeBag)
    }
    
    private func setUI() {
        view.addSubview(searchTextField)
        view.addSubview(tabButtonView)
        view.addSubview(tableView)
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
        tabButtonView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(tabButtonView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
