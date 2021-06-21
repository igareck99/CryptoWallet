import SnapKit

// MARK: Snappable

protocol Snappable: UIView {}

extension Snappable {
    func snap<Parent: Snappable>(
        parent: Parent,
        set: ((Self) -> Void)? = nil,
        layout: @escaping ((_ make: ConstraintMaker, _ view: Parent) -> Void)
    ) {
        if !parent.subviews.contains(self) {
            parent.addSubview(self)
        }

        set?(self)

        snp.makeConstraints { make in
            layout(make, parent)
        }
    }

    func build(_ set: (Self) -> Void) -> Self {
        set(self)
        return self
    }
}

// MARK: - UIView (Snappable)

extension UIView: Snappable {}
