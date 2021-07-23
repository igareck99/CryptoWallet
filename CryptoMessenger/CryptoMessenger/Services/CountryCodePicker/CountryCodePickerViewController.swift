import PhoneNumberKit
import UIKit

// MARK: - CountryCodePickerDelegate

protocol CountryCodePickerDelegate: AnyObject {
    func countryCodePickerViewControllerDidPickCountry(
        _ controller: CountryCodePickerViewController,
        country: CountryCodePickerViewController.Country
    )
}

// MARK: - CountryCodePickerViewController

final class CountryCodePickerViewController: UITableViewController {

    // MARK: - Internal Properties

    weak var delegate: CountryCodePickerDelegate?

    static let baseCountry: Country? = .init(for: PhoneHelper.userRegionCode, with: PhoneNumberKit())

    // MARK: - Private Properties

    private lazy var searchController = UISearchController(searchResultsController: nil)
    private let phoneNumberKit = PhoneNumberKit()
    private let commonCountryCodes: [String] = PhoneNumberKit.CountryCodePicker.commonCountryCodes
    private var selectedCountryCode: Country?
    private var filteredCountries: [Country] = []

    private lazy var allCountries = phoneNumberKit
        .allCountries()
        .compactMap({ Country(for: $0, with: phoneNumberKit) })
        .sorted(by: { $0.name.caseInsensitiveCompare($1.name) == .orderedAscending })

    private lazy var countries: [[Country]] = {
        Dictionary(grouping: allCountries) { $0.name.firstLetter }
            .sorted { $0.key < $1.key }
            .map { $0.value }
    }()

    // MARK: - Lifecycle

    init() {
        super.init(style: .grouped)
        setup()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.background(.white())
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.barTintColor(.white())
    }

    // MARK: - Private Methods

    private func setup() {
        title = R.string.localizable.countryCodePickerScreenTitle()
        tableView.register(CountryTableViewCell.self)
        tableView.rowHeight = 44
        tableView.sectionHeaderHeight = 24
        tableView.sectionFooterHeight = 0
        tableView.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.background(.white())
        searchController.searchBar.searchTextField.background(.lightGray(0.2))
        searchController.searchBar.setValue(R.string.localizable.countryCodePickerCancel(), forKey: "cancelButtonText")
        searchController.searchBar.placeholder = R.string.localizable.countryCodePickerSearch()
        searchController.searchBar.sizeToFit()
        let appearance = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        appearance.setTitleTextAttributes([.foregroundColor: #colorLiteral(red: 0.2431372549, green: 0.6039215686, blue: 0.8862745098, alpha: 1)], for: .normal)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    private func country(for indexPath: IndexPath) -> Country {
        isFiltering ? filteredCountries[indexPath.row] : countries[indexPath.section][indexPath.row]
    }

    // MARK: - Country

    struct Country {
        var code: String
        var flag: String
        var name: String
        var prefix: String

        init?(for countryCode: String, with phoneNumberKit: PhoneNumberKit) {
            let flagBase = UnicodeScalar("🇦").value - UnicodeScalar("A").value
            let regionCode = PhoneHelper.userRegionCode

            guard
                let name = NSLocale(localeIdentifier: regionCode).displayName(forKey: .countryCode, value: countryCode),
                let prefix = phoneNumberKit.countryCode(for: countryCode)?.description
            else {
                return nil
            }

            self.code = countryCode
            self.name = name
            self.prefix = "+" + prefix
            self.flag = ""

            countryCode.uppercased().unicodeScalars.forEach {
                if let scaler = UnicodeScalar(flagBase + $0.value) {
                    flag.append(String(describing: scaler))
                }
            }

            if flag.count != 1 { return nil }
        }
    }
}

// MARK: - CountryCodePickerViewController (UITableViewDataSource)

extension CountryCodePickerViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        isFiltering ? 1 : countries.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFiltering ? filteredCountries.count : countries[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let country = country(for: indexPath)
        let cell = tableView.dequeue(CountryTableViewCell.self, indexPath: indexPath)
        cell.configure(country.name + " " + country.prefix)
        return cell
    }
}

// MARK: - CountryCodePickerViewController (UITableViewDelegate)

extension CountryCodePickerViewController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard !isFiltering else { return nil }

        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 24))
        header.background(.lightGray())
        let title = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.frame.width - 16, height: 24))
        title.text = countries[section].first?.name.firstLetter
        title.font(.medium(15))
        title.textColor(.black())
        title.textAlignment = .left
        header.addSubview(title)

        return header
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.countryCodePickerViewControllerDidPickCountry(self, country: country(for: indexPath))

        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = true

        delay(0.28) {
            tableView.deselectRow(at: indexPath, animated: true)
            self.dismiss(animated: true) { self.dismiss(animated: true) }
        }
    }
}

// MARK: - CountryCodePickerViewController (UISearchResultsUpdating)

extension CountryCodePickerViewController: UISearchResultsUpdating {
    var isFiltering: Bool { searchController.isActive && !isSearchBarEmpty }
    var isSearchBarEmpty: Bool { searchController.searchBar.text?.isEmpty ?? true }

    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        filteredCountries = allCountries.filter {
            $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.code.lowercased().contains(searchText.lowercased()) ||
                $0.prefix.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
}

extension CountryCodePickerViewController {

    // MARK: - CountryTableViewCell

    final class CountryTableViewCell: UITableViewCell {

        // MARK: - Private Properties

        private lazy var nameLabel = UILabel()
        private lazy var checkImageView = UIImageView()

        // MARK: - Lifecycle

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            selectionStyle = .none
            addNameLabel()
            addCheckImageView()
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("not implemented")
        }

        override var isSelected: Bool {
            didSet {
                if isSelected {
                    UIView.animate(withDuration: 0.25) { self.checkImageView.alpha = 1 }
                } else {
                    checkImageView.alpha = 0
                }
            }
        }

        // MARK: - Internal Methods

        func configure(_ name: String) {
            isSelected = false
            nameLabel.text = name
        }

        // MARK: - Private Methods

        private func addNameLabel() {
            nameLabel.snap(parent: contentView) {
                $0.font(.regular(15))
                $0.textColor(.black())
                $0.textAlignment = .left
            } layout: {
                $0.centerY.equalTo($1)
                $0.leading.equalTo($1).offset(16)
            }
        }

        private func addCheckImageView() {
            checkImageView.snap(parent: contentView) {
                $0.image = R.image.countryCode.check()
                $0.alpha = 0
            } layout: {
                $0.width.height.equalTo(24)
                $0.centerY.equalTo($1)
                $0.leading.equalTo(self.nameLabel.snp.trailing).offset(12)
                $0.trailing.equalTo($1).offset(-16)
            }
        }
    }
}
