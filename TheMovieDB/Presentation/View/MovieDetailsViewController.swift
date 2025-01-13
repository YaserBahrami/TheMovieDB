//
//  MovieDetailsViewController.swift
//  TheMovieDB
//
//  Created by Yaser on 13.01.2025.
//

import UIKit
import SnapKit
import SDWebImage

class MovieDetailsViewController: UIViewController {
    private let viewModel: MovieDetailsViewModel
    
    // UI Components
    private let backdropImageView = UIImageView()
    private let titleLabel = UILabel()
    private let releaseDateLabel = UILabel()
    private let ratingLabel = UILabel()
    private let overviewTitleLabel = UILabel()
    private let overviewLabel = UILabel()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
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
        populateData()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        
        // ScrollView to handle longer content
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        // Backdrop Image
        backdropImageView.contentMode = .scaleAspectFill
        backdropImageView.clipsToBounds = true
        contentView.addSubview(backdropImageView)
        backdropImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200) // Adjusted height
        }
        
        // Title Label
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor.label
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backdropImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        // Release Date Label
        releaseDateLabel.font = .systemFont(ofSize: 16)
        releaseDateLabel.textColor = UIColor.secondaryLabel
        contentView.addSubview(releaseDateLabel)
        releaseDateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        // Rating Label
        ratingLabel.font = .systemFont(ofSize: 16)
        ratingLabel.textColor = UIColor.systemBlue
        contentView.addSubview(ratingLabel)
        ratingLabel.snp.makeConstraints { make in
            make.top.equalTo(releaseDateLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        // Overview Title Label
        overviewTitleLabel.font = .boldSystemFont(ofSize: 18)
        overviewTitleLabel.text = "Overview"
        overviewTitleLabel.textColor = UIColor.label
        contentView.addSubview(overviewTitleLabel)
        overviewTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(ratingLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        // Overview Label
        overviewLabel.font = .systemFont(ofSize: 14)
        overviewLabel.numberOfLines = 0
        overviewLabel.textColor = UIColor.secondaryLabel
        contentView.addSubview(overviewLabel)
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(overviewTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-16) // Ensures scrollable content
        }
    }
    
    private func populateData() {
        titleLabel.text = viewModel.movie.title
        releaseDateLabel.text = "Release Date: \(viewModel.movie.releaseDate ?? "N/A")"
        ratingLabel.text = "Rating: \(viewModel.movie.voteAverage) / 10"
        overviewLabel.text = viewModel.movie.overview
        
        if let backdropURL = viewModel.movie.backdropImageURL {
            self.backdropImageView.sd_setImage(with: backdropURL, completed: nil)
        }
    }
}
