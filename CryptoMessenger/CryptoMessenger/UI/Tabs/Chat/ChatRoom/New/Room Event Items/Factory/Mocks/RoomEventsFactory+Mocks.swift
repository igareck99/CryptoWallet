import Foundation

extension RoomEventsFactory {
    static var mockItems: [any ViewGeneratable] {
        [
            makeMapItem1(),
            makeSystemEventItem1(),
            makeVideoItem1(),
            makeVideoItem2(),
            makeImageItem1(),
            makeImageItem2(),
            makeSystemEventItem2(),
            makeLeftTextItem1(),
            makeLeftTextItem2(),
            makeTextLeftItem3(),
            makeSystemEventItem3(),
            makeAvataredLeftItem(),
            makeTextRightNotSentItem(),
            makeTextRightItem(),
            makeRightCallItem(),
            makeLeftCallItem(),
            makeSystemEventItem4(),
            makeEqualRightCallItem(),
            makeEqualLeftCallItem(),
            makeDocItem1(),
            makeDocItem2(),
            makeDocItem3(),
            makeSystemEventItem1(),
            makeContactItem1(),
            makeContactItem2(),
            makeContactItem3(),
            makeSystemEventItem2(),
            makeTransactionItem1(),
            makeTransactionItem2(),
            makeTransactionItem3(),
            makeSystemEventItem3(),
            makeImageItem1()
        ]
    }
}
