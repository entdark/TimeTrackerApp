import SwiftUI

struct ProjectView: View {
	private static let icons: [String?] = [
		nil,
		"leaf.fill",
		"heart.fill",
		"eye.fill",
		"keyboard.fill",
		"figure.walk",
		"shield.lefthalf.fill",
		"map.fill",
		"sun.max.fill",
		"cart.fill",
		"creditcard.fill",
		"car.fill"
	]
	
	@Environment(\.dismiss) var dismiss
	
	@ObservedObject var viewModel: ProjectViewModel
	var resultAction: ((ProjectViewModel) -> ())?
	
	var body: some View {
		List {
			Section {
				let icon = viewModel.icon ?? ""
				let backgroundColor = viewModel.icon != nil ? .clear : viewModel.color.toColor()
				Image(systemName: "circle.fill")
					   .resizable()
					   .scaledToFit()
					   .foregroundStyle(backgroundColor)
					   .frame(maxWidth: .infinity, maxHeight: 44)
					   .overlay {
						   Image(systemName: icon)
							   .resizable()
							   .scaledToFit()
							   .foregroundStyle(viewModel.color.toColor())
							   .frame(width: 27, height: 27)
					   }
				TextField("Название проекта", text: $viewModel.title)
			}
			Section() {
				let gridItems = [
					GridItem(.flexible(minimum: 32), spacing: 0),
					GridItem(.flexible(minimum: 32), spacing: 0),
					GridItem(.flexible(minimum: 32), spacing: 0),
					GridItem(.flexible(minimum: 32), spacing: 0),
					GridItem(.flexible(minimum: 32), spacing: 0),
					GridItem(.flexible(minimum: 32), spacing: 0)
				]
				LazyVGrid(columns: gridItems, alignment: .center, spacing: 0, content: {
					ForEach(ProjectColor.allCases, id: \.self) { color in
						Image(systemName: "circle.fill")
							.resizable()
							.foregroundStyle(color.toColor())
							.scaledToFit()
							.frame(width: 32, height: 32)
							.padding(8)
							.overlay {
								if color == .none {
									DiagonalStrikethroughShape()
										.stroke(Color(uiColor: .systemGray), lineWidth: 1)
										.frame(width: 32, height: 32)
								}
								if color == viewModel.color {
									Circle()
										.stroke(Color(red: 0.329, green: 0.329, blue: 0.337, opacity: 0.34), lineWidth: 2)
										.frame(width: 40, height: 40)
								}
							}
							.onTapGesture {
								viewModel.color = color
							}
					}
				})
				.aspectRatio(contentMode: .fill)
			}
			Section() {
				let gridItems = [
					GridItem(.flexible(minimum: 32), spacing: 0),
					GridItem(.flexible(minimum: 32), spacing: 0),
					GridItem(.flexible(minimum: 32), spacing: 0),
					GridItem(.flexible(minimum: 32), spacing: 0),
					GridItem(.flexible(minimum: 32), spacing: 0),
					GridItem(.flexible(minimum: 32), spacing: 0)
				]
				LazyVGrid(columns: gridItems, alignment: .center, spacing: 0, content: {
					ForEach(ProjectView.icons, id: \.self) { icon in
						Image(systemName: "circle.fill")
							.resizable()
							.foregroundStyle(Color(uiColor: .systemGray5))
							.scaledToFit()
							.frame(width: 32, height: 32)
							.padding(8)
							.overlay {
								if let icon {
									Image(systemName: icon)
										.resizable()
										.scaledToFit()
										.foregroundStyle(.primary)
										.frame(width: 16, height: 16)
								}
								if icon == ProjectView.icons[0] {
									DiagonalStrikethroughShape()
										.stroke(Color(uiColor: .systemGray), lineWidth: 1)
										.frame(width: 32, height: 32)
								}
								if icon == viewModel.icon {
									Circle()
										.stroke(Color(red: 0.329, green: 0.329, blue: 0.337, opacity: 0.34), lineWidth: 2)
										.frame(width: 40, height: 40)
								}
							}
							.onTapGesture {
								viewModel.icon = icon
							}
					}
				})
				.aspectRatio(contentMode: .fill)
			}
		}
		.navigationTitle("Добавление проекта")
		.toolbarTitleDisplayMode(.inline)
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Button("Save", systemImage: "checkmark") {
					resultAction?(viewModel.save())
					dismiss()
				}
				.buttonStyle(.glassProminent)
			}
			ToolbarItem(placement: .topBarLeading) {
				Button("Close", systemImage: "xmark") {
					dismiss()
				}
			}
		}
	}
	
	private struct DiagonalStrikethroughShape: Shape {
		func path(in rect: CGRect) -> Path {
			var path = Path()
			path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
			path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
			return path
		}
	}
}

#Preview {
	NavigationView {
		ProjectView(viewModel: ProjectViewModel())
	}
}
