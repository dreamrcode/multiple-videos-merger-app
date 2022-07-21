//
//  InitialViewController.swift
//  Multiple Videos Merger App
//
//  Created by Alejandro Giron on 7/20/22.
//

import UIKit

class VideoTableViewCell: UITableViewCell {

    lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "thumbnail"))
        imageView.backgroundColor = .darkGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setUpUI() {
        self.addSubview(thumbnailImageView)
        self.addSubview(titleLabel)
        self.addSubview(subtitleLabel)
        NSLayoutConstraint.activate([
            thumbnailImageView.widthAnchor.constraint(equalToConstant: self.safeAreaLayoutGuide.layoutFrame.width),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 150),
            thumbnailImageView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            thumbnailImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8.0),
            thumbnailImageView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 8.0),
            thumbnailImageView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -8.0),
            
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 8.0),
            titleLabel.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 8.0),
            titleLabel.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -8.0),
            
            subtitleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),
            subtitleLabel.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 8.0),
            subtitleLabel.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -8.0),
            subtitleLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8.0),
        ])
    }

}
