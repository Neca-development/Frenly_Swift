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
    case "MetadataOutput": return LensProtocol.Objects.MetadataOutput
    case "Profile": return LensProtocol.Objects.Profile
    case "Mutation": return LensProtocol.Objects.Mutation
    case "CreateCommentBroadcastItemResult": return LensProtocol.Objects.CreateCommentBroadcastItemResult
    case "CreateCommentEIP712TypedData": return LensProtocol.Objects.CreateCommentEIP712TypedData
    case "CreateCommentEIP712TypedDataTypes": return LensProtocol.Objects.CreateCommentEIP712TypedDataTypes
    case "EIP712TypedDataField": return LensProtocol.Objects.EIP712TypedDataField
    case "EIP712TypedDataDomain": return LensProtocol.Objects.EIP712TypedDataDomain
    case "CreateCommentEIP712TypedDataValue": return LensProtocol.Objects.CreateCommentEIP712TypedDataValue
    case "PublicationStats": return LensProtocol.Objects.PublicationStats
    case "MetadataAttributeOutput": return LensProtocol.Objects.MetadataAttributeOutput
    case "PaginatedResultInfo": return LensProtocol.Objects.PaginatedResultInfo
    case "CreatePostBroadcastItemResult": return LensProtocol.Objects.CreatePostBroadcastItemResult
    case "CreatePostEIP712TypedData": return LensProtocol.Objects.CreatePostEIP712TypedData
    case "CreatePostEIP712TypedDataTypes": return LensProtocol.Objects.CreatePostEIP712TypedDataTypes
    case "CreatePostEIP712TypedDataValue": return LensProtocol.Objects.CreatePostEIP712TypedDataValue
    case "RelayerResult": return LensProtocol.Objects.RelayerResult
    case "RelayError": return LensProtocol.Objects.RelayError
    case "AuthChallengeResult": return LensProtocol.Objects.AuthChallengeResult
    case "AuthenticationResult": return LensProtocol.Objects.AuthenticationResult
    default: return nil
    }
  }
}

public enum Objects {}
public enum Interfaces {}
public enum Unions {}
