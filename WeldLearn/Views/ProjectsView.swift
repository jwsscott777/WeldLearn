//
//  ProjectsView.swift
//  WeldLearn
//
//  Created by JWSScott777 on 1/8/21.
//

import SwiftUI

struct ProjectsView: View {
    static let openTag: String? = "Open"
    static let closedTag: String? = "Closed"
    @StateObject var viewModel: ViewModel


    var projectsList: some View {
        List(selection: $viewModel.selectedItem) {
            ForEach(viewModel.projects) { project in
                Section(header: ProjectHeaderView(project: project)) {
                    ForEach(project.projectItems(using: viewModel.sortOrder)) { item in
                        ItemRowView( project: project, item: item)
                            .contextMenu {
                                Button("Delete", role: .destructive) {
                                    viewModel.delete(item)
                                }
                            }
                            .tag(item)
                    }
                    .onDelete { offsets in
                        viewModel.delete(offsets, from: project)
                    }
                    if viewModel.showClosedProjects == false {
                        Button {
                            withAnimation {
                            viewModel.addItem(to: project)
                            }
                        } label: {
                           // Label("Add New Item", systemImage: "plus")
                            HStack {
                                Image(systemName: "plus")
                                    .foregroundColor(.secondary)
                                Text("Add New Item")
                            }
                        }
                        .buttonStyle(.borderless)
                    }
                }
                .disableCollapsing()
            }
        }
        .listStyle(InsetGroupedListStyle())
        .onDeleteCommand {
            guard let selectedItem = viewModel.selectedItem else { return }
            viewModel.delete(selectedItem)
        }
    }

    var addProjectToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            if viewModel.showClosedProjects == false {
                Button {
                    withAnimation {
                        viewModel.addProject()
                    }
                } label: {

                    Label("Add Project", systemImage: "plus")
                }

            }
        }
        }
    

    var sortOrderToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Menu {
                Button("Optimized") { viewModel.sortOrder = .optimized }
                Button("Creation Date") { viewModel.sortOrder = .creationDate }
                Button("Title") { viewModel.sortOrder = .title }
            } label: {

                Label("Sort", systemImage: "arrow.up.arrow.down")
            }
        }
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.projects.isEmpty {
                    Text("Nothing here right now")
                        .foregroundColor(.secondary)
                } else {
                    projectsList
        }
    }

            .navigationTitle(viewModel.showClosedProjects ? "Closed Projects" : "Open Projects")
            .toolbar {
                addProjectToolbarItem
                sortOrderToolbarItem
            }

            SelectSomethingView()
        }
        .sheet(isPresented: $viewModel.showingUnlockView) {
            UnlockView()
        }
    }
    init(dataController: DataController, showClosedProjects: Bool) {
        let viewModel = ViewModel(dataController: dataController, showClosedProjects: showClosedProjects)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
}
struct ProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsView(dataController: DataController.preview, showClosedProjects: false)
    }
}
