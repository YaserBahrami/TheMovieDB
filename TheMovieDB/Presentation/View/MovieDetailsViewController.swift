//
//  MovieDetailsViewController.swift
//  TheMovieDB
//
//  Created by Yaser on 13.01.2025.
//

import UIKit
import SnapKit

class MovieDetailsViewController: UIViewController {
    private let viewModel: MovieDetailsViewModel
    
    init(viewModel: MovieDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        let label = UILabel()
        view.addSubview(label)
        label.snp.makeConstraints { $0.center.equalToSuperview() }
        label.text = viewModel.movie.title
    }
}
