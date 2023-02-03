import SwiftUI

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
                        debugPrint("confirmationDialog makeAttributedTextItem")
                        shouldShow.wrappedValue = false
                    }),
                TextActionViewModel(
                    text: Text("Удалить")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.azureRadianceApprox)
                        .frame(alignment: .center)
                ) {
                    debugPrint("confirmationDialog Change Role Button")
                    shouldShow.wrappedValue = false
                    onDeleteChannel()
                },
                TextActionViewModel(
                    text: Text("Удалить для всех подписчиков")
                        .font(.system(size: 20))
                        .foregroundColor(.amaranthApprox)
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
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.azureRadianceApprox)
                ) {
                    debugPrint("confirmationDialog Cancel Button")
                    shouldShow.wrappedValue = false
                }
            ]
        }
        
        @ViewBuilder
        private static func makeAttributedTextItem() -> some View {
            Text("Удалить канал?" + "\n")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.woodSmokeApprox) +
            Text(
                "Вы точно хотите покинуть канал и удалить его?"
            )
            .font(.system(size: 13))
            .foregroundColor(.regentGrayApprox)
        }
    }
    
    enum LeaveChannel {
        static func actions(
            _ shouldShow: Binding<Bool>,
            onLeaveChannel: @escaping () -> Void
        ) -> [TextActionViewModel] {
            [
                TextActionViewModel(
                    text: makeAttributedTextItem(),
                    action: {
                        debugPrint("confirmationDialog makeAttributedTextItem")
                        shouldShow.wrappedValue = false
                    }),
                TextActionViewModel(
                    text: Text("Покинуть канал ")
                        .font(.system(size: 20))
                        .foregroundColor(.amaranthApprox)
                        .frame(alignment: .center)
                ) {
                    debugPrint("confirmationDialog Change Role Button")
                    onLeaveChannel()
                    shouldShow.wrappedValue = false
                }
            ]
        }
        
        static func cancelActions(_ shouldShow: Binding<Bool>) -> [TextActionViewModel] {
            [
                TextActionViewModel(
                    text: Text("Отмена")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.azureRadianceApprox)
                ) {
                    debugPrint("confirmationDialog Cancel Button")
                    shouldShow.wrappedValue = false
                }
            ]
        }
        
        @ViewBuilder
        private static func makeAttributedTextItem() -> some View {
            Text("Вы уверены, что хотите выйти из канала?" + "\n")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.woodSmokeApprox) +
            Text(
                "Этот канал не публичный. Вы не сможете повторно присоединиться без приглашения."
            )
            .font(.system(size: 13))
            .foregroundColor(.regentGrayApprox)
        }
    }
    
    enum SelectRole {
        static func actions(_ shouldShow: Binding<Bool>, onSelectRole: @escaping (ChannelRole) -> Void) -> [TextActionViewModel] {
            [
                TextActionViewModel(
                    text: makeAttributedTextItem(),
                    action: {
                        debugPrint("confirmationDialog makeAttributedTextItem")
                        shouldShow.wrappedValue = false
                    }),
                TextActionViewModel(
                    text: Text("Владелец")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.azureRadianceApprox)
                        .frame(alignment: .center)
                ) {
                    debugPrint("confirmationDialog Change Role Button")
                    onSelectRole(.owner)
                    shouldShow.wrappedValue = false
                },
                TextActionViewModel(
                    text: Text("Администратор")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.azureRadianceApprox)
                        .frame(alignment: .center)
                ) {
                    debugPrint("confirmationDialog Change Role Button")
                    onSelectRole(.admin)
                    shouldShow.wrappedValue = false
                },
                TextActionViewModel(
                    text: Text("Пользователь")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.azureRadianceApprox)
                        .frame(alignment: .center)
                ) {
                    debugPrint("confirmationDialog Change Role Button")
                    onSelectRole(.user)
                    shouldShow.wrappedValue = false
                }
            ]
        }
        
        static func cancelActions(_ shouldShow: Binding<Bool>) -> [TextActionViewModel] {
            [
                TextActionViewModel(
                    text: Text("Отмена")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.azureRadianceApprox)
                ) {
                    debugPrint("confirmationDialog Cancel Button")
                    shouldShow.wrappedValue = false
                }
            ]
        }
        
        @ViewBuilder
        private static func makeAttributedTextItem() -> some View {
            Text("Выберите роль для участника" + "\n")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.woodSmokeApprox) +
            Text(
              """
                 Если вы передаете роль - Владелец другому пользователю, то самостоятельно нельзя будет
                 вернуть себе роль.
              """
            )
            .font(.system(size: 13))
            .foregroundColor(.regentGrayApprox)
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
                        debugPrint("confirmationDialog makeAttributedTextItem")
                        shouldShow.wrappedValue = false
                    }),
                TextActionViewModel(
                    text: Text("Назначить роль")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.azureRadianceApprox)
                        .frame(alignment: .center)
                ) {
                    debugPrint("confirmationDialog Change Role Button")
                    onMakeRoleTap()
                    shouldShow.wrappedValue = false
                }
            ]
        }
        
        static func cancelActions(_ shouldShow: Binding<Bool>) -> [TextActionViewModel] {
            [
                TextActionViewModel(
                    text: Text("Отмена")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.azureRadianceApprox)
                ) {
                    debugPrint("confirmationDialog Cancel Button")
                    shouldShow.wrappedValue = false
                }
            ]
        }
        
        @ViewBuilder
        private static func makeAttributedTextItem() -> some View {
            Text("Вы уверены, что хотите выйти из канала?" + "\n")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.woodSmokeApprox) +
            Text(
              """
                 Этот канал не публичный. Вы не сможете повторно присоединиться без приглашения.

                 Вы владелец канала. Перед уходом вам нужно передать свою роль другому пользователю.
              """
            )
            .font(.system(size: 13))
            .foregroundColor(.regentGrayApprox)
        }
    }
}
