//
//  InfoScreenViewController.swift
//  certificates-ios-client
//
//  Created by Apik on 11.05.2023.
//

import UIKit
import SnapKit
import Combine

class InfoScreenViewController: UIViewController {
    
    private let viewModel: InfoScreenViewModelProvider
    
    private var cancellable = Set<AnyCancellable>()
    
    
    private var tableView: UITableView = UITableView()
    private lazy var dataSource = InfoScreenTableViewDataSource.Source(tableView: tableView) { [weak self] tableView, indexPath, item in
        var cellFinal: UITableViewCell
        switch item {
        case .itemTitle(title: let title, content: let content):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InfoTitleTableViewCell.identifier, for: indexPath) as? InfoTitleTableViewCell else {
                return nil
            }
            cell.configure(title: title, content: content)
            cellFinal = cell
            break
            
        case .itemButton(title: let title, icon: let icon):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InfoButtonTableViewCell.identifier, for: indexPath) as?
                    InfoButtonTableViewCell else {
                return nil
            }
            cell.configure(title: title, icon: icon)
            cellFinal = cell
            break
            
            
        case .itemTime(time: let time):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InfoTimeViewCell.identifier, for: indexPath) as?
                    InfoTimeViewCell else {
                return nil
            }
            cell.configure(time: time)
            cellFinal = cell
            break
            
        case .itemStatus(isConfirmed: let isConfirmed):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InfoStatusViewCell.identifier, for: indexPath) as?
                    InfoStatusViewCell else {
                return nil
            }
            cell.configure(isConfirmed: isConfirmed)
            cellFinal = cell
            break
        }
        return cellFinal
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        viewModel.didLoad()
    }
    
    init(viewModel: InfoScreenViewModelProvider){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewModel.infoItemsPublisher.sink { [weak self] items in
            self?.applyItems(items)
        }.store(in: &cancellable)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Qr-Code"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backgroundColor = .accentPrimary

    }
    
    private func deinitTabBar() {
        navigationController?.navigationBar.tintColor = .accentPrimary
        navigationController?.navigationBar.backgroundColor = nil
        navigationController?.navigationBar.topItem?.hidesBackButton = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.topItem?.hidesBackButton = true
        let backButton = UIBarButtonItem(
            image: .iconBack.withRenderingMode(.alwaysTemplate),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        navigationController?.navigationBar.topItem?.setLeftBarButton(backButton, animated: true)
        navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsets(top: 0.0, left: -17.0, bottom: 0.0, right: 0.0)
    }
    
    private func setupUI() {
        setupSubviews()
        setupNavigationBar()
        setupAutoLayout()
    }
        
    private func setupSubviews() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        tableView.alwaysBounceVertical = false
        tableView.separatorStyle = .none
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.register(InfoTitleTableViewCell.self, forCellReuseIdentifier: InfoTitleTableViewCell.identifier)
        tableView.register(InfoButtonTableViewCell.self, forCellReuseIdentifier: InfoButtonTableViewCell.identifier)
        tableView.register(InfoTimeViewCell.self, forCellReuseIdentifier: InfoTimeViewCell.identifier)
        tableView.register(InfoStatusViewCell.self, forCellReuseIdentifier: InfoStatusViewCell.identifier)
    }
        
    private func setupAutoLayout() {
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func applyItems(_ items: [InfoScreenTableViewDataSource.Item]) {
        var snapshot = InfoScreenTableViewDataSource.Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot)
    }
    
    @objc private func backButtonTapped() {
        viewModel.dismiss()
        deinitTabBar()
    }

}

extension InfoScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 6 && indexPath.section == 0 {
            viewModel.copyData()
            ToastManager.show(message: "Coppied to clickBoard", controller: self)
        }
        if indexPath.row == 7 && indexPath.section == 0 {
            let text = viewModel.shereData()
            ShereManager.shereText(text: text, vc: self)
        }
    }
}

