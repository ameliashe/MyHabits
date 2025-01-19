//
//  HabitTableViewCell.swift
//  MyHabits
//
//  Created by Amelia Shekikhacheva on 11/24/24.
//

import UIKit

class HabitCollectionViewCell: UITableViewCell {

	//MARK: Model
	var currentHabit: Habit?


	//MARK: UI Elements
	let habitName: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 17, weight: .semibold)
		label.textColor = .black
		label.numberOfLines = 2
		label.lineBreakMode = .byTruncatingTail
		return label
	}()

	let habitTimeLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 13)
		return label
	}()

	let habitCounter: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 13)
		return label
	}()
	
	let habitTrackButton: UIButton = {
		let button = UIButton()
		button.layer.borderWidth = 2
		button.layer.cornerRadius = 18
		button.layer.masksToBounds = true
		return button
	}()

	let containerView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		view.layer.cornerRadius = 10
		view.layer.masksToBounds = true
		return view
	}()

	var habitColor = UIColor()


	//MARK: Init
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupCellStyle()
		addSubviews()
		setupConstraints()
		setupButton()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func setupCellStyle() {
		backgroundColor = .clear
		selectionStyle = .none
	}

	
	//MARK: UI Setup
	func setupButton() {
		habitTrackButton.addTarget(self, action: #selector(habitTrackButtonTapped), for: .touchUpInside)
	}

	func addSubviews() {
		containerView.addSubview(habitName)
		containerView.addSubview(habitTimeLabel)
		containerView.addSubview(habitCounter)
		containerView.addSubview(habitTrackButton)

		contentView.addSubview(containerView)
	}

	func setupConstraints() {
		habitName.translatesAutoresizingMaskIntoConstraints = false
		habitTimeLabel.translatesAutoresizingMaskIntoConstraints = false
		habitCounter.translatesAutoresizingMaskIntoConstraints = false
		habitTrackButton.translatesAutoresizingMaskIntoConstraints = false
		containerView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			habitName.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
			habitName.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
			habitName.trailingAnchor.constraint(equalTo: habitTrackButton.leadingAnchor, constant: -16),

			habitTimeLabel.topAnchor.constraint(equalTo: habitName.bottomAnchor, constant: 4),
			habitTimeLabel.leadingAnchor.constraint(equalTo: habitName.leadingAnchor),
			habitTimeLabel.trailingAnchor.constraint(equalTo: habitTrackButton.leadingAnchor, constant: -16),

			habitCounter.topAnchor.constraint(equalTo: habitTimeLabel.bottomAnchor, constant: 20),
			habitCounter.leadingAnchor.constraint(equalTo: habitName.leadingAnchor),
			habitCounter.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),

			habitTrackButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
			habitTrackButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -25),
			habitTrackButton.widthAnchor.constraint(equalToConstant: 38),
			habitTrackButton.heightAnchor.constraint(equalToConstant: 38),

			containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
			containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
			containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 130)
		])
	}


	//MARK: User Interaction Methods
	@objc private func habitTrackButtonTapped() {
		guard let habit = currentHabit else { return }


		if habit.isAlreadyTakenToday {

				HabitsStore.shared.untrack(habit)
			} else {

				HabitsStore.shared.track(habit)
			}

		NotificationCenter.default.post(name: NSNotification.Name("HabitsUpdated"), object: nil)
		generateHapticFeedback()
		update(habit)

	}

	private func generateHapticFeedback() {
		let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
		feedbackGenerator.prepare()
		feedbackGenerator.impactOccurred()
	}

	func update(_ habit: Habit) {
		currentHabit = habit

		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .none
		dateFormatter.timeStyle = .short


		habitName.text = habit.name
		habitColor = habit.color
		habitName.textColor = habitColor


		if let counterImage = UIImage(systemName: "checkmark.rectangle.stack") {
			let counterAttachment = NSTextAttachment()
			counterAttachment.image = counterImage.withRenderingMode(.alwaysTemplate)
			counterAttachment.bounds = CGRect(x: 0, y: -2, width: 14, height: 14)

			let CAString = NSMutableAttributedString(attachment: counterAttachment)
			CAString.append(NSAttributedString(string: NSLocalizedString(" Счётчик: ", comment: "Counter label for the number of times the habit has been tracked")))
			CAString.append(NSAttributedString(string: "\(habit.trackDates.count)"))

			habitCounter.attributedText = CAString
			habitCounter.textColor = .habitIndigo.withAlphaComponent(0.5)
		}

		habitTrackButton.isSelected = habit.isAlreadyTakenToday

		if let clockImage = UIImage(systemName: "clock.badge") {
			let clockAttachment = NSTextAttachment()
			clockAttachment.image = clockImage.withRenderingMode(.alwaysTemplate)
			clockAttachment.bounds = CGRect(x: 0, y: -3, width: 14, height: 14)

			let attributedText = NSMutableAttributedString(attachment: clockAttachment)
			attributedText.append(NSAttributedString(string: NSLocalizedString(" Каждый день в ", comment: "Time label showing the daily habit time")))
			attributedText.append(NSAttributedString(string: dateFormatter.string(from: habit.date)))

			habitTimeLabel.attributedText = attributedText
			habitTimeLabel.textColor = .lightGray
		}

		if habit.isAlreadyTakenToday {
			let config = UIImage.SymbolConfiguration(weight: .bold)
			let checkmarkImage = UIImage(systemName: "checkmark", withConfiguration: config)

			habitTrackButton.layer.borderColor = habit.color.cgColor
			habitTrackButton.backgroundColor = habit.color
			habitTrackButton.setImage(checkmarkImage, for: .normal)
			habitTrackButton.tintColor = .white
		} else {
			habitTrackButton.layer.borderColor = habit.color.cgColor
			habitTrackButton.backgroundColor = habit.color.withAlphaComponent(0.15)
			habitTrackButton.setImage(nil, for: .normal)
		}
	}

}
