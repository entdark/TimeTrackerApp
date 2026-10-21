import SwiftUI

struct TaskView: View {
	@State private var showProjects: Bool = false
	
	@Environment(\.dismiss) var dismiss
	
	@ObservedObject var viewModel: TaskViewModel
	var editing = false
	var resultAction: ((TaskViewModel) -> ())?
	
	var body: some View {
		List {
			Section {
				TextField("Заголовок", text: $viewModel.title)
					.font(.title3)
					.fontWeight(.semibold)
				TextField("Описание", text: $viewModel.details)
			}
			Section("Привязка к проекту") {
				HStack(alignment: .center, spacing: 0) {
					NavigationLink(value: 2) {
						if let project = viewModel.project {
							if let icon = project.icon {
								Image(systemName: icon)
									.foregroundStyle(project.color.toColor())
							} else if project.color != .none {
								Image(systemName: "circle.fill")
									.foregroundStyle(project.color.toColor())
							}
							Text(project.title)
						} else {
							Text("Без проекта")
								.foregroundStyle(.tertiary)
							Spacer()
								.frame(maxWidth: .infinity)
							Button("Добавить") {
								showProjects.toggle()
							}
						}
					}
				}
			}
			Section("Отчет") {
				TextEditor(text: $viewModel.comment)
/*					.overlay {
						Text("Комментарий")
//							.frame(width: .leastNormalMagnitude, height: .leastNormalMagnitude, alignment: .topLeading)
					}*/
			}
		}
		.navigationTitle(editing ? "Cводка по задаче" : "Создание задачи")
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
		.navigationDestination(for: Int.self) { _ in
			let projectsViewModel = ProjectsViewModel(selectedProject: viewModel.project)
			ProjectsView(viewModel: projectsViewModel) { project in
				viewModel.project = project
			}
		}
	}
}

#Preview {
	NavigationStack {
		TaskView(viewModel: TaskViewModel(/*model: TaskModel(title: "heh")*/))
	}
}
