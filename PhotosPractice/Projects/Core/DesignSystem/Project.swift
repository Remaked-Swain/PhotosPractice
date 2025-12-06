import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: ModulePath.core(.designSystem).name,
    resources: ["Resources/**"],
    dependencies: [
        .core(.common)
    ]
)
