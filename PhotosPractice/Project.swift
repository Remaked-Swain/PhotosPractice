import ProjectDescription

let project = Project(
    name: "PhotosPractice",
    targets: [
        .target(
            name: "PhotosPractice",
            destinations: .iOS,
            product: .app,
            bundleId: "dev.tuist.PhotosPractice",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            buildableFolders: [
                "PhotosPractice/Sources",
                "PhotosPractice/Resources",
            ],
            dependencies: []
        ),
        .target(
            name: "PhotosPracticeTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "dev.tuist.PhotosPracticeTests",
            infoPlist: .default,
            buildableFolders: [
                "PhotosPractice/Tests"
            ],
            dependencies: [.target(name: "PhotosPractice")]
        ),
    ]
)
