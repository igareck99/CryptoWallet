import SwiftUI
// swiftlint:disable all
struct CustomConfirmDialog: ViewModifier {
	@Binding var isPresented: Bool
    let actionsAlignment: Alignment
	@ViewBuilder let actions: () -> [any ViewGeneratable]
	@ViewBuilder let cancelActions: () -> [any ViewGeneratable]

	func body(content: Content) -> some View {
		ZStack {
			content
				.frame(maxWidth: .infinity, maxHeight: .infinity)

			ZStack(alignment: .bottom) {
				if isPresented {
                    Color.primary.opacity(0.2)
						.ignoresSafeArea()
						.onTapGesture {
							isPresented = false
						}
						.transition(.opacity)
				}

				if isPresented {
					VStack {
						GroupBox {
							makeViewsGroup(views: actions)
								.frame(maxWidth: .infinity, alignment: actionsAlignment)
                                .frame(minHeight: 61)
						}
						.cornerRadius(14)
                        .groupBoxStyle(CustomGroupBoxStyle())

						GroupBox {
							makeViewsGroup(views: cancelActions)
								.frame(maxWidth: .infinity, alignment: .center)
                                .frame(minHeight: 61, maxHeight: 61)
						}
						.cornerRadius(14)
                        .groupBoxStyle(CustomGroupBoxStyle())
					}
					.padding(.horizontal, 8)
					.transition(.move(edge: .bottom))
				}
			}
		}
		.animation(.easeInOut, value: isPresented)
	}

	private func makeViewsGroup(
		views: @escaping () -> [any ViewGeneratable]
	) -> some View {
		let actionModels = views()
		return VStack(alignment: .center) {
			ForEach(actionModels, id: \.hashValue) { model in
				model.view()
				if actionModels.count > 1 &&
					actionModels.last?.hashValue != model.hashValue {
					Divider()
				}
			}
		}
	}
}

extension View {
	func customConfirmDialog(
		isPresented: Binding<Bool>,
        actionsAlignment: Alignment,
		actions: @escaping () -> [any ViewGeneratable],
		cancelActions: @escaping () -> [any ViewGeneratable]
	) -> some View {
		modifier(
			CustomConfirmDialog(
                isPresented: isPresented,
                actionsAlignment: actionsAlignment,
				actions: actions,
				cancelActions: cancelActions
			)
		)
	}
}

struct CustomGroupBoxStyle : GroupBoxStyle {
    
    func makeBody(configuration: GroupBoxStyle.Configuration) -> some View {
        configuration.content
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(.white)
            )
    }
}
