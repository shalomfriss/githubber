//  This file was automatically generated and should not be edited.

import Apollo

public final class ReposQuery: GraphQLQuery {
  public static let operationString =
    "query Repos($user: String!) {\n  repositoryOwner(login: $user) {\n    __typename\n    repositories(first: 100, orderBy: {field: CREATED_AT, direction: DESC}) {\n      __typename\n      edges {\n        __typename\n        node {\n          __typename\n          ...RepoDetails\n        }\n      }\n      pageInfo {\n        __typename\n        endCursor\n        hasNextPage\n      }\n    }\n  }\n}"

  public static var requestString: String { return operationString.appending(RepoDetails.fragmentString) }

  public var user: String

  public init(user: String) {
    self.user = user
  }

  public var variables: GraphQLMap? {
    return ["user": user]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("repositoryOwner", arguments: ["login": GraphQLVariable("user")], type: .object(RepositoryOwner.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(repositoryOwner: RepositoryOwner? = nil) {
      self.init(snapshot: ["__typename": "Query", "repositoryOwner": repositoryOwner.flatMap { (value: RepositoryOwner) -> Snapshot in value.snapshot }])
    }

    /// Lookup a repository owner (ie. either a User or an Organization) by login.
    public var repositoryOwner: RepositoryOwner? {
      get {
        return (snapshot["repositoryOwner"] as? Snapshot).flatMap { RepositoryOwner(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "repositoryOwner")
      }
    }

    public struct RepositoryOwner: GraphQLSelectionSet {
      public static let possibleTypes = ["Organization", "User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("repositories", arguments: ["first": 100, "orderBy": ["field": "CREATED_AT", "direction": "DESC"]], type: .nonNull(.object(Repository.selections))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public static func makeOrganization(repositories: Repository) -> RepositoryOwner {
        return RepositoryOwner(snapshot: ["__typename": "Organization", "repositories": repositories.snapshot])
      }

      public static func makeUser(repositories: Repository) -> RepositoryOwner {
        return RepositoryOwner(snapshot: ["__typename": "User", "repositories": repositories.snapshot])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// A list of repositories that the user owns.
      public var repositories: Repository {
        get {
          return Repository(snapshot: snapshot["repositories"]! as! Snapshot)
        }
        set {
          snapshot.updateValue(newValue.snapshot, forKey: "repositories")
        }
      }

      public struct Repository: GraphQLSelectionSet {
        public static let possibleTypes = ["RepositoryConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("edges", type: .list(.object(Edge.selections))),
          GraphQLField("pageInfo", type: .nonNull(.object(PageInfo.selections))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(edges: [Edge?]? = nil, pageInfo: PageInfo) {
          self.init(snapshot: ["__typename": "RepositoryConnection", "edges": edges.flatMap { (value: [Edge?]) -> [Snapshot?] in value.map { (value: Edge?) -> Snapshot? in value.flatMap { (value: Edge) -> Snapshot in value.snapshot } } }, "pageInfo": pageInfo.snapshot])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        /// A list of edges.
        public var edges: [Edge?]? {
          get {
            return (snapshot["edges"] as? [Snapshot?]).flatMap { (value: [Snapshot?]) -> [Edge?] in value.map { (value: Snapshot?) -> Edge? in value.flatMap { (value: Snapshot) -> Edge in Edge(snapshot: value) } } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { (value: [Edge?]) -> [Snapshot?] in value.map { (value: Edge?) -> Snapshot? in value.flatMap { (value: Edge) -> Snapshot in value.snapshot } } }, forKey: "edges")
          }
        }

        /// Information to aid in pagination.
        public var pageInfo: PageInfo {
          get {
            return PageInfo(snapshot: snapshot["pageInfo"]! as! Snapshot)
          }
          set {
            snapshot.updateValue(newValue.snapshot, forKey: "pageInfo")
          }
        }

        public struct Edge: GraphQLSelectionSet {
          public static let possibleTypes = ["RepositoryEdge"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("node", type: .object(Node.selections)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(node: Node? = nil) {
            self.init(snapshot: ["__typename": "RepositoryEdge", "node": node.flatMap { (value: Node) -> Snapshot in value.snapshot }])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The item at the end of the edge.
          public var node: Node? {
            get {
              return (snapshot["node"] as? Snapshot).flatMap { Node(snapshot: $0) }
            }
            set {
              snapshot.updateValue(newValue?.snapshot, forKey: "node")
            }
          }

          public struct Node: GraphQLSelectionSet {
            public static let possibleTypes = ["Repository"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("name", type: .nonNull(.scalar(String.self))),
              GraphQLField("description", type: .scalar(String.self)),
              GraphQLField("stargazers", type: .nonNull(.object(Stargazer.selections))),
              GraphQLField("forks", type: .nonNull(.object(Fork.selections))),
              GraphQLField("primaryLanguage", type: .object(PrimaryLanguage.selections)),
              GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
              GraphQLField("url", type: .nonNull(.scalar(String.self))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(name: String, description: String? = nil, stargazers: Stargazer, forks: Fork, primaryLanguage: PrimaryLanguage? = nil, updatedAt: String, url: String) {
              self.init(snapshot: ["__typename": "Repository", "name": name, "description": description, "stargazers": stargazers.snapshot, "forks": forks.snapshot, "primaryLanguage": primaryLanguage.flatMap { (value: PrimaryLanguage) -> Snapshot in value.snapshot }, "updatedAt": updatedAt, "url": url])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            /// The name of the repository.
            public var name: String {
              get {
                return snapshot["name"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "name")
              }
            }

            /// The description of the repository.
            public var description: String? {
              get {
                return snapshot["description"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "description")
              }
            }

            /// A list of users who have starred this starrable.
            public var stargazers: Stargazer {
              get {
                return Stargazer(snapshot: snapshot["stargazers"]! as! Snapshot)
              }
              set {
                snapshot.updateValue(newValue.snapshot, forKey: "stargazers")
              }
            }

            /// A list of direct forked repositories.
            public var forks: Fork {
              get {
                return Fork(snapshot: snapshot["forks"]! as! Snapshot)
              }
              set {
                snapshot.updateValue(newValue.snapshot, forKey: "forks")
              }
            }

            /// The primary language of the repository's code.
            public var primaryLanguage: PrimaryLanguage? {
              get {
                return (snapshot["primaryLanguage"] as? Snapshot).flatMap { PrimaryLanguage(snapshot: $0) }
              }
              set {
                snapshot.updateValue(newValue?.snapshot, forKey: "primaryLanguage")
              }
            }

            /// Identifies the date and time when the object was last updated.
            @available(*, deprecated, message: "General type updated timestamps will eventually be replaced by other field specific timestamps. Removal on 2018-07-01 UTC.")
            public var updatedAt: String {
              get {
                return snapshot["updatedAt"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "updatedAt")
              }
            }

            /// The HTTP URL for this repository
            public var url: String {
              get {
                return snapshot["url"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "url")
              }
            }

            public var fragments: Fragments {
              get {
                return Fragments(snapshot: snapshot)
              }
              set {
                snapshot += newValue.snapshot
              }
            }

            public struct Fragments {
              public var snapshot: Snapshot

              public var repoDetails: RepoDetails {
                get {
                  return RepoDetails(snapshot: snapshot)
                }
                set {
                  snapshot += newValue.snapshot
                }
              }
            }

            public struct Stargazer: GraphQLSelectionSet {
              public static let possibleTypes = ["StargazerConnection"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(totalCount: Int) {
                self.init(snapshot: ["__typename": "StargazerConnection", "totalCount": totalCount])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              /// Identifies the total count of items in the connection.
              public var totalCount: Int {
                get {
                  return snapshot["totalCount"]! as! Int
                }
                set {
                  snapshot.updateValue(newValue, forKey: "totalCount")
                }
              }
            }

            public struct Fork: GraphQLSelectionSet {
              public static let possibleTypes = ["RepositoryConnection"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(totalCount: Int) {
                self.init(snapshot: ["__typename": "RepositoryConnection", "totalCount": totalCount])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              /// Identifies the total count of items in the connection.
              public var totalCount: Int {
                get {
                  return snapshot["totalCount"]! as! Int
                }
                set {
                  snapshot.updateValue(newValue, forKey: "totalCount")
                }
              }
            }

            public struct PrimaryLanguage: GraphQLSelectionSet {
              public static let possibleTypes = ["Language"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("name", type: .nonNull(.scalar(String.self))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(name: String) {
                self.init(snapshot: ["__typename": "Language", "name": name])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              /// The name of the current language.
              public var name: String {
                get {
                  return snapshot["name"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "name")
                }
              }
            }
          }
        }

        public struct PageInfo: GraphQLSelectionSet {
          public static let possibleTypes = ["PageInfo"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("endCursor", type: .scalar(String.self)),
            GraphQLField("hasNextPage", type: .nonNull(.scalar(Bool.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(endCursor: String? = nil, hasNextPage: Bool) {
            self.init(snapshot: ["__typename": "PageInfo", "endCursor": endCursor, "hasNextPage": hasNextPage])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          /// When paginating forwards, the cursor to continue.
          public var endCursor: String? {
            get {
              return snapshot["endCursor"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "endCursor")
            }
          }

          /// When paginating forwards, are there more items?
          public var hasNextPage: Bool {
            get {
              return snapshot["hasNextPage"]! as! Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "hasNextPage")
            }
          }
        }
      }
    }
  }
}

public final class ReposContinueQuery: GraphQLQuery {
  public static let operationString =
    "query ReposContinue($user: String!, $cursor: String!) {\n  repositoryOwner(login: $user) {\n    __typename\n    repositories(first: 100, after: $cursor, orderBy: {field: CREATED_AT, direction: DESC}) {\n      __typename\n      edges {\n        __typename\n        node {\n          __typename\n          ...RepoDetails\n        }\n      }\n      pageInfo {\n        __typename\n        endCursor\n        hasNextPage\n      }\n    }\n  }\n}"

  public static var requestString: String { return operationString.appending(RepoDetails.fragmentString) }

  public var user: String
  public var cursor: String

  public init(user: String, cursor: String) {
    self.user = user
    self.cursor = cursor
  }

  public var variables: GraphQLMap? {
    return ["user": user, "cursor": cursor]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("repositoryOwner", arguments: ["login": GraphQLVariable("user")], type: .object(RepositoryOwner.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(repositoryOwner: RepositoryOwner? = nil) {
      self.init(snapshot: ["__typename": "Query", "repositoryOwner": repositoryOwner.flatMap { (value: RepositoryOwner) -> Snapshot in value.snapshot }])
    }

    /// Lookup a repository owner (ie. either a User or an Organization) by login.
    public var repositoryOwner: RepositoryOwner? {
      get {
        return (snapshot["repositoryOwner"] as? Snapshot).flatMap { RepositoryOwner(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "repositoryOwner")
      }
    }

    public struct RepositoryOwner: GraphQLSelectionSet {
      public static let possibleTypes = ["Organization", "User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("repositories", arguments: ["first": 100, "after": GraphQLVariable("cursor"), "orderBy": ["field": "CREATED_AT", "direction": "DESC"]], type: .nonNull(.object(Repository.selections))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public static func makeOrganization(repositories: Repository) -> RepositoryOwner {
        return RepositoryOwner(snapshot: ["__typename": "Organization", "repositories": repositories.snapshot])
      }

      public static func makeUser(repositories: Repository) -> RepositoryOwner {
        return RepositoryOwner(snapshot: ["__typename": "User", "repositories": repositories.snapshot])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// A list of repositories that the user owns.
      public var repositories: Repository {
        get {
          return Repository(snapshot: snapshot["repositories"]! as! Snapshot)
        }
        set {
          snapshot.updateValue(newValue.snapshot, forKey: "repositories")
        }
      }

      public struct Repository: GraphQLSelectionSet {
        public static let possibleTypes = ["RepositoryConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("edges", type: .list(.object(Edge.selections))),
          GraphQLField("pageInfo", type: .nonNull(.object(PageInfo.selections))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(edges: [Edge?]? = nil, pageInfo: PageInfo) {
          self.init(snapshot: ["__typename": "RepositoryConnection", "edges": edges.flatMap { (value: [Edge?]) -> [Snapshot?] in value.map { (value: Edge?) -> Snapshot? in value.flatMap { (value: Edge) -> Snapshot in value.snapshot } } }, "pageInfo": pageInfo.snapshot])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        /// A list of edges.
        public var edges: [Edge?]? {
          get {
            return (snapshot["edges"] as? [Snapshot?]).flatMap { (value: [Snapshot?]) -> [Edge?] in value.map { (value: Snapshot?) -> Edge? in value.flatMap { (value: Snapshot) -> Edge in Edge(snapshot: value) } } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { (value: [Edge?]) -> [Snapshot?] in value.map { (value: Edge?) -> Snapshot? in value.flatMap { (value: Edge) -> Snapshot in value.snapshot } } }, forKey: "edges")
          }
        }

        /// Information to aid in pagination.
        public var pageInfo: PageInfo {
          get {
            return PageInfo(snapshot: snapshot["pageInfo"]! as! Snapshot)
          }
          set {
            snapshot.updateValue(newValue.snapshot, forKey: "pageInfo")
          }
        }

        public struct Edge: GraphQLSelectionSet {
          public static let possibleTypes = ["RepositoryEdge"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("node", type: .object(Node.selections)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(node: Node? = nil) {
            self.init(snapshot: ["__typename": "RepositoryEdge", "node": node.flatMap { (value: Node) -> Snapshot in value.snapshot }])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The item at the end of the edge.
          public var node: Node? {
            get {
              return (snapshot["node"] as? Snapshot).flatMap { Node(snapshot: $0) }
            }
            set {
              snapshot.updateValue(newValue?.snapshot, forKey: "node")
            }
          }

          public struct Node: GraphQLSelectionSet {
            public static let possibleTypes = ["Repository"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("name", type: .nonNull(.scalar(String.self))),
              GraphQLField("description", type: .scalar(String.self)),
              GraphQLField("stargazers", type: .nonNull(.object(Stargazer.selections))),
              GraphQLField("forks", type: .nonNull(.object(Fork.selections))),
              GraphQLField("primaryLanguage", type: .object(PrimaryLanguage.selections)),
              GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
              GraphQLField("url", type: .nonNull(.scalar(String.self))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(name: String, description: String? = nil, stargazers: Stargazer, forks: Fork, primaryLanguage: PrimaryLanguage? = nil, updatedAt: String, url: String) {
              self.init(snapshot: ["__typename": "Repository", "name": name, "description": description, "stargazers": stargazers.snapshot, "forks": forks.snapshot, "primaryLanguage": primaryLanguage.flatMap { (value: PrimaryLanguage) -> Snapshot in value.snapshot }, "updatedAt": updatedAt, "url": url])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            /// The name of the repository.
            public var name: String {
              get {
                return snapshot["name"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "name")
              }
            }

            /// The description of the repository.
            public var description: String? {
              get {
                return snapshot["description"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "description")
              }
            }

            /// A list of users who have starred this starrable.
            public var stargazers: Stargazer {
              get {
                return Stargazer(snapshot: snapshot["stargazers"]! as! Snapshot)
              }
              set {
                snapshot.updateValue(newValue.snapshot, forKey: "stargazers")
              }
            }

            /// A list of direct forked repositories.
            public var forks: Fork {
              get {
                return Fork(snapshot: snapshot["forks"]! as! Snapshot)
              }
              set {
                snapshot.updateValue(newValue.snapshot, forKey: "forks")
              }
            }

            /// The primary language of the repository's code.
            public var primaryLanguage: PrimaryLanguage? {
              get {
                return (snapshot["primaryLanguage"] as? Snapshot).flatMap { PrimaryLanguage(snapshot: $0) }
              }
              set {
                snapshot.updateValue(newValue?.snapshot, forKey: "primaryLanguage")
              }
            }

            /// Identifies the date and time when the object was last updated.
            @available(*, deprecated, message: "General type updated timestamps will eventually be replaced by other field specific timestamps. Removal on 2018-07-01 UTC.")
            public var updatedAt: String {
              get {
                return snapshot["updatedAt"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "updatedAt")
              }
            }

            /// The HTTP URL for this repository
            public var url: String {
              get {
                return snapshot["url"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "url")
              }
            }

            public var fragments: Fragments {
              get {
                return Fragments(snapshot: snapshot)
              }
              set {
                snapshot += newValue.snapshot
              }
            }

            public struct Fragments {
              public var snapshot: Snapshot

              public var repoDetails: RepoDetails {
                get {
                  return RepoDetails(snapshot: snapshot)
                }
                set {
                  snapshot += newValue.snapshot
                }
              }
            }

            public struct Stargazer: GraphQLSelectionSet {
              public static let possibleTypes = ["StargazerConnection"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(totalCount: Int) {
                self.init(snapshot: ["__typename": "StargazerConnection", "totalCount": totalCount])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              /// Identifies the total count of items in the connection.
              public var totalCount: Int {
                get {
                  return snapshot["totalCount"]! as! Int
                }
                set {
                  snapshot.updateValue(newValue, forKey: "totalCount")
                }
              }
            }

            public struct Fork: GraphQLSelectionSet {
              public static let possibleTypes = ["RepositoryConnection"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(totalCount: Int) {
                self.init(snapshot: ["__typename": "RepositoryConnection", "totalCount": totalCount])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              /// Identifies the total count of items in the connection.
              public var totalCount: Int {
                get {
                  return snapshot["totalCount"]! as! Int
                }
                set {
                  snapshot.updateValue(newValue, forKey: "totalCount")
                }
              }
            }

            public struct PrimaryLanguage: GraphQLSelectionSet {
              public static let possibleTypes = ["Language"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("name", type: .nonNull(.scalar(String.self))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(name: String) {
                self.init(snapshot: ["__typename": "Language", "name": name])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              /// The name of the current language.
              public var name: String {
                get {
                  return snapshot["name"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "name")
                }
              }
            }
          }
        }

        public struct PageInfo: GraphQLSelectionSet {
          public static let possibleTypes = ["PageInfo"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("endCursor", type: .scalar(String.self)),
            GraphQLField("hasNextPage", type: .nonNull(.scalar(Bool.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(endCursor: String? = nil, hasNextPage: Bool) {
            self.init(snapshot: ["__typename": "PageInfo", "endCursor": endCursor, "hasNextPage": hasNextPage])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          /// When paginating forwards, the cursor to continue.
          public var endCursor: String? {
            get {
              return snapshot["endCursor"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "endCursor")
            }
          }

          /// When paginating forwards, are there more items?
          public var hasNextPage: Bool {
            get {
              return snapshot["hasNextPage"]! as! Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "hasNextPage")
            }
          }
        }
      }
    }
  }
}

public final class RepoCountQuery: GraphQLQuery {
  public static let operationString =
    "query RepoCount($user: String!) {\n  repositoryOwner(login: $user) {\n    __typename\n    repositories {\n      __typename\n      totalCount\n    }\n  }\n}"

  public var user: String

  public init(user: String) {
    self.user = user
  }

  public var variables: GraphQLMap? {
    return ["user": user]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("repositoryOwner", arguments: ["login": GraphQLVariable("user")], type: .object(RepositoryOwner.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(repositoryOwner: RepositoryOwner? = nil) {
      self.init(snapshot: ["__typename": "Query", "repositoryOwner": repositoryOwner.flatMap { (value: RepositoryOwner) -> Snapshot in value.snapshot }])
    }

    /// Lookup a repository owner (ie. either a User or an Organization) by login.
    public var repositoryOwner: RepositoryOwner? {
      get {
        return (snapshot["repositoryOwner"] as? Snapshot).flatMap { RepositoryOwner(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "repositoryOwner")
      }
    }

    public struct RepositoryOwner: GraphQLSelectionSet {
      public static let possibleTypes = ["Organization", "User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("repositories", type: .nonNull(.object(Repository.selections))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public static func makeOrganization(repositories: Repository) -> RepositoryOwner {
        return RepositoryOwner(snapshot: ["__typename": "Organization", "repositories": repositories.snapshot])
      }

      public static func makeUser(repositories: Repository) -> RepositoryOwner {
        return RepositoryOwner(snapshot: ["__typename": "User", "repositories": repositories.snapshot])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// A list of repositories that the user owns.
      public var repositories: Repository {
        get {
          return Repository(snapshot: snapshot["repositories"]! as! Snapshot)
        }
        set {
          snapshot.updateValue(newValue.snapshot, forKey: "repositories")
        }
      }

      public struct Repository: GraphQLSelectionSet {
        public static let possibleTypes = ["RepositoryConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(totalCount: Int) {
          self.init(snapshot: ["__typename": "RepositoryConnection", "totalCount": totalCount])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Identifies the total count of items in the connection.
        public var totalCount: Int {
          get {
            return snapshot["totalCount"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "totalCount")
          }
        }
      }
    }
  }
}

public final class RepoCommentsQuery: GraphQLQuery {
  public static let operationString =
    "query RepoComments($repoName: String!, $owner: String!) {\n  repository(name: $repoName, owner: $owner) {\n    __typename\n    ref(qualifiedName: \"master\") {\n      __typename\n      target {\n        __typename\n        ... on Commit {\n          id\n          history(first: 5) {\n            __typename\n            pageInfo {\n              __typename\n              hasNextPage\n              endCursor\n            }\n            edges {\n              __typename\n              node {\n                __typename\n                messageHeadline\n                oid\n                message\n                author {\n                  __typename\n                  name\n                  email\n                  date\n                }\n              }\n            }\n          }\n        }\n      }\n    }\n  }\n}"

  public var repoName: String
  public var owner: String

  public init(repoName: String, owner: String) {
    self.repoName = repoName
    self.owner = owner
  }

  public var variables: GraphQLMap? {
    return ["repoName": repoName, "owner": owner]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("repository", arguments: ["name": GraphQLVariable("repoName"), "owner": GraphQLVariable("owner")], type: .object(Repository.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(repository: Repository? = nil) {
      self.init(snapshot: ["__typename": "Query", "repository": repository.flatMap { (value: Repository) -> Snapshot in value.snapshot }])
    }

    /// Lookup a given repository by the owner and repository name.
    public var repository: Repository? {
      get {
        return (snapshot["repository"] as? Snapshot).flatMap { Repository(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "repository")
      }
    }

    public struct Repository: GraphQLSelectionSet {
      public static let possibleTypes = ["Repository"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("ref", arguments: ["qualifiedName": "master"], type: .object(Ref.selections)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(ref: Ref? = nil) {
        self.init(snapshot: ["__typename": "Repository", "ref": ref.flatMap { (value: Ref) -> Snapshot in value.snapshot }])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Fetch a given ref from the repository
      public var ref: Ref? {
        get {
          return (snapshot["ref"] as? Snapshot).flatMap { Ref(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "ref")
        }
      }

      public struct Ref: GraphQLSelectionSet {
        public static let possibleTypes = ["Ref"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("target", type: .nonNull(.object(Target.selections))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(target: Target) {
          self.init(snapshot: ["__typename": "Ref", "target": target.snapshot])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        /// The object the ref points to.
        public var target: Target {
          get {
            return Target(snapshot: snapshot["target"]! as! Snapshot)
          }
          set {
            snapshot.updateValue(newValue.snapshot, forKey: "target")
          }
        }

        public struct Target: GraphQLSelectionSet {
          public static let possibleTypes = ["Commit", "Tree", "Blob", "Tag"]

          public static let selections: [GraphQLSelection] = [
            GraphQLTypeCase(
              variants: ["Commit": AsCommit.selections],
              default: [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              ]
            )
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public static func makeTree() -> Target {
            return Target(snapshot: ["__typename": "Tree"])
          }

          public static func makeBlob() -> Target {
            return Target(snapshot: ["__typename": "Blob"])
          }

          public static func makeTag() -> Target {
            return Target(snapshot: ["__typename": "Tag"])
          }

          public static func makeCommit(id: GraphQLID, history: AsCommit.History) -> Target {
            return Target(snapshot: ["__typename": "Commit", "id": id, "history": history.snapshot])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var asCommit: AsCommit? {
            get {
              if !AsCommit.possibleTypes.contains(__typename) { return nil }
              return AsCommit(snapshot: snapshot)
            }
            set {
              guard let newValue = newValue else { return }
              snapshot = newValue.snapshot
            }
          }

          public struct AsCommit: GraphQLSelectionSet {
            public static let possibleTypes = ["Commit"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
              GraphQLField("history", arguments: ["first": 5], type: .nonNull(.object(History.selections))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(id: GraphQLID, history: History) {
              self.init(snapshot: ["__typename": "Commit", "id": id, "history": history.snapshot])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var id: GraphQLID {
              get {
                return snapshot["id"]! as! GraphQLID
              }
              set {
                snapshot.updateValue(newValue, forKey: "id")
              }
            }

            /// The linear commit history starting from (and including) this commit, in the same order as `git log`.
            public var history: History {
              get {
                return History(snapshot: snapshot["history"]! as! Snapshot)
              }
              set {
                snapshot.updateValue(newValue.snapshot, forKey: "history")
              }
            }

            public struct History: GraphQLSelectionSet {
              public static let possibleTypes = ["CommitHistoryConnection"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("pageInfo", type: .nonNull(.object(PageInfo.selections))),
                GraphQLField("edges", type: .list(.object(Edge.selections))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(pageInfo: PageInfo, edges: [Edge?]? = nil) {
                self.init(snapshot: ["__typename": "CommitHistoryConnection", "pageInfo": pageInfo.snapshot, "edges": edges.flatMap { (value: [Edge?]) -> [Snapshot?] in value.map { (value: Edge?) -> Snapshot? in value.flatMap { (value: Edge) -> Snapshot in value.snapshot } } }])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              /// Information to aid in pagination.
              public var pageInfo: PageInfo {
                get {
                  return PageInfo(snapshot: snapshot["pageInfo"]! as! Snapshot)
                }
                set {
                  snapshot.updateValue(newValue.snapshot, forKey: "pageInfo")
                }
              }

              public var edges: [Edge?]? {
                get {
                  return (snapshot["edges"] as? [Snapshot?]).flatMap { (value: [Snapshot?]) -> [Edge?] in value.map { (value: Snapshot?) -> Edge? in value.flatMap { (value: Snapshot) -> Edge in Edge(snapshot: value) } } }
                }
                set {
                  snapshot.updateValue(newValue.flatMap { (value: [Edge?]) -> [Snapshot?] in value.map { (value: Edge?) -> Snapshot? in value.flatMap { (value: Edge) -> Snapshot in value.snapshot } } }, forKey: "edges")
                }
              }

              public struct PageInfo: GraphQLSelectionSet {
                public static let possibleTypes = ["PageInfo"]

                public static let selections: [GraphQLSelection] = [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("hasNextPage", type: .nonNull(.scalar(Bool.self))),
                  GraphQLField("endCursor", type: .scalar(String.self)),
                ]

                public var snapshot: Snapshot

                public init(snapshot: Snapshot) {
                  self.snapshot = snapshot
                }

                public init(hasNextPage: Bool, endCursor: String? = nil) {
                  self.init(snapshot: ["__typename": "PageInfo", "hasNextPage": hasNextPage, "endCursor": endCursor])
                }

                public var __typename: String {
                  get {
                    return snapshot["__typename"]! as! String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// When paginating forwards, are there more items?
                public var hasNextPage: Bool {
                  get {
                    return snapshot["hasNextPage"]! as! Bool
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "hasNextPage")
                  }
                }

                /// When paginating forwards, the cursor to continue.
                public var endCursor: String? {
                  get {
                    return snapshot["endCursor"] as? String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "endCursor")
                  }
                }
              }

              public struct Edge: GraphQLSelectionSet {
                public static let possibleTypes = ["CommitEdge"]

                public static let selections: [GraphQLSelection] = [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("node", type: .object(Node.selections)),
                ]

                public var snapshot: Snapshot

                public init(snapshot: Snapshot) {
                  self.snapshot = snapshot
                }

                public init(node: Node? = nil) {
                  self.init(snapshot: ["__typename": "CommitEdge", "node": node.flatMap { (value: Node) -> Snapshot in value.snapshot }])
                }

                public var __typename: String {
                  get {
                    return snapshot["__typename"]! as! String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// The item at the end of the edge.
                public var node: Node? {
                  get {
                    return (snapshot["node"] as? Snapshot).flatMap { Node(snapshot: $0) }
                  }
                  set {
                    snapshot.updateValue(newValue?.snapshot, forKey: "node")
                  }
                }

                public struct Node: GraphQLSelectionSet {
                  public static let possibleTypes = ["Commit"]

                  public static let selections: [GraphQLSelection] = [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("messageHeadline", type: .nonNull(.scalar(String.self))),
                    GraphQLField("oid", type: .nonNull(.scalar(String.self))),
                    GraphQLField("message", type: .nonNull(.scalar(String.self))),
                    GraphQLField("author", type: .object(Author.selections)),
                  ]

                  public var snapshot: Snapshot

                  public init(snapshot: Snapshot) {
                    self.snapshot = snapshot
                  }

                  public init(messageHeadline: String, oid: String, message: String, author: Author? = nil) {
                    self.init(snapshot: ["__typename": "Commit", "messageHeadline": messageHeadline, "oid": oid, "message": message, "author": author.flatMap { (value: Author) -> Snapshot in value.snapshot }])
                  }

                  public var __typename: String {
                    get {
                      return snapshot["__typename"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  /// The Git commit message headline
                  public var messageHeadline: String {
                    get {
                      return snapshot["messageHeadline"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "messageHeadline")
                    }
                  }

                  /// The Git object ID
                  public var oid: String {
                    get {
                      return snapshot["oid"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "oid")
                    }
                  }

                  /// The Git commit message
                  public var message: String {
                    get {
                      return snapshot["message"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "message")
                    }
                  }

                  /// Authorship details of the commit.
                  public var author: Author? {
                    get {
                      return (snapshot["author"] as? Snapshot).flatMap { Author(snapshot: $0) }
                    }
                    set {
                      snapshot.updateValue(newValue?.snapshot, forKey: "author")
                    }
                  }

                  public struct Author: GraphQLSelectionSet {
                    public static let possibleTypes = ["GitActor"]

                    public static let selections: [GraphQLSelection] = [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("name", type: .scalar(String.self)),
                      GraphQLField("email", type: .scalar(String.self)),
                      GraphQLField("date", type: .scalar(String.self)),
                    ]

                    public var snapshot: Snapshot

                    public init(snapshot: Snapshot) {
                      self.snapshot = snapshot
                    }

                    public init(name: String? = nil, email: String? = nil, date: String? = nil) {
                      self.init(snapshot: ["__typename": "GitActor", "name": name, "email": email, "date": date])
                    }

                    public var __typename: String {
                      get {
                        return snapshot["__typename"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "__typename")
                      }
                    }

                    /// The name in the Git commit.
                    public var name: String? {
                      get {
                        return snapshot["name"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "name")
                      }
                    }

                    /// The email in the Git commit.
                    public var email: String? {
                      get {
                        return snapshot["email"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "email")
                      }
                    }

                    /// The timestamp of the Git action (authoring or committing).
                    public var date: String? {
                      get {
                        return snapshot["date"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "date")
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

public final class UserNameQuery: GraphQLQuery {
  public static let operationString =
    "query UserName($queryString: String!) {\n  search(query: $queryString, first: 1, type: USER) {\n    __typename\n    edges {\n      __typename\n      node {\n        __typename\n        ... on User {\n          login\n        }\n      }\n    }\n  }\n}"

  public var queryString: String

  public init(queryString: String) {
    self.queryString = queryString
  }

  public var variables: GraphQLMap? {
    return ["queryString": queryString]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("search", arguments: ["query": GraphQLVariable("queryString"), "first": 1, "type": "USER"], type: .nonNull(.object(Search.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(search: Search) {
      self.init(snapshot: ["__typename": "Query", "search": search.snapshot])
    }

    /// Perform a search across resources.
    public var search: Search {
      get {
        return Search(snapshot: snapshot["search"]! as! Snapshot)
      }
      set {
        snapshot.updateValue(newValue.snapshot, forKey: "search")
      }
    }

    public struct Search: GraphQLSelectionSet {
      public static let possibleTypes = ["SearchResultItemConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("edges", type: .list(.object(Edge.selections))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(edges: [Edge?]? = nil) {
        self.init(snapshot: ["__typename": "SearchResultItemConnection", "edges": edges.flatMap { (value: [Edge?]) -> [Snapshot?] in value.map { (value: Edge?) -> Snapshot? in value.flatMap { (value: Edge) -> Snapshot in value.snapshot } } }])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// A list of edges.
      public var edges: [Edge?]? {
        get {
          return (snapshot["edges"] as? [Snapshot?]).flatMap { (value: [Snapshot?]) -> [Edge?] in value.map { (value: Snapshot?) -> Edge? in value.flatMap { (value: Snapshot) -> Edge in Edge(snapshot: value) } } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { (value: [Edge?]) -> [Snapshot?] in value.map { (value: Edge?) -> Snapshot? in value.flatMap { (value: Edge) -> Snapshot in value.snapshot } } }, forKey: "edges")
        }
      }

      public struct Edge: GraphQLSelectionSet {
        public static let possibleTypes = ["SearchResultItemEdge"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("node", type: .object(Node.selections)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(node: Node? = nil) {
          self.init(snapshot: ["__typename": "SearchResultItemEdge", "node": node.flatMap { (value: Node) -> Snapshot in value.snapshot }])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        /// The item at the end of the edge.
        public var node: Node? {
          get {
            return (snapshot["node"] as? Snapshot).flatMap { Node(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "node")
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes = ["Issue", "PullRequest", "Repository", "User", "Organization", "MarketplaceListing"]

          public static let selections: [GraphQLSelection] = [
            GraphQLTypeCase(
              variants: ["User": AsUser.selections],
              default: [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              ]
            )
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public static func makeIssue() -> Node {
            return Node(snapshot: ["__typename": "Issue"])
          }

          public static func makePullRequest() -> Node {
            return Node(snapshot: ["__typename": "PullRequest"])
          }

          public static func makeRepository() -> Node {
            return Node(snapshot: ["__typename": "Repository"])
          }

          public static func makeOrganization() -> Node {
            return Node(snapshot: ["__typename": "Organization"])
          }

          public static func makeMarketplaceListing() -> Node {
            return Node(snapshot: ["__typename": "MarketplaceListing"])
          }

          public static func makeUser(login: String) -> Node {
            return Node(snapshot: ["__typename": "User", "login": login])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var asUser: AsUser? {
            get {
              if !AsUser.possibleTypes.contains(__typename) { return nil }
              return AsUser(snapshot: snapshot)
            }
            set {
              guard let newValue = newValue else { return }
              snapshot = newValue.snapshot
            }
          }

          public struct AsUser: GraphQLSelectionSet {
            public static let possibleTypes = ["User"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("login", type: .nonNull(.scalar(String.self))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(login: String) {
              self.init(snapshot: ["__typename": "User", "login": login])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            /// The username used to login.
            public var login: String {
              get {
                return snapshot["login"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "login")
              }
            }
          }
        }
      }
    }
  }
}

public final class UserNamesQuery: GraphQLQuery {
  public static let operationString =
    "query UserNames($queryString: String!) {\n  search(query: $queryString, first: 10, type: USER) {\n    __typename\n    edges {\n      __typename\n      node {\n        __typename\n        ... on User {\n          login\n        }\n      }\n    }\n  }\n}"

  public var queryString: String

  public init(queryString: String) {
    self.queryString = queryString
  }

  public var variables: GraphQLMap? {
    return ["queryString": queryString]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("search", arguments: ["query": GraphQLVariable("queryString"), "first": 10, "type": "USER"], type: .nonNull(.object(Search.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(search: Search) {
      self.init(snapshot: ["__typename": "Query", "search": search.snapshot])
    }

    /// Perform a search across resources.
    public var search: Search {
      get {
        return Search(snapshot: snapshot["search"]! as! Snapshot)
      }
      set {
        snapshot.updateValue(newValue.snapshot, forKey: "search")
      }
    }

    public struct Search: GraphQLSelectionSet {
      public static let possibleTypes = ["SearchResultItemConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("edges", type: .list(.object(Edge.selections))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(edges: [Edge?]? = nil) {
        self.init(snapshot: ["__typename": "SearchResultItemConnection", "edges": edges.flatMap { (value: [Edge?]) -> [Snapshot?] in value.map { (value: Edge?) -> Snapshot? in value.flatMap { (value: Edge) -> Snapshot in value.snapshot } } }])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// A list of edges.
      public var edges: [Edge?]? {
        get {
          return (snapshot["edges"] as? [Snapshot?]).flatMap { (value: [Snapshot?]) -> [Edge?] in value.map { (value: Snapshot?) -> Edge? in value.flatMap { (value: Snapshot) -> Edge in Edge(snapshot: value) } } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { (value: [Edge?]) -> [Snapshot?] in value.map { (value: Edge?) -> Snapshot? in value.flatMap { (value: Edge) -> Snapshot in value.snapshot } } }, forKey: "edges")
        }
      }

      public struct Edge: GraphQLSelectionSet {
        public static let possibleTypes = ["SearchResultItemEdge"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("node", type: .object(Node.selections)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(node: Node? = nil) {
          self.init(snapshot: ["__typename": "SearchResultItemEdge", "node": node.flatMap { (value: Node) -> Snapshot in value.snapshot }])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        /// The item at the end of the edge.
        public var node: Node? {
          get {
            return (snapshot["node"] as? Snapshot).flatMap { Node(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "node")
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes = ["Issue", "PullRequest", "Repository", "User", "Organization", "MarketplaceListing"]

          public static let selections: [GraphQLSelection] = [
            GraphQLTypeCase(
              variants: ["User": AsUser.selections],
              default: [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              ]
            )
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public static func makeIssue() -> Node {
            return Node(snapshot: ["__typename": "Issue"])
          }

          public static func makePullRequest() -> Node {
            return Node(snapshot: ["__typename": "PullRequest"])
          }

          public static func makeRepository() -> Node {
            return Node(snapshot: ["__typename": "Repository"])
          }

          public static func makeOrganization() -> Node {
            return Node(snapshot: ["__typename": "Organization"])
          }

          public static func makeMarketplaceListing() -> Node {
            return Node(snapshot: ["__typename": "MarketplaceListing"])
          }

          public static func makeUser(login: String) -> Node {
            return Node(snapshot: ["__typename": "User", "login": login])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var asUser: AsUser? {
            get {
              if !AsUser.possibleTypes.contains(__typename) { return nil }
              return AsUser(snapshot: snapshot)
            }
            set {
              guard let newValue = newValue else { return }
              snapshot = newValue.snapshot
            }
          }

          public struct AsUser: GraphQLSelectionSet {
            public static let possibleTypes = ["User"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("login", type: .nonNull(.scalar(String.self))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(login: String) {
              self.init(snapshot: ["__typename": "User", "login": login])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            /// The username used to login.
            public var login: String {
              get {
                return snapshot["login"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "login")
              }
            }
          }
        }
      }
    }
  }
}

public struct RepoDetails: GraphQLFragment {
  public static let fragmentString =
    "fragment RepoDetails on Repository {\n  __typename\n  name\n  description\n  stargazers {\n    __typename\n    totalCount\n  }\n  forks {\n    __typename\n    totalCount\n  }\n  primaryLanguage {\n    __typename\n    name\n  }\n  updatedAt\n  url\n}"

  public static let possibleTypes = ["Repository"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("name", type: .nonNull(.scalar(String.self))),
    GraphQLField("description", type: .scalar(String.self)),
    GraphQLField("stargazers", type: .nonNull(.object(Stargazer.selections))),
    GraphQLField("forks", type: .nonNull(.object(Fork.selections))),
    GraphQLField("primaryLanguage", type: .object(PrimaryLanguage.selections)),
    GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
    GraphQLField("url", type: .nonNull(.scalar(String.self))),
  ]

  public var snapshot: Snapshot

  public init(snapshot: Snapshot) {
    self.snapshot = snapshot
  }

  public init(name: String, description: String? = nil, stargazers: Stargazer, forks: Fork, primaryLanguage: PrimaryLanguage? = nil, updatedAt: String, url: String) {
    self.init(snapshot: ["__typename": "Repository", "name": name, "description": description, "stargazers": stargazers.snapshot, "forks": forks.snapshot, "primaryLanguage": primaryLanguage.flatMap { (value: PrimaryLanguage) -> Snapshot in value.snapshot }, "updatedAt": updatedAt, "url": url])
  }

  public var __typename: String {
    get {
      return snapshot["__typename"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "__typename")
    }
  }

  /// The name of the repository.
  public var name: String {
    get {
      return snapshot["name"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "name")
    }
  }

  /// The description of the repository.
  public var description: String? {
    get {
      return snapshot["description"] as? String
    }
    set {
      snapshot.updateValue(newValue, forKey: "description")
    }
  }

  /// A list of users who have starred this starrable.
  public var stargazers: Stargazer {
    get {
      return Stargazer(snapshot: snapshot["stargazers"]! as! Snapshot)
    }
    set {
      snapshot.updateValue(newValue.snapshot, forKey: "stargazers")
    }
  }

  /// A list of direct forked repositories.
  public var forks: Fork {
    get {
      return Fork(snapshot: snapshot["forks"]! as! Snapshot)
    }
    set {
      snapshot.updateValue(newValue.snapshot, forKey: "forks")
    }
  }

  /// The primary language of the repository's code.
  public var primaryLanguage: PrimaryLanguage? {
    get {
      return (snapshot["primaryLanguage"] as? Snapshot).flatMap { PrimaryLanguage(snapshot: $0) }
    }
    set {
      snapshot.updateValue(newValue?.snapshot, forKey: "primaryLanguage")
    }
  }

  /// Identifies the date and time when the object was last updated.
  @available(*, deprecated, message: "General type updated timestamps will eventually be replaced by other field specific timestamps. Removal on 2018-07-01 UTC.")
  public var updatedAt: String {
    get {
      return snapshot["updatedAt"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "updatedAt")
    }
  }

  /// The HTTP URL for this repository
  public var url: String {
    get {
      return snapshot["url"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "url")
    }
  }

  public struct Stargazer: GraphQLSelectionSet {
    public static let possibleTypes = ["StargazerConnection"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(totalCount: Int) {
      self.init(snapshot: ["__typename": "StargazerConnection", "totalCount": totalCount])
    }

    public var __typename: String {
      get {
        return snapshot["__typename"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "__typename")
      }
    }

    /// Identifies the total count of items in the connection.
    public var totalCount: Int {
      get {
        return snapshot["totalCount"]! as! Int
      }
      set {
        snapshot.updateValue(newValue, forKey: "totalCount")
      }
    }
  }

  public struct Fork: GraphQLSelectionSet {
    public static let possibleTypes = ["RepositoryConnection"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(totalCount: Int) {
      self.init(snapshot: ["__typename": "RepositoryConnection", "totalCount": totalCount])
    }

    public var __typename: String {
      get {
        return snapshot["__typename"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "__typename")
      }
    }

    /// Identifies the total count of items in the connection.
    public var totalCount: Int {
      get {
        return snapshot["totalCount"]! as! Int
      }
      set {
        snapshot.updateValue(newValue, forKey: "totalCount")
      }
    }
  }

  public struct PrimaryLanguage: GraphQLSelectionSet {
    public static let possibleTypes = ["Language"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("name", type: .nonNull(.scalar(String.self))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(name: String) {
      self.init(snapshot: ["__typename": "Language", "name": name])
    }

    public var __typename: String {
      get {
        return snapshot["__typename"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "__typename")
      }
    }

    /// The name of the current language.
    public var name: String {
      get {
        return snapshot["name"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "name")
      }
    }
  }
}