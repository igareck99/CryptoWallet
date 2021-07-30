//
//  ProfilePhotoCell.swift
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
        // MARK: contentView layout constants
        static let contentViewCornerRadius: CGFloat = 4.0

        // MARK: profileImageView layout constants
        static let imageHeight: CGFloat = 180.0

        // MARK: Generic layout constants
        static let verticalSpacing: CGFloat = 8.0
        static let horizontalPadding: CGFloat = 16.0
        static let profileDescriptionVerticalPadding: CGFloat = 8.0
    }

    private let profileImageView: UIImageView = {
           let imageView = UIImageView(frame: .zero)
           imageView.contentMode = .scaleAspectFill
           return imageView
       }()

       func setup(with profile: Profile) {
        profileImageView.image = profile.image
       }
}

extension ProfileCell: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
