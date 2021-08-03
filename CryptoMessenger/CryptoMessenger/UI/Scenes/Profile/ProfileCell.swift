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

    private var profileImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupLayouts()
    }

    private func setupLayouts() {
        profileImageView.snap(parent: self) {
            $0.contentMode = .scaleAspectFill
        } layout: {
            $0.top.equalTo(self.snp_topMargin)
            $0.leading.equalTo($1)
            $0.trailing.equalTo($1)
            }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(with profile: PhotoProfile) {
        profileImageView.image = profile.image
    }
}

extension ProfileCell: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
