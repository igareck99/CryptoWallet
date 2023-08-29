import SwiftUI
import PhoneNumberKit

// MARK: - IPhoneNumberField

extension IPhoneNumberField {

    // MARK: - Internal Methods

    func font(_ font: UIFont?) -> Self {
        var view = self
        view.font = font
        return view
    }

    @available(iOS 14, *)
    func foregroundColor(_ color: Color?) -> Self {
        if let color = color {
            return foregroundColor(UIColor(color))
        } else {
            return nilForegroundColor()
        }
    }

    func foregroundColor(_ color: CGColor?) -> Self {
        if let color = color {
            return foregroundColor(UIColor(cgColor: color))
        } else {
            return nilForegroundColor()
        }
    }

    func foregroundColor(_ color: UIColor?) -> Self {
        var view = self
        view.textColor = color
        return view
    }

    private func nilForegroundColor() -> Self {
        var view = self
        view.textColor = nil
        return view
    }

    @available(iOS 14, *)
    func placeholderColor(_ color: Color?) -> Self {
        self
            .numberPlaceholderColor(color)
            .countryCodePlaceholderColor(color)
    }

    func placeholderColor(_ color: UIColor?) -> Self {
        self
            .numberPlaceholderColor(color)
            .countryCodePlaceholderColor(color)
    }

    func placeholderColor(_ color: CGColor?) -> Self {
        self
            .numberPlaceholderColor(color)
            .countryCodePlaceholderColor(color)
    }

    @available(iOS 14, *)
    func numberPlaceholderColor(_ color: Color?) -> Self {
        if let color = color {
            return numberPlaceholderColor(UIColor(color))
        } else {
            return nilNumberPlaceholderColor()
        }
    }

    func numberPlaceholderColor(_ color: UIColor?) -> Self {
        var view = self
        view.numberPlaceholderColor = color
        return view
    }

    func numberPlaceholderColor(_ color: CGColor?) -> Self {
        if let color = color {
            return numberPlaceholderColor(UIColor(cgColor: color))
        } else {
            return nilNumberPlaceholderColor()
        }
    }

    @available(iOS 14, *)
    func countryCodePlaceholderColor(_ color: Color?) -> Self {
        if let color = color {
            return countryCodePlaceholderColor(UIColor(color))
        } else {
            return nilCountryPlaceholderColor()
        }
    }

    func countryCodePlaceholderColor(_ color: UIColor?) -> Self {
        var view = self
        view.countryCodePlaceholderColor = color
        return view
    }

    func countryCodePlaceholderColor(_ color: CGColor?) -> Self {
        if let color = color {
            return countryCodePlaceholderColor(UIColor(cgColor: color))
        } else {
            return nilCountryPlaceholderColor()
        }
    }
    
    private func nilPlaceholderColor() -> Self {
        self
            .nilNumberPlaceholderColor()
            .nilCountryPlaceholderColor()
    }

    private func nilNumberPlaceholderColor() -> Self {
        var view = self
        view.numberPlaceholderColor = nil
        return view
    }

    private func nilCountryPlaceholderColor() -> Self {
        var view = self
        view.countryCodePlaceholderColor = nil
        return self
    }

    func multilineTextAlignment(_ alignment: TextAlignment) -> Self {
        var view = self
        switch alignment {
        case .leading:
            view.textAlignment = layoutDirection ~= .leftToRight ? .left : .right
        case .trailing:
            view.textAlignment = layoutDirection ~= .leftToRight ? .right : .left
        case .center:
            view.textAlignment = .center
        }
        return view
    }

    func clearsOnEditingBegan(_ shouldClear: Bool) -> Self {
        var view = self
        view.clearsOnBeginEditing = shouldClear
        return view
    }

    func clearsOnInsert(_ shouldClear: Bool) -> Self {
        var view = self
        view.clearsOnInsertion = shouldClear
        return view
    }

    func clearButtonMode(_ mode: UITextField.ViewMode) -> Self {
        var view = self
        view.clearButtonMode = mode
        return view
    }

    func textFieldStyle(_ style: UITextField.BorderStyle) -> Self {
        var view = self
        view.borderStyle = style
        return view
    }

    func maximumDigits(_ max: Int?) -> Self {
        var view = self
        view.maxDigits = max
        return view
    }

    func flagHidden(_ hidden: Bool) -> Self {
        var view = self
        view.showFlag = !hidden
        return view
    }

    func flagSelectable(_ selectable: Bool) -> Self {
        var view = self
        view.selectableFlag = selectable
        return view
    }

    func prefixHidden(_ hidden: Bool) -> Self {
        var view = self
        view.previewPrefix = !hidden
        return view
    }

    func autofillPrefix(_ autofill: Bool) -> Self {
        var view = self
        view.autofillPrefix = autofill
        return view
    }

    func defaultRegion(_ region: String?) -> Self {
        var view = self
        view.defaultRegion = region
        return view
    }

    func disabled(_ disabled: Bool) -> Self {
        var view = self
        view.isUserInteractionEnabled = !disabled
        return view
    }

    func onEditingBegan(perform action: ((UIViewType) -> Void)? = nil) -> Self {
        var view = self
        if let action = action {
            view.onBeginEditingHandler = action
        }
        return view
    }

    func onNumberChange(perform action: ((PhoneNumber?) -> Void)? = nil) -> Self {
        var view = self
        if let action = action {
            view.onPhoneNumberChangeHandler = action
        }
        return view
    }

    func onEdit(perform action: ((UIViewType) -> Void)? = nil) -> Self {
        var view = self
        if let action = action {
            view.onEditingChangeHandler = action
        }
        return view
    }

    func onEditingEnded(perform action: ((UIViewType) -> Void)? = nil) -> Self {
        var view = self
        if let action = action {
            view.onEndEditingHandler = action
        }
        return view
    }

    func onClear(perform action: ((PhoneNumberTextField) -> Void)? = nil) -> Self {
        var view = self
        if let action = action {
            view.onClearHandler = action
        }
        return view
    }

    func onReturn(perform action: ((PhoneNumberTextField) -> Void)? = nil) -> Self {
        var view = self
        if let action = action {
            view.onReturnHandler = action
        }
        return view
    }

    func formatted(_ formatted: Bool = true) -> Self {
        var view = self
        view.formatted = formatted
        return view
    }
}
