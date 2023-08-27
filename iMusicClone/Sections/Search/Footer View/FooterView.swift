//
//  FooterView.swift
//  iMusicClone
//
//  Created by Buzurgmexr Sultonaliyev on 27/08/23.
//

import UIKit

class FooterView: UIView {
  private let label: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = UIColor(rgb: 0xa1a5a9)
    return label
  }()

  private let loader: UIActivityIndicatorView = {
    let loader = UIActivityIndicatorView()
    loader.translatesAutoresizingMaskIntoConstraints = false
    loader.hidesWhenStopped = true
    return loader
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupElements()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func showLoader() {
    loader.startAnimating()
    label.text = "LOADING..."
  }

  func hideLoader() {
    loader.stopAnimating()
    label.text = ""
  }

  /// Setup ``FooterView`` using `label` and `loader`.
  private func setupElements() {
    addSubview(label)
    addSubview(loader)

    NSLayoutConstraint.activate([
      loader.topAnchor.constraint(equalTo: topAnchor, constant: 8),
      loader.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      loader.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 20),

      label.centerXAnchor.constraint(equalTo: centerXAnchor),
      label.topAnchor.constraint(equalTo: loader.bottomAnchor, constant: 8)
    ])
  }
}
