import SwiftUI

// MARK: - TextActionViewModel(ViewGeneratable)

struct TextActionViewModel: ViewGeneratable {

    let id = UUID()
    let text: any View
    let action: () -> Void

    // MARK: - ViewGeneratable

    @ViewBuilder
    func view() -> AnyView {
        TextActionView(model: self).anyView()
    }
}

// MARK: - Action Types

extension TextActionViewModel {
   
    enum DeleteChannel {
        static func actions(
            _ shouldShow: Binding<Bool>,
            onDeleteChannel: @escaping () -> Void,
            onDeleteAllUsers: @escaping () -> Void
        ) -> [TextActionViewModel] {
            [
                TextActionViewModel(
                    text: makeAttributedTextItem(),
                    action: {
                        shouldShow.wrappedValue = false
                    }),
                TextActionViewModel(
                    text: Text("Удалить")
                        .font(.title3Semibold20)
                        .foregroundColor(.dodgerBlue)
                        .frame(alignment: .center)
                ) {
                    debugPrint("confirmationDialog Change Role Button")
                    shouldShow.wrappedValue = false
                    onDeleteChannel()
                },
                TextActionViewModel(
                    text: Text("Удалить для всех подписчиков")
                        .font(.title3Regular20)
                        .foregroundColor(.spanishCrimson)
                        .frame(alignment: .center)
                ) {
                    debugPrint("confirmationDialog Change Role Button")
                    shouldShow.wrappedValue = false
                    onDeleteAllUsers()
                }
            ]
        }
        
        static func cancelActions(_ shouldShow: Binding<Bool>) -> [TextActionViewModel] {
            [
                TextActionViewModel(
                    text: Text("Отмена")
                        .font(.title3Semibold20)
                        .foregroundColor(.dodgerBlue)
                ) {
                    debugPrint("confirmationDialog Cancel Button")
                    shouldShow.wrappedValue = false
                }
            ]
        }
        
        @ViewBuilder
        private static func makeAttributedTextItem() -> some View {
            Text("Удалить канал?" + "\n")
                .font(.footnoteSemibold13)
                .foregroundColor(.chineseBlack) +
            Text(
                "Вы точно хотите покинуть канал и удалить его?"
            )
            .font(.footnoteRegular13)
            .foregroundColor(.romanSilver)
        }
    }
    
    enum LeaveChannel {
        static func actions(
            _ shouldShow: Binding<Bool>,
            _ isChannelPublic: Bool,
            onLeaveChannel: @escaping () -> Void
        ) -> [TextActionViewModel] {
            [
                TextActionViewModel(
                    text: makeAttributedTextItem(isChannelPublic),
                    action: {
                        shouldShow.wrappedValue = false
                    }),
                TextActionViewModel(
                    text: Text("Покинуть канал ")
                        .font(.title3Regular20)
                        .foregroundColor(.spanishCrimson)
                        .frame(alignment: .center)
                ) {
                    onLeaveChannel()
                    shouldShow.wrappedValue = false
                }
            ]
        }
        
        static func cancelActions(_ shouldShow: Binding<Bool>) -> [TextActionViewModel] {
            [
                TextActionViewModel(
                    text: Text("Отмена")
                        .font(.title3Semibold20)
                        .foregroundColor(.dodgerBlue)
                ) {
                    debugPrint("confirmationDialog Cancel Button")
                    shouldShow.wrappedValue = false
                }
            ]
        }
        
        @ViewBuilder
        private static func makeAttributedTextItem(_ isChannelPublic: Bool) -> some View {
            let text1 = Text("Вы уверены, что хотите выйти из канала?"
                             + (!isChannelPublic ? "\n" : ""))
                .font(.footnoteSemibold13)
                .foregroundColor(.chineseBlack)
            let text2 = Text(
                "Этот канал не публичный. Вы не сможете повторно присоединиться без приглашения."
            )
            .font(.footnoteRegular13)
            .foregroundColor(.romanSilver)
            if !isChannelPublic {
                return text1 + text2
            } else {
                return text1
            }
        }
    }
    
    enum SelectRole {
        static func actions(_ shouldShow: Binding<Bool>,
                            _ userRole: ChannelRole,
                            onSelectRole: @escaping (ChannelRole) -> Void) -> [TextActionViewModel] {
            var actions: [TextActionViewModel] = [TextActionViewModel(
                text: makeAttributedTextItem(),
                action: {
                    shouldShow.wrappedValue = false
                })]
            if userRole == .owner {
                actions.append(TextActionViewModel(
                    text: Text("Владелец")
                        .font(.title3Regular20)
                        .foregroundColor(.dodgerBlue)
                        .frame(alignment: .center)
                ) {
                    onSelectRole(.owner)
                    shouldShow.wrappedValue = false
                })
            }
            if userRole == .owner || userRole == .admin {
                actions.append(TextActionViewModel(
                    text: Text("Администратор")
                        .font(.title3Regular20)
                        .foregroundColor(.dodgerBlue)
                        .frame(alignment: .center)
                ) {
                    onSelectRole(.admin)
                    shouldShow.wrappedValue = false
                })
            }
            if userRole != .unknown {
                actions.append(TextActionViewModel(
                    text: Text("Пользователь")
                        .font(.title3Regular20)
                        .foregroundColor(.dodgerBlue)
                        .frame(alignment: .center)
                ) {
                    onSelectRole(.user)
                    shouldShow.wrappedValue = false
                })
            }
            return actions
        }
        
        static func cancelActions(_ shouldShow: Binding<Bool>) -> [TextActionViewModel] {
            [
                TextActionViewModel(
                    text: Text("Отмена")
                        .font(.title3Semibold20)
                        .foregroundColor(.dodgerBlue)
                ) {
                    debugPrint("confirmationDialog Cancel Button")
                    shouldShow.wrappedValue = false
                }
            ]
        }
        
        @ViewBuilder
        private static func makeAttributedTextItem() -> some View {
            Text("Выберите роль для участника" + "\n")
                .font(.footnoteSemibold13)
                .foregroundColor(.chineseBlack) +
            Text(
              """
                 Если вы передаете роль - Владелец другому пользователю, то самостоятельно нельзя будет
                 вернуть себе роль.
              """
            )
            .font(.footnoteRegular13)
            .foregroundColor(.romanSilver)
        }
    }
    
    enum MakeRole {
        
        static func actions(
            _ shouldShow: Binding<Bool>,
            onMakeRoleTap: @escaping () -> Void
        ) -> [TextActionViewModel] {
            [
                TextActionViewModel(
                    text: makeAttributedTextItem(),
                    action: {
                        shouldShow.wrappedValue = false
                    }),
                TextActionViewModel(
                    text: Text("Назначить роль")
                        .font(.title3Semibold20)
                        .foregroundColor(.dodgerBlue)
                        .frame(alignment: .center)
                ) {
                    onMakeRoleTap()
                    shouldShow.wrappedValue = false
                }
            ]
        }
        
        static func cancelActions(_ shouldShow: Binding<Bool>) -> [TextActionViewModel] {
            [
                TextActionViewModel(
                    text: Text("Отмена")
                        .font(.title3Semibold20)
                        .foregroundColor(.dodgerBlue)
                ) {
                    debugPrint("confirmationDialog Cancel Button")
                    shouldShow.wrappedValue = false
                }
            ]
        }
        
        @ViewBuilder
        private static func makeAttributedTextItem() -> some View {
            Text("Вы уверены, что хотите выйти из канала?" + "\n")
                .font(.footnoteSemibold13)
                .foregroundColor(.chineseBlack) +
            Text(
              """
                 Этот канал не публичный. Вы не сможете повторно присоединиться без приглашения.

                 Вы владелец канала. Перед уходом вам нужно передать свою роль другому пользователю.
              """
            )
            .font(.footnoteRegular13)
            .foregroundColor(.romanSilver)
        }
    }
    
    enum MakeNewRole {
        
        static func actions(
            _ shouldShow: Binding<Bool>,
            onMakeCurrentUserRoleTap: @escaping () -> Void
        ) -> [TextActionViewModel] {
            [
                TextActionViewModel(
                    text: makeAttributedTextItem(),
                    action: {
                        shouldShow.wrappedValue = false
                    }),
                TextActionViewModel(
                    text: Text("Назначить роль")
                        .font(.title3Semibold20)
                        .foregroundColor(.dodgerBlue)
                        .frame(alignment: .center)
                ) {
                    onMakeCurrentUserRoleTap()
                    shouldShow.wrappedValue = false
                }
            ]
        }
        
        static func cancelActions(_ shouldShow: Binding<Bool>) -> [TextActionViewModel] {
            [
                TextActionViewModel(
                    text: Text("Отмена")
                        .font(.title3Semibold20)
                        .foregroundColor(.dodgerBlue)
                ) {
                    debugPrint("confirmationDialog Cancel Button")
                    shouldShow.wrappedValue = false
                }
            ]
        }
        
        @ViewBuilder
        private static func makeAttributedTextItem() -> some View {
            Text("Вы должны назначить нового владельца перед сменой своей роли" + "\n")
                .font(.footnoteSemibold13)
                .foregroundColor(.romanSilver)
        }
    }
}
