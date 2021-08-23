import UIKit

// MARK: - CallListView

final class CallListView: UIView {

    // MARK: - Internal Properties

    var didTap: (() -> Void)?

    // MARK: - Private Properties

    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    private lazy var testLabel = UILabel()
    var callList: [CallStruct] = []
    let cellId = "cellId"

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        background(.white())
        createCallListArray()
        setTableViewDelegates()
        setupTabelView()

    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func createCallListArray() {
        callList.append(CallStruct(name: "Martin Randolph", dateTime: "19 сен 18:59", image: R.image.callList.user1()))
        callList.append(CallStruct(name: "Karen Castillo", dateTime: "07 сен 18:36", image: R.image.callList.user2()))
        callList.append(CallStruct(name: "Kieron Dotson", dateTime: "04 сен 18:11", image: R.image.callList.user3()))
    }

    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: - Private Methods

    private func setupTabelView() {
        tableView.snap(parent: self) {
            $0.register(CallCell.self, forCellReuseIdentifier: "cellId")
            $0.allowsSelection = true
            $0.isUserInteractionEnabled = true
            $0.translatesAutoresizingMaskIntoConstraints = false
        } layout: {
            $0.top.equalTo($1).offset(103)
            $0.leading.trailing.bottom.equalTo($1)
        }
    }

}

extension CallListView: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return callList.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 69
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CallCell
        let currentLastItem = callList[indexPath.row]
        cell.configure(currentLastItem)
        return cell
    }

}
