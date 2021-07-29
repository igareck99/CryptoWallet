import UIKit

// MARK: - WalletView

final class WalletView: UIView {

    // MARK: - Internal Properties

    var didTap: (() -> Void)?

    // MARK: - Private Properties

    private lazy var headerView = UIView()
    private lazy var balanceLabel = UILabel()
    private lazy var descriptionLabel = UILabel()
    private lazy var walletImageView = UIImageView()
    private lazy var cardsCollectionView = CarouselCollectionView()
    private lazy var lineView = UIView()
    private lazy var sendButton = LoadingButton()
    private lazy var transactionTitleLabel = UILabel()
    private lazy var allTransactionButton = UIButton()
    private lazy var tableView = UITableView(frame: .zero, style: .plain)

    private var tableProvider: TableViewProvider?
    private var collectionProvider: CollectionViewProvider?
    private var collectionModel: CardViewModel = .init(Array(repeating: .init(currency: ""), count: 5)) {
        didSet {
            if collectionProvider == nil {
                setupCollectionProvider()
            }
            collectionProvider?.reloadData()
        }
    }
    private var tableModel: TransactionViewModel = .init(transactions) {
        didSet {
            if tableProvider == nil {
                setupTableProvider()
            }
            tableProvider?.reloadData()
        }
    }

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        background(.white())
        addWalletImageView()
        addBalanceLabel()
        addDescriptionLabel()
        addCardsCollectionView()
        addLineView()
        addSendButton()
        addTransactionTitleLabel()
        addAllTransactionButton()
        setupCollectionProvider()
        addTransactionsTableView()
        setupTableProvider()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func startLoading() {
        sendButton.showLoader(userInteraction: false)
        delay(1.4) {
            self.stopLoading()
        }
    }

    func stopLoading() {
        sendButton.hideLoader()
    }

    // MARK: - Actions

    @objc private func sendButtonTap() {
        vibrate()
        sendButton.indicator = MaterialLoadingIndicator(color: .blue())
        sendButton.animateScaleEffect {
            self.startLoading()
        }
    }

    @objc private func allTransactionButtonTap() {
        vibrate()
    }

    // MARK: - Private Methods

    private func addWalletImageView() {
        walletImageView.snap(parent: headerView) {
            $0.image = R.image.wallet.wallet()
        } layout: {
            $0.top.equalTo($1).offset(27)
            $0.leading.equalTo($1).offset(16)
            $0.width.height.equalTo(60)
        }
    }

    private func addBalanceLabel() {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineHeightMultiple = 0.84
        paragraph.alignment = .left

        balanceLabel.snap(parent: headerView) {
            $0.titleAttributes(
                text: "$12 5131.53",
                [
                    .color(.black()),
                    .font(.medium(22)),
                    .paragraph(paragraph)
                ]
            )
            $0.textAlignment = .left
        } layout: {
            $0.top.equalTo($1).offset(36)
            $0.leading.equalTo(self.walletImageView.snp.trailing).offset(12)
            $0.trailing.equalTo($1).offset(-16)
            $0.height.equalTo(22)
        }
    }

    private func addDescriptionLabel() {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineHeightMultiple = 1.42
        paragraph.alignment = .left

        descriptionLabel.snap(parent: headerView) {
            $0.titleAttributes(
                text: "Общий баланс",
                [
                    .color(.black()),
                    .font(.regular(13)),
                    .paragraph(paragraph)
                ]
            )
            $0.textAlignment = .left
        } layout: {
            $0.top.equalTo(self.balanceLabel.snp_bottomMargin).offset(8)
            $0.leading.equalTo(self.walletImageView.snp.trailing).offset(12)
            $0.trailing.equalTo($1).offset(-16)
        }
    }

    private func addCardsCollectionView() {
        cardsCollectionView.snap(parent: headerView) {
            $0.dataSource = self.collectionProvider
            $0.delegate = self.collectionProvider
            $0.background(.clear)
        } layout: {
            $0.top.equalTo(self.walletImageView.snp.bottom).offset(16)
            $0.leading.trailing.equalTo($1)
            $0.height.equalTo(193)
        }
    }

    private func addLineView() {
        lineView.snap(parent: headerView) {
            $0.background(.lightGray())
        } layout: {
            $0.top.equalTo(self.cardsCollectionView.snp.bottom).offset(26)
            $0.leading.trailing.equalTo($1)
            $0.height.equalTo(1)
        }
    }

    private func addSendButton() {
        sendButton.snap(parent: headerView) {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.09
            paragraphStyle.alignment = .center

            let title = "Отправить"
            $0.titleAttributes(
                text: title,
                [
                    .color(.white()),
                    .font(.bold(15)),
                    .paragraph(paragraphStyle)
                ]
            )
            $0.background(.blue())
            $0.clipCorners(radius: 8)
            $0.addTarget(self, action: #selector(self.sendButtonTap), for: .touchUpInside)
        } layout: {
            $0.top.equalTo(self.lineView.snp.bottom).offset(16)
            $0.leading.equalTo($1).offset(16)
            $0.trailing.equalTo($1).offset(-16)
            $0.height.equalTo(44)
        }
    }

    private func addTransactionTitleLabel() {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineHeightMultiple = 1.117
        paragraph.alignment = .left

        transactionTitleLabel.snap(parent: headerView) {
            $0.titleAttributes(
                text: "Транзакции",
                [
                    .color(.black()),
                    .font(.semibold(15)),
                    .paragraph(paragraph)
                ]
            )
            $0.textAlignment = .left
        } layout: {
            $0.leading.equalTo($1).offset(16)
            $0.bottom.equalTo($1).offset(-7)
            $0.height.equalTo(20)
        }
    }

    private func addAllTransactionButton() {
        allTransactionButton.snap(parent: headerView) {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.09
            paragraphStyle.alignment = .right

            let title = "Все транзакции"
            $0.titleAttributes(
                text: title,
                [
                    .color(.blue()),
                    .font(.regular(15)),
                    .paragraph(paragraphStyle)
                ]
            )
            $0.addTarget(self, action: #selector(self.allTransactionButtonTap), for: .touchUpInside)
        } layout: {
            $0.trailing.equalTo($1).offset(-16)
            $0.bottom.equalTo($1).offset(-7)
            $0.height.equalTo(20)
        }
    }

    private func addTransactionsTableView() {
        headerView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 460)
        headerView.background(.white())

        tableView.snap(parent: self) {
            $0.separatorStyle = .singleLine
            $0.separatorInset = .init(top: 0, left: 16, bottom: 0, right: 16)
            $0.tableHeaderView = self.headerView
            $0.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 10))
        } layout: {
            $0.top.leading.trailing.bottom.equalTo($1)
        }
    }

    private func setupCollectionProvider() {
        collectionProvider = CollectionViewProvider(collectionView: cardsCollectionView, viewModel: collectionModel)
        collectionProvider?.registerCells([CardCollectionViewCell.self])
        collectionProvider?.onConfigureCell = { [unowned self] indexPath in
            guard
                let cell = self.cardsCollectionView.dequeue(CardCollectionViewCell.self, indexPath: indexPath)
            else {
                return .init()
            }

            return cell
        }
        collectionProvider?.onConfigureCellSize = { _ in
            return CGSize(
                width: CGFloat(CardViewModel.Constants.rowWidth),
                height: CGFloat(CardViewModel.Constants.rowHeight)
            )
        }

        collectionModel = CardViewModel(
            [
                .init(currency: ""),
                .init(currency: ""),
                .init(currency: ""),
                .init(currency: "")
            ]
        )
    }

    private func setupTableProvider() {
        tableProvider = TableViewProvider(for: tableView, with: tableModel)
        tableProvider?.registerCells([TransactionTableViewCell.self])
        tableProvider?.onConfigureCell = { [unowned self] indexPath in
            guard let provider = self.tableProvider else { return .init() }
            let cell: TransactionTableViewCell = provider.dequeueReusableCell(for: indexPath)
            cell.configure(tableModel.items[indexPath.section])
            return cell
        }
    }
}

private var transactions: [Transaction] = [
    .init(
        cryptocurrency: "- 0.0236  ETH",
        currency: "15.53 USD",
        type: .writeOff,
        date: "Sep 10 From:0x314...ff91"
    ),
    .init(
        cryptocurrency: "+ 1.12 ETH",
        currency: "2.50 USD",
        type: .inflow,
        date: "Sep 09 From:0xks1...ka9a"
    ),
    .init(
        cryptocurrency: "- 0.0236  ETH",
        currency: "15.53 USD",
        type: .writeOff,
        date: "Sep 10 From:0x314...ff91"
    ),
    .init(
        cryptocurrency: "+ 1.12 ETH",
        currency: "2.50 USD",
        type: .inflow,
        date: "Sep 09 From:0xks1...ka9a"
    ),
    .init(
        cryptocurrency: "- 0.0236  ETH",
        currency: "15.53 USD",
        type: .writeOff,
        date: "Sep 10 From:0x314...ff91"
    ),
    .init(
        cryptocurrency: "+ 1.12 ETH",
        currency: "2.50 USD",
        type: .inflow,
        date: "Sep 09 From:0xks1...ka9a"
    )
]
