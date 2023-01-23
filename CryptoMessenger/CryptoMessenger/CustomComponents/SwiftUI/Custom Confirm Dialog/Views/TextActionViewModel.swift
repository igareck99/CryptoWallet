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

// MARK: - Mocks

extension TextActionViewModel {
    
    enum LeaveChannel {
        static func actionsMock(_ shouldShow: Binding<Bool>) -> [TextActionViewModel] {
            [
                TextActionViewModel(
                    text: makeAttributedTextItem(),
                    action: {
                        debugPrint("confirmationDialog makeAttributedTextItem")
                        shouldShow.wrappedValue.toggle()
                    }),
                TextActionViewModel(
                    text: Text("Покинуть канал ")
                        .font(.system(size: 20))
                        .foregroundColor(.amaranthApprox)
                        .frame(alignment: .center)
                ) {
                    debugPrint("confirmationDialog Change Role Button")
                    shouldShow.wrappedValue.toggle()
                }
            ]
        }
        
        static func cancelActionsMock(_ shouldShow: Binding<Bool>) -> [TextActionViewModel] {
            [
                TextActionViewModel(
                    text: Text("Отмена")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.azureRadianceApprox)
                ) {
                    debugPrint("confirmationDialog Cancel Button")
                    shouldShow.wrappedValue.toggle()
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
        static func actionsMock(_ shouldShow: Binding<Bool>) -> [TextActionViewModel] {
            [
                TextActionViewModel(
                    text: makeAttributedTextItem(),
                    action: {
                        debugPrint("confirmationDialog makeAttributedTextItem")
                        shouldShow.wrappedValue.toggle()
                    }),
                TextActionViewModel(
                    text: Text("Владелец")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.azureRadianceApprox)
                        .frame(alignment: .center)
                ) {
                    debugPrint("confirmationDialog Change Role Button")
                    shouldShow.wrappedValue.toggle()
                },
                TextActionViewModel(
                    text: Text("Администратор")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.azureRadianceApprox)
                        .frame(alignment: .center)
                ) {
                    debugPrint("confirmationDialog Change Role Button")
                    shouldShow.wrappedValue.toggle()
                },
                TextActionViewModel(
                    text: Text("Пользователь")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.azureRadianceApprox)
                        .frame(alignment: .center)
                ) {
                    debugPrint("confirmationDialog Change Role Button")
                    shouldShow.wrappedValue.toggle()
                }
            ]
        }
        
        static func cancelActionsMock(_ shouldShow: Binding<Bool>) -> [TextActionViewModel] {
            [
                TextActionViewModel(
                    text: Text("Отмена")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.azureRadianceApprox)
                ) {
                    debugPrint("confirmationDialog Cancel Button")
                    shouldShow.wrappedValue.toggle()
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
        
        static func actionsMock(_ shouldShow: Binding<Bool>) -> [TextActionViewModel] {
            [
                TextActionViewModel(
                    text: makeAttributedTextItem(),
                    action: {
                        debugPrint("confirmationDialog makeAttributedTextItem")
                        shouldShow.wrappedValue.toggle()
                    }),
                TextActionViewModel(
                    text: Text("Назначить роль")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.azureRadianceApprox)
                        .frame(alignment: .center)
                ) {
                    debugPrint("confirmationDialog Change Role Button")
                    shouldShow.wrappedValue.toggle()
                }
            ]
        }
        
        static func cancelActionsMock(_ shouldShow: Binding<Bool>) -> [TextActionViewModel] {
            [
                TextActionViewModel(
                    text: Text("Отмена")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.azureRadianceApprox)
                ) {
                    debugPrint("confirmationDialog Cancel Button")
                    shouldShow.wrappedValue.toggle()
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
