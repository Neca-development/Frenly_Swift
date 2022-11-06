// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public typealias ID = String

public protocol SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == LensProtocol.SchemaMetadata {}

public protocol InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == LensProtocol.SchemaMetadata {}

public protocol MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == LensProtocol.SchemaMetadata {}

public protocol MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == LensProtocol.SchemaMetadata {}

public enum SchemaMetadata: ApolloAPI.SchemaMetadata {
  public static let configuration: ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

  public static func objectType(forTypename typename: String) -> Object? {
    switch typename {
    case "Query": return LensProtocol.Objects.Query
    case "PaginatedPublicationResult": return LensProtocol.Objects.PaginatedPublicationResult
    case "Post": return LensProtocol.Objects.Post
    case "Comment": return LensProtocol.Objects.Comment
    case "Mirror": return LensProtocol.Objects.Mirror
    case "Profile": return LensProtocol.Objects.Profile
    case "PublicationStats": return LensProtocol.Objects.PublicationStats
    case "AuthChallengeResult": return LensProtocol.Objects.AuthChallengeResult
    case "Mutation": return LensProtocol.Objects.Mutation
    case "AuthenticationResult": return LensProtocol.Objects.AuthenticationResult
    default: return nil
    }
  }
}

public enum Objects {}
public enum Interfaces {}
public enum Unions {}
