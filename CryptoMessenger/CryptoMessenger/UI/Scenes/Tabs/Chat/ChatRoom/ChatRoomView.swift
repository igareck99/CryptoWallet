import Combine
import SwiftUI

// MARK: - ChatRoomView

struct ChatRoomView: View {

    // MARK: - Internal Properties

    @SwiftUI.Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ChatRoomViewModel

    // MARK: - Private Properties

    @State private var scrolled = false

    // MARK: - Lifecycle

    var body: some View {
        content
            .onAppear {
                viewModel.send(.onAppear)
            }
    }

    private var content: some View {
        ZStack {
            Color(.custom(#colorLiteral(red: 0.6705882353, green: 0.7647058824, blue: 0.8352941176, alpha: 1))).edgesIgnoringSafeArea(.all)

            VStack {
                headerView

                ScrollViewReader { reader in
                    ScrollView {
                        VStack {
                            ForEach(viewModel.messages) { message in
                                switch message.type {
                                case let .text(text):
                                    HStack {
                                        if message.isCurrentUser {
                                            Spacer()
                                        }

                                        ChatBubble(direction: message.isCurrentUser ? .right : .left) {
                                            HStack {
                                                Text(text)
                                                    .lineLimit(nil)

                                                VStack {
                                                    Spacer()

                                                    Text(message.date)
                                                        .frame(height: 10)
                                                        .font(.light(12))
                                                        .foreground(.black(0.5))
                                                        .padding(.bottom, -3)
                                                }

                                                if message.isCurrentUser {
                                                    VStack {
                                                        Spacer()

                                                        Image(R.image.chat.readCheck.name)
                                                            .resizable()
                                                            .frame(width: 13.5, height: 10, alignment: .center)
                                                            .padding(.bottom, -3)
                                                    }

                                                }
                                            }
                                            .modifier(BubbleModifier(isCurrentUser: message.isCurrentUser))
                                        }
                                        .padding(
                                            .top,
                                            message.isCurrentUser == viewModel.previous(message)?.isCurrentUser ? 12 : 28
                                        )
                                        .padding(message.isCurrentUser ? .leading : .trailing, 8)
                                        .onAppear {
                                            if message.id == self.viewModel.messages.last?.id && !scrolled {
                                                reader.scrollTo(viewModel.messages.last?.id, anchor: .bottom)
                                                scrolled = true
                                            }
                                        }.onChange(of: viewModel.messages) { _ in
                                            reader.scrollTo(viewModel.messages.last?.id, anchor: .bottom)
                                        }

                                        if !message.isCurrentUser {
                                            Spacer()
                                        }
                                    }
                                default:
                                    EmptyView()
                                }
                            }
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all)

                inputView
            }
            .onTapGesture {
                hideKeyboard()
            }
            .edgesIgnoringSafeArea(.all)
        }
    }

    private var headerView: some View {
        VStack {
            Spacer()

            HStack(alignment: .center) {
                Spacer().frame(width: 16)

                Button(action: {

                }, label: {
                    Image(R.image.navigation.backButton.name)
                        .resizable()
                        .frame(width: 24, height: 24, alignment: .center)
                })

                Spacer().frame(width: 16)

                Image(uiImage: viewModel.userMessage?.avatar ?? UIImage())
                    .resizable()
                    .frame(width: 36, height: 36)
                    .cornerRadius(18)

                Spacer().frame(width: 12)

                VStack(alignment: .leading) {
                    Text(viewModel.userMessage?.name ?? "")
                        .lineLimit(1)
                        .font(.semibold(15))
                        .foreground(.black())
                    Text(viewModel.userMessage?.status == .online ? "онлайн" : "оффлайн")
                        .lineLimit(1)
                        .font(.regular(13))
                        .foreground(.black(0.5))
                }

                Spacer()

                Button(action: {

                }, label: {
                    Image(R.image.navigation.phoneButton.name)
                        .resizable()
                        .frame(width: 24, height: 24, alignment: .center)
                })
                .padding(.trailing, 12)

                Button(action: {

                }, label: {
                    Image(R.image.navigation.settingsButton.name)
                        .resizable()
                        .frame(width: 24, height: 24, alignment: .center)
                })

                Spacer().frame(width: 16)
            }
            .padding(.bottom, 16)
        }
        .frame(height: 106)
        .background(.white())
    }

    private var inputView: some View {
        VStack {
            HStack(spacing: 8) {
                Button(action: {

                }, label: {
                    Image(R.image.chat.plus.name)
                        .resizable()
                        .frame(width: 24, height: 24)
                })
                .padding(.leading, 8)

                HStack {
                    TextField("Сообщение...", text: $viewModel.inputText)
                        .frame(height: 36)
                        .foreground(.black())
                        .keyboardType(.default)
                        .padding([.leading, .trailing], 16)
                }
                .background(Color(.custom(#colorLiteral(red: 0.8549019608, green: 0.8823529412, blue: 0.9137254902, alpha: 1))))
                .clipShape(Capsule())
                .padding(.trailing, viewModel.inputText.isEmpty ? 8 : 0)

                if !viewModel.inputText.isEmpty {
                    Button(action: {
                        viewModel.send(.onSend(.text(viewModel.inputText)))
                    }, label: {
                        Image(systemName: "paperplane.fill")
                            .foreground(.blue())
                            .frame(width: 24, height: 24)
                            .clipShape(Circle())
                    })
                    .padding(.trailing, 8)
                }
            }
            .padding(.top, 8)

            Spacer()
        }
        .frame(height: viewModel.keyboardHeight > 0 ? viewModel.keyboardHeight + 52 : 80)
        .background(.white())
        .edgesIgnoringSafeArea(.all)
        .animation(.default)
    }
}
