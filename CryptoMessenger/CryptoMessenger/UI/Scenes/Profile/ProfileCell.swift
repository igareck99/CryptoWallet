//
//  ProfileCell.swift
//  CryptoMessenger
//
//  Created by Игорь Коноваленко on 30.07.2021.
//
import UIKit

protocol ReusableView: AnyObject {
    static var identifier: String { get }
}

final class ProfileCell: UICollectionViewCell {

    private enum Constants {
        // MARK: profileImageView layout constants
        static let imageHeight: CGFloat = 123.96
        // MARK: photoButton layout constants
        static let buttonWidth: CGFloat = 25
        static let buttonHeight: CGFloat = 20

    }

    private let profileImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private var photoButton: UIButton = {
        let button = UIButton()
        button.contentMode = .center
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        setupLayouts()
    }

    private func setupViews() {
        contentView.backgroundColor = .white
        contentView.addSubview(profileImageView)
        contentView.addSubview(photoButton)

    }
    private func setupLayouts() {
        profileImageView.snap(parent: self) {
            $0.translatesAutoresizingMaskIntoConstraints = false
        } layout: {
            $0.top.equalTo(self.snp.topMargin).offset(1.04)
            $0.leading.equalTo($1)
            $0.trailing.equalTo($1)
            $0.height.equalTo(Constants.imageHeight)
        }
        photoButton.snap(parent: self) {
            $0.translatesAutoresizingMaskIntoConstraints = false
        } layout: {
            $0.height.equalTo(Constants.buttonHeight)
            $0.width.equalTo(Constants.buttonWidth)
            $0.center.equalTo($1.profileImageView).offset(0)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(with profile: PhotoProfile) {
        profileImageView.image = profile.image
        photoButton = profile.button
    }
}

extension ProfileCell: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
