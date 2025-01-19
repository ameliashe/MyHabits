//
//  InfoViewController.swift
//  MyHabits
//
//  Created by Amelia Shekikhacheva on 11/24/24.
//

import UIKit

class InfoViewController: UIViewController {

	let model = InfoModel()

	//MARK: UI Elements
	let infoView: UIScrollView = {
		let view = UIScrollView()
		view.isScrollEnabled = true
		view.backgroundColor = .systemBackground
		view.contentInsetAdjustmentBehavior = .never
		view.showsVerticalScrollIndicator = true
		view.showsHorizontalScrollIndicator = false
		return view
	}()

	let contentView = UIView()

	let headingLabel: UILabel = {
		let label = UILabel()
		label.textColor = .black
		label.font = .systemFont(ofSize: 20, weight: .semibold)
		label.text = "Привычка за 21 день"
		return label
	}()

	let bodyLabel: UILabel = {
		let label = UILabel()
		label.textColor = .label
		label.font = .systemFont(ofSize: 17, weight: .regular)
		label.text = ""
		label.numberOfLines = 0
		label.lineBreakMode = .byWordWrapping
		return label
	}()

	//MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
		setupText()
		setupNavigationBar()

		addSubviews()
		setupConstraints()
    }

	//MARK: UI Setup
	func setupNavigationBar() {
		title = "Информация"
		view.backgroundColor = .white
		navigationController?.navigationBar.isTranslucent = false
	}

	func addSubviews() {
		view.addSubview(infoView)
		infoView.addSubview(contentView)
		contentView.addSubview(headingLabel)
		contentView.addSubview(bodyLabel)
	}

	func setupConstraints() {
		infoView.translatesAutoresizingMaskIntoConstraints = false
		headingLabel.translatesAutoresizingMaskIntoConstraints = false
		contentView.translatesAutoresizingMaskIntoConstraints = false
		bodyLabel.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			// Ограничения для infoView
			infoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			infoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

			// Ограничения для contentView
			contentView.topAnchor.constraint(equalTo: infoView.contentLayoutGuide.topAnchor),
			contentView.leadingAnchor.constraint(equalTo: infoView.contentLayoutGuide.leadingAnchor),
			contentView.trailingAnchor.constraint(equalTo: infoView.contentLayoutGuide.trailingAnchor),
			contentView.bottomAnchor.constraint(equalTo: infoView.contentLayoutGuide.bottomAnchor),
			contentView.widthAnchor.constraint(equalTo: infoView.widthAnchor),

			// Ограничения для headingLabel
			headingLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),
			headingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			headingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

			// Ограничения для bodyLabel
			bodyLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 16),
			bodyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			bodyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
		])
	}

	func setupText() {
		headingLabel.text = model.headingText
		bodyLabel.text = model.bodyText
	}
}
