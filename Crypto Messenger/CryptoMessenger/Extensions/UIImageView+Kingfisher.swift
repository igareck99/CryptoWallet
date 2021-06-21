import Kingfisher

// MARK: UIImageView (Kingfisher)

extension UIImageView {

    // MARK: - Internal Methods

    func download(
        from link: String?,
        options: KingfisherOptionsInfo = [
            .transition(.fade(0.2)),
            .cacheOriginalImage
        ],
        placeholder: UIImage? = nil,
        completionWithOptions completion: ((UIImage?) -> Void)? = nil
    ) {
        guard let link = link, let url = URL(string: link) else {
            image = placeholder
            completion?(nil)
            return
        }

        kf.setImage(
            with: ImageResource(downloadURL: url),
            placeholder: placeholder,
            options: options,
            completionHandler: { result in
                switch result {
                case let .success(value):
                    completion?(value.image)
                case .failure:
                    completion?(nil)
                }
            })
    }
}
