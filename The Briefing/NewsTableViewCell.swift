//
//  NewsTableViewCell.swift
//  The Briefing
//
//  Created by Pranav Sharma on 2024-12-24.
//

import UIKit

class NewsTableViewCellViewModel {
    let title: String
    let subtitle: String
    let imgUrl: URL?
    var imgData: Data? = nil

    init(
        title: String,
        subtitle: String,
        imgUrl: URL?
    ) {
        self.title = title
        self.subtitle = subtitle
        self.imgUrl = imgUrl
    }
}

class NewsTableViewCell: UITableViewCell {
    static let identifer = "NewsTableViewCell"

    private let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()

    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .light)
        return label
    }()

    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .secondarySystemBackground
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsImageView)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(newsTitleLabel)

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        newsTitleLabel.frame = CGRect(
            x: 10, y: 0, width: contentView.frame.size.width - 170,
            height: 70)

        subTitleLabel.frame = CGRect(
            x: 10, y: 70, width: contentView.frame.size.width - 170,
            height: contentView.frame.size.height / 2)

        newsImageView.frame = CGRect(
            x: contentView.frame.size.width - 150, y: 5, width: 140,
            height: contentView.frame.size.height - 10)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLabel.text = nil
        subTitleLabel.text = nil
        newsImageView.image = nil
    }

    func configure(with viewModel: NewsTableViewCellViewModel) {
        newsTitleLabel.text = viewModel.title
        subTitleLabel.text = viewModel.subtitle

        if let data = viewModel.imgData {
            let image = UIImage(data: data)
            newsImageView.image = image
        } else if let url = viewModel.imgUrl {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data  = data, error == nil else {
                    return
                }
                viewModel.imgData = data
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
