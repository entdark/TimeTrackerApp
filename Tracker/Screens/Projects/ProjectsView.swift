import SwiftUI

struct ProjectsView: View {
	@State private var showProject: Bool = false
	
	@Environment(\.dismiss) var dismiss
	
	@ObservedObject var viewModel: ProjectsViewModel
	var returnAction: ((ProjectViewModel?) -> ())?
	
	var body: some View {
		ZStack {
			Rectangle()
				.fill(Color(uiColor: .secondarySystemBackground))
				.ignoresSafeArea()
			if !viewModel.projects.isEmpty {
				List {
					ForEach(viewModel.projects) { project in
						@ObservedObject var project = project
						
						HStack(content: {
							if let icon = project.icon {
								Image(systemName: icon)
									.foregroundStyle(project.color.toColor())
/*									.resizable()
									.scaledToFit()
									.frame(width: 16)*/
							} else if project.color != .none {
								Image(systemName: "circle.fill")
									.foregroundStyle(project.color.toColor())
							} else {
								Spacer()
									.frame(maxWidth: 32)
							}
							Text(project.title)
							Spacer()
							if project.selected {
								Image(systemName: "checkmark")
									.resizable()
									.scaledToFit()
									.frame(width: 16)
							}
						})
//						.listRowSeparator(.hidden, edges: .top)
//						.listRowInsets(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
						.listRowBackground(Color.clear)
						.contentShape(Rectangle())
						.onTapGesture {
							viewModel.selectedProject = project
						}
					}
				}
				.listStyle(.plain)
			} else {
				VStack(alignment: .center) {
					VStack(alignment: .center, spacing: 4) {
						Text("Проектов пока нет")
							.multilineTextAlignment(.center)
							.font(.title2)
							.foregroundStyle(.secondary)
						Text("Нажмите «+» чтобы создать новый проект")
							.padding(.horizontal, 36)
							.multilineTextAlignment(.center)
							.font(.body)
							.foregroundStyle(.tertiary)
					}
					.frame(maxHeight: .infinity)
					Button() {
						
					} label: {
						HStack(alignment: .center ,spacing: 8) {
							Image(systemName: "plus")
								.imageScale(.large)
							Text("Создать проект")
						}
						.frame(maxWidth: .infinity)
					}
					.buttonStyle(.glassProminent)
					.controlSize(.large)
					.padding(16)
				}
			}
		}
		.navigationTitle("Мои проекты")
		.navigationBarTitleDisplayMode(.large)
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Button("Add", systemImage: "plus") {
					showProject.toggle()
				}
				.sheet(isPresented: $showProject) {
					NavigationView {
						ProjectView(viewModel: ProjectViewModel()) { project in
							viewModel.addProject(project)
						}
					}
				}
			}
			ToolbarSpacer(.fixed, placement: .topBarTrailing)
			ToolbarItem(placement: .topBarTrailing) {
				Button("Save", systemImage: "checkmark") {
					returnAction?(viewModel.saveProject())
					dismiss()
				}
			}
		}
	}
}

#Preview {
	NavigationView {
		ProjectsView(viewModel: ProjectsViewModel())
	}
}
