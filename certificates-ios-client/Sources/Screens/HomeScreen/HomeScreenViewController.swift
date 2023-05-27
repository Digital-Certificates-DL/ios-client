//
//  ViewController.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 5/9/23.
//

import UIKit
import SnapKit
import Combine
import Mantis
import secp256k1


class HomeScreenViewController: UIViewController {
    private typealias DataSource = HomeScreenTableViewDataSource
    private let viewModel: HomeScreenViewModelProvider
    private var cancellable = Set<AnyCancellable>()
    
    var imagePicker = UIImagePickerController()
    
    private lazy var selectScanOptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Select scan option"
        label.font = .ginoraBold
        label.textColor = .black
        return label
    }()
    
    private lazy var youCanScanLabel: UILabel = {
        let label = UILabel()
        label.text = "You can scan the QR-code with your camera or upload the required image"
        label.numberOfLines = 0
        label.font = .p16InterRegular
        label.textColor = .black
        return label
    }()
    
    private var tableView: UITableView = UITableView()
    private lazy var dataSource = HomeScreenTableViewDataSource.Source(tableView: tableView) { [weak self] tableView, indexPath, item in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ActionTableViewCell.identifier, for: indexPath) as? ActionTableViewCell else {
            return nil
        }
        cell.configure(image: item.image, title: item.title)
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        viewModel.didLoad()
    }
    
    init(viewModel: HomeScreenViewModelProvider) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewModel.actionsPublisher.sink { [weak self] actions in
            self?.applyItems(actions)
        }.store(in: &cancellable)
    }
    
    private func setupUI() {
        setupSubviews()
        setupAutoLayout()
    }
    
    private func setupSubviews() {
        view.backgroundColor = .white
        
        view.addSubview(selectScanOptionLabel)
        view.addSubview(youCanScanLabel)
        view.addSubview(tableView)
                
        Secp256k1Manager().test3()
        
        tableView.alwaysBounceVertical = false
        tableView.separatorStyle = .none
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.register(ActionTableViewCell.self, forCellReuseIdentifier: ActionTableViewCell.identifier)
    }
        

    private func setupAutoLayout() {
        selectScanOptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80.0)
            make.leading.trailing.equalToSuperview().inset(16.0)
        }
        youCanScanLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16.0)
            make.top.equalTo(selectScanOptionLabel.snp.bottom).offset(12.0)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(youCanScanLabel.snp.bottom).offset(8.0)
            make.leading.trailing.equalToSuperview().inset(16.0)
            make.bottom.equalToSuperview()
        }
    }
    
    private func applyItems(_ items: [HomeScreenTableViewDataSource.Item]) {
        var snapshot = HomeScreenTableViewDataSource.Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot)
    }
}

extension HomeScreenViewController: UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 && indexPath.section == 0 {
            viewModel.selectUseCameraAction()
        }
        if indexPath.row == 1 && indexPath.section == 0 {
            
            setPicture()
            
        }
    }
    
    
  
    func setPicture() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            viewModel.selectUploadImageAction(image: image)
        }
        
    }

}
