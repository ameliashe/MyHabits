//
//  ProgressTableViewCell.swift
//  MyHabits
//
//  Created by Amelia Shekikhacheva on 11/24/24.
//

import UIKit

class ProgressCollectionViewCell: UITableViewCell {

	//MARK: UI Elements
	let containerView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		view.layer.cornerRadius = 10
		view.layer.masksToBounds = true
		return view
	}()

	let progressLabel: UILabel = {
		let label = UILabel()
		label.textColor = .systemGray
		label.font = .systemFont(ofSize: 13, weight: .semibold)
		label.text = HabitsStore.shared.todayProgress == 1 ? NSLocalizedString("Все задачи выполнены!🎉", comment: "Message when all tasks are completed") : NSLocalizedString("Всё получится!", comment: "Encouraging message when not all tasks are completed")
		return label
	}()

	let percentLabel: UILabel = {
		let label = UILabel()
		label.textColor = .systemGray
		label.font = .systemFont(ofSize: 13, weight: .semibold)
		label.text = "\(Int(HabitsStore.shared.todayProgress * 100))%"
		return label
	}()

	let progressView: UIProgressView = {
		let view = UIProgressView()
		view.progressTintColor = UIColor(named: "HabitPurple")
		view.trackTintColor = .systemGray2
		view.layer.cornerRadius = 3
		view.layer.masksToBounds = true
		view.setProgress(HabitsStore.shared.todayProgress, animated: true)
		return view
	}()


	//MARK: Init
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupCellStyle()
		addSubviews()
		setupConstraints()

		NotificationCenter.default.addObserver(self, selector: #selector(updateProgress), name: NSNotification.Name("HabitsUpdated"), object: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	//MARK: UI Setup
	func setupCellStyle() {
		backgroundColor = .clear
		selectionStyle = .none
	}

	func addSubviews() {
		containerView.addSubview(progressLabel)
		containerView.addSubview(progressView)
		containerView.addSubview(percentLabel)

		contentView.addSubview(containerView)
	}

	func setupConstraints() {
		containerView.translatesAutoresizingMaskIntoConstraints = false
		progressLabel.translatesAutoresizingMaskIntoConstraints = false
		progressView.translatesAutoresizingMaskIntoConstraints = false
		percentLabel.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
			containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
			containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

			progressLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
			progressLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),

			percentLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
			percentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),

			progressView.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 10),
			progressView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
			progressView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
			progressView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
			progressView.heightAnchor.constraint(equalToConstant: 7),
		])
	}


	//MARK: User Interaction Methods
	@objc func updateProgress() {
		let progress = HabitsStore.shared.todayProgress
		progressView.setProgress(progress, animated: true)
		percentLabel.text = "\(Int(progress * 100))%"
		progressLabel.text = progress == 1 ? "Все задачи выполнены!🎉" : "Всё получится!"
	}

}
