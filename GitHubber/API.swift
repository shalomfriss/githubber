//  This file was automatically generated and should not be edited.

import Apollo

public final class ReposQuery: GraphQLQuery {
  public static let operationString =
    "query Repos($user: String!) {\n  repositoryOwner(login: $user) {\n    __typename\n    repositories(first: 10, isFork: false, privacy: PUBLIC, orderBy: {field: CREATED_AT, direction: DESC}) {\n      __typename\n      edges {\n        __typename\n        node {\n          __typename\n          ...RepoDetails\n        }\n      }\n    }\n  }\n}"

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
        GraphQLField("repositories", arguments: ["first": 10, "isFork": false, "privacy": "PUBLIC", "orderBy": ["field": "CREATED_AT", "direction": "DESC"]], type: .nonNull(.object(Repository.selections))),
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
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(edges: [Edge?]? = nil) {
          self.init(snapshot: ["__typename": "RepositoryConnection", "edges": edges.flatMap { (value: [Edge?]) -> [Snapshot?] in value.map { (value: Edge?) -> Snapshot? in value.flatMap { (value: Edge) -> Snapshot in value.snapshot } } }])
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