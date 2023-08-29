import Foundation

extension RoomEventsFactory {
    static var mockItems: [any ViewGeneratable] {
        [
            makeLeftTextItem1(),
            makeLeftTextItem2(),
            makeTextLeftItem3(),
            makeAvataredLeftItem(),
            makeTextRightNotSentItem(),
            makeTextRightItem(),
            makeRightCallItem(),
            makeLeftCallItem(),
            makeEqualRightCallItem(),
            makeEqualLeftCallItem(),
            makeDocItem1(),
            makeDocItem2(),
            makeDocItem3(),
            makeContactItem1(),
            makeContactItem2(),
            makeContactItem3(),
            makeTransactionItem1(),
            makeTransactionItem2(),
            makeTransactionItem3(),
            makeImageItem1()
        ]
    }
}
