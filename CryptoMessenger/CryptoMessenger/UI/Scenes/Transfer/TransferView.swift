import SwiftUI

// MARK: - TransferView

struct TransferView: View {

    // MARK: - Internal Properties

    @ObservedObject var viewModel: TransferViewModel
    @State var transferSum = "5.0"
    @State var dollarCourse = 120.24
    @State var isButtonActive = true

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Divider()
                    .padding(.top, 16)
                Text(R.string.localizable.transferYourAdress().uppercased())
                    .font(.bold(12))
                    .foreground(.darkGray())
                    .padding(.leading, 16)
                    .padding(.top, 24)
                addressCell
                    .background(.white())
                    .padding(.top, 11)
                    .padding(.horizontal, 16)
                Text(R.string.localizable.transferToWhom().uppercased())
                    .font(.bold(12))
                    .foreground(.darkGray())
                    .padding(.leading, 16)
                    .padding(.top, 26)
                chooseContactCell
                    .background(.white())
                    .padding(.top, 12)
                    .padding(.horizontal, 16)
                Divider()
                    .padding(.top, 24)
                Text(R.string.localizable.transferSum().uppercased())
                    .font(.bold(12))
                    .foreground(.darkGray())
                    .padding(.leading, 16)
                    .padding(.top, 24)
                transferCell
                    .padding(.leading, 16)
                    .padding(.trailing, 21)
                    .padding(.top, 21)
                Text(R.string.localizable.transferInDollar() + "\(dollarCourse) USD")
                    .foreground(.darkGray())
                    .font(.regular(12))
                    .padding(.leading, 16)
                    .padding(.top, 19)
            }
            Spacer()
            VStack(spacing: 8) {
                Divider()
                sendButton
                    .frame(width: 213,
                           height: 44)
            }
        }
        .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(R.string.localizable.transferTransfer())
                        .font(.bold(15))
                }
            }
    }

    // MARK: - Private Properties

    private var addressCell: some View {
        HStack(alignment: .center ) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color(.blue(0.1)))
                        .frame(width: 40, height: 40)
                    R.image.chat.logo.image
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("0xSf13S891 ... 3dfasfAgfj1 ")
                        .font(.medium(15))
                        .frame(height: 22)
                    Text("256.41948 AUR")
                        .font(.regular(12))
                        .foreground(.darkGray())
                        .frame(height: 20)
                }
            }
            Spacer()
            R.image.profileDetail.arrow.image
                .frame(width: 20,
                       height: 20,
                       alignment: .center)
        }
    }

    private var chooseContactCell: some View {
        HStack(alignment: .center ) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color(.blue(0.1)))
                        .frame(width: 40, height: 40)
                    R.image.chat.action.contact.image
                }
                Text(R.string.localizable.transferChooseContact())
                    .foregroundColor(.black)
                    .font(.medium(15))
                    .frame(height: 22)
            }
            Spacer()
            R.image.profileDetail.arrow.image
                .frame(width: 20,
                       height: 20,
                       alignment: .center)
        }
    }

    private var transferCell: some View {
        HStack {
            TextField("", text: $transferSum)
                .font(.medium(24))
                .keyboardType(.decimalPad)
            Spacer()
            HStack(spacing: 12) {
                Text("AUR")
                    .font(.medium(24))
                R.image.answers.downsideArrow.image
            }
        }
    }

    private var sendButton: some View {
        Button {
        } label: {
            Text("Отправить")
                .frame(minWidth: 0, maxWidth: 214)
                .font(.semibold(15))
                .padding()
                .foregroundColor(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.white, lineWidth: 2)
                )
        }
        .background(Color(.blue()))
        .cornerRadius(4)
    }
}

extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                  shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // set to `false` if you don't want to detect tap during other gestures
    }
}
