//
//  InfoViewController.swift
//  MyHabits
//
//  Created by Amelia Shekikhacheva on 11/24/24.
//

import UIKit

class InfoViewController: UIViewController {

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
		headingLabel.text = headingText
		bodyLabel.text = bodyText
	}

	let headingText: String = "Привычка за 21 день"

	let bodyText: String = "Прохождение этапов, за которые за 21 день вырабатывается привычка, подчиняется следующему алгоритму: \n\n1. Провести 1 день без обращения к старым привычкам, стараться вести себя так, как будто цель, загаданная в перспективу, находится на расстоянии шага. \n\n2. Выдержать 2 дня в прежнем состоянии самоконтроля. \n\n3. Отметить в дневнике первую неделю изменений и подвести первые итоги — что оказалось тяжело, что — легче, с чем еще предстоит серьезно бороться. \n\n4. Поздравить себя с прохождением первого серьезного порога в 21 день. За это время отказ от дурных наклонностей уже примет форму осознанного преодоления и человек сможет больше работать в сторону принятия положительных качеств. \n\n5. Держать планку 40 дней. Практикующий методику уже чувствует себя освободившимся от прошлого негатива и двигается в нужном направлении с хорошей динамикой. \n\n6. На 90-й день соблюдения техники все лишнее из «прошлой жизни» перестает напоминать о себе, и человек, оглянувшись назад, осознает себя полностью обновившимся. \n\nИсточник: psychbook.ru"
}
