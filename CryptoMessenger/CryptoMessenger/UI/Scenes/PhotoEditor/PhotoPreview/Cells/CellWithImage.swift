import UIKit

// MARK: - ImageCell

protocol ImageCell: UICollectionViewCell {
    var imageView: UIImageView { get }
}

// MARK: - ImageCell ()

extension ImageCell {
    func createConstraints() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func setupUI() {
        addSubview(imageView)
        clipsToBounds = true
    }
}

// MARK: - UIImageView ()

extension UIImageView {
    func enableZoom() {
        isUserInteractionEnabled = true
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming))
        addGestureRecognizer(pinchGesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resetScale))
        tapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(tapGesture)
    }

    @objc private func startZooming(_ sender: UIPinchGestureRecognizer) {
        guard let scale = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale) else { return }

        switch sender.state {
        case .changed:
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut) {
                sender.view?.transform = scale
                sender.scale = 1
            }
        default:
            guard scale.a < 1, scale.d < 1 else { return }
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut) {
                if scale.a < 1, scale.d < 1 {
                    sender.view?.transform = .identity
                    sender.scale = 1
                }
            }
        }
    }

    @objc private func resetScale(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn) {
            sender.view?.transform = .identity
        }
    }
}
