import ProjectDescription

enum ForaConfigs: String {
    case debug
    case demo
    case test
    case release
    
    var MTL_ENABLE_DEBUG_INFO: String {
        switch self {
        case .debug:
            return "INCLUDE_SOURCE"
        case .demo:
            return "NO"
        case .test:
            return "NO"
        case .release:
            return "NO"
        }
    }
    
    var stringRepresentation: String {
        switch self {
        case .debug:
            return "dev"
        case .demo:
            return "demo"
        case .test:
            return "test"
        case .release:
            return "release"
        }
    }
}

let swiftLintName = "Run SwiftLint"
let swiftLintScript = """
export PATH="$PATH:/opt/homebrew/bin"
if which swiftlint >/dev/null; then
  swiftlint --config swiftlint.yml
else
  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
"""
let projectName = "FaceRecognizer"
let uiTestProjectName = "\(projectName.lowercased())UITests"
let unitTestProjectName = "\(projectName.lowercased())Tests"

let debugTarget = createTargedConfig(name: "Debug", config: .debug)
let testTarget = createTargedConfig(name: "Test", config: .test)
let demoTarget = createTargedConfig(name: "Demo", config: .demo)
let releaseTarget = createTargedConfig(name: "Release", config: .release)

let debugProject = createProjectConfig(name: "Debug", config: .debug)
let testProject = createProjectConfig(name: "Test", config: .test)
let demoProject = createProjectConfig(name: "Demo", config: .demo)
let releaseProject = createProjectConfig(name: "Release", config: .release)

let infoPlist: [String: Plist.Value] = [
    "CFBundleShortVersionString": "$(MARKETING_VERSION)",
    "CFBundleVersion": "$(CURRENT_PROJECT_VERSION)",
    "CFBundleName": "$(PRODUCT_NAME)",
    "CFBundleIdentifier": "$(PRODUCT_BUNDLE_IDENTIFIER)",
    "UILaunchScreen": "LaunchScreen"
]

let targetProject: Target = .target(
    name: "\(projectName)",
    destinations: .iOS,
    product: .app,
    bundleId: "com.forasoft.\(projectName.lowercased())",
    deploymentTargets: .iOS("15.0"),
    infoPlist: .extendingDefault(with: infoPlist),
    sources: ["\(projectName)/**"],
    resources: [
        "\(projectName)/Resources/**",
        "\(projectName)/**/*.storyboard"
    ],
    dependencies: [
        .package(product: "RxSwift"),
        .package(product: "RxRelay"),
        .package(product: "RxCocoa"),
        .package(product: "Kingfisher"),
        .package(product: "DITranquillity"),
        .package(product: "CasePaths"),
        .package(product: "ForaTransitions"),
        .package(product: "ForaArchitecture"),
        .package(product: "ForaLogger"),
    ],
    settings: Settings.settings(configurations: [
        debugTarget,
        testTarget,
        demoTarget,
        releaseTarget
    ])
)

let unitTestTargetProject: Target = .target(
    name: "\(unitTestProjectName)",
    destinations: .iOS,
    product: .unitTests,
    bundleId: "com.forasoft.\(projectName.lowercased())Tests",
    infoPlist: .default,
    sources: [
        "\(projectName)Tests/**"
    ],
    dependencies: [
        .target(name: "\(projectName)")
    ]
)

let uiTestTargetProject: Target = .target(
    name: "\(uiTestProjectName)",
    destinations: .iOS,
    product: .uiTests,
    bundleId: "com.forasoft.\(projectName.lowercased())UITests",
    infoPlist: .default,
    sources: [
        "\(projectName)UITests/**"
    ],
    dependencies: [
        .target(name: "\(projectName)")
    ]
)

let project = Project(
    name: "\(projectName)",
    packages: [
        .remote(
            url: "https://github.com/ReactiveX/RxSwift",
            requirement: .upToNextMajor(from: "6.0.0")
        ),
        .remote(
            url: "https://github.com/onevcat/Kingfisher",
            requirement: .upToNextMajor(from: "7.11.0")
        ),
        .remote(
            url: "https://github.com/ivlevAstef/DITranquillity",
            requirement: .upToNextMajor(from: "4.0.0")
        ),
        .remote(
            url: "https://github.com/pointfreeco/swift-case-paths",
            requirement: .upToNextMajor(from: "0.7.0")
        ),
        .remote(
            url: "https://s2.git.fora-soft.com/forasoft/fora-ios-transitions",
            requirement: .upToNextMajor(from: "1.0.0")
        ),
        .remote(
            url: "https://s2.git.fora-soft.com/forasoft/fora-ios-architecture",
            requirement: .upToNextMajor(from: "1.0.3")
        ),
        .remote(
            url: "https://s2.git.fora-soft.com/ios/fora-ios-logger.git",
            requirement: .upToNextMajor(from: "1.0.0")
        )
    ],
    settings: Settings.settings(configurations: [
        debugProject,
        demoProject,
        testProject,
        releaseProject
    ]),
    targets: [targetProject, unitTestTargetProject, uiTestTargetProject]
)

func createTargedConfig(name: String,
                      config: ForaConfigs) -> Configuration {
    return Configuration.debug(name: ConfigurationName(stringLiteral: "\(config.rawValue)"),
                               settings: [
                                "server_api_url": "https://\(config.stringRepresentation)-\(projectName.lowercased())",
                                "PRODUCT_NAME": "\(config.stringRepresentation.uppercased())-\(projectName)",
                                "TARGETED_DEVICE_FAMILY": "1,2",
                                "PRODUCT_BUNDLE_IDENTIFIER": "com.forasoft.\(projectName.lowercased()).\(config.stringRepresentation.lowercased())",
                                "DEVELOPMENT_TEAM": "62QHGWVLXD",
                                "PROVISIONING_PROFILE_SPECIFIER": "\(projectName) \(config.stringRepresentation.uppercased())",
                                "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "\(config.rawValue.uppercased())"
                               ])
}

func createProjectConfig(name: String,
                         config: ForaConfigs) -> Configuration {
    return Configuration.debug(name: ConfigurationName(stringLiteral: "\(config.rawValue)"),
                               settings: [
                                "MTL_ENABLE_DEBUG_INFO": "\(config.MTL_ENABLE_DEBUG_INFO)",
                                "MTL_FAST_MATH": "YES",
                                "server_api_url": ""
                               ])
}
