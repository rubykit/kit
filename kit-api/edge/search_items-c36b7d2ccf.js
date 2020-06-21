

searchNodes = [
  {
    "type": "class",
    "ref": "Kit.Api.Resources.ActiveRecordResource.html#ActiveRecordResource-class",
    "title": "Kit::Api::Resources::ActiveRecordResource",
    "doc": "The ActiveRecordResource module is a helper to generate a Hash that will pass the Contract::Resource requirements. While you can always generate a Resource yourself, this helps do it in a less verbose way. "
  },
  {
    "type": "class",
    "ref": "Kit.Api.Engine.html#Engine-class",
    "title": "Kit::Api::Engine",
    "doc": "Rails engine for dev & test mode. Handles file loading && initializers. "
  },
  {
    "type": "class",
    "ref": "Kit.Api.Railtie.html#Railtie-class",
    "title": "Kit::Api::Railtie",
    "doc": "Handles file loading && initializers. "
  },
  {
    "type": "class",
    "ref": "Kit.JsonApiSpec.Resources.Author.html#Author-class",
    "title": "Kit::JsonApiSpec::Resources::Author",
    "doc": "Exemple type for dummy app. "
  },
  {
    "type": "class",
    "ref": "Kit.JsonApiSpec.Resources.Book.html#Book-class",
    "title": "Kit::JsonApiSpec::Resources::Book",
    "doc": "Exemple type for dummy app. "
  },
  {
    "type": "class",
    "ref": "Kit.JsonApiSpec.Resources.BookStore.html#BookStore-class",
    "title": "Kit::JsonApiSpec::Resources::BookStore",
    "doc": "Exemple type for dummy app. "
  },
  {
    "type": "class",
    "ref": "Kit.JsonApiSpec.Resources.Chapter.html#Chapter-class",
    "title": "Kit::JsonApiSpec::Resources::Chapter",
    "doc": "Exemple type for dummy app. "
  },
  {
    "type": "class",
    "ref": "Kit.JsonApiSpec.Resources.Photo.html#Photo-class",
    "title": "Kit::JsonApiSpec::Resources::Photo",
    "doc": "Exemple type for dummy app. "
  },
  {
    "type": "class",
    "ref": "Kit.JsonApiSpec.Resources.Serie.html#Serie-class",
    "title": "Kit::JsonApiSpec::Resources::Serie",
    "doc": "Exemple type for dummy app. "
  },
  {
    "type": "class",
    "ref": "Kit.JsonApiSpec.Resources.Store.html#Store-class",
    "title": "Kit::JsonApiSpec::Resources::Store",
    "doc": "Exemple type for dummy app. "
  },
  {
    "type": "module",
    "ref": "Kit.Api.Contracts.html#Contracts-module",
    "title": "Kit::Api::Contracts",
    "doc": "Contracts for the project "
  },
  {
    "type": "module",
    "ref": "Kit.Api.JsonApi.Contracts.html#Contracts-module",
    "title": "Kit::Api::JsonApi::Contracts",
    "doc": "Contracts for the project "
  },
  {
    "type": "module",
    "ref": "Kit.Api.JsonApi.Controllers.JsonApi.html#JsonApi-module",
    "title": "Kit::Api::JsonApi::Controllers::JsonApi",
    "doc": "Shared controller logic "
  },
  {
    "type": "module",
    "ref": "Kit.Api.Resources.html#Resources-module",
    "title": "Kit::Api::Resources",
    "doc": "Resources templates. "
  },
  {
    "type": "module",
    "ref": "Kit.Api.JsonApi.Services.html#Services-module",
    "title": "Kit::Api::JsonApi::Services",
    "doc": "Kit::Api::JsonApi various Services "
  },
  {
    "type": "module",
    "ref": "Kit.Api.JsonApi.Services.Linkers.html#Linkers-module",
    "title": "Kit::Api::JsonApi::Services::Linkers",
    "doc": "Namespace for Linkers strategies. "
  },
  {
    "type": "module",
    "ref": "Kit.Api.JsonApi.Services.Linkers.DefaultLinker.html#DefaultLinker-module",
    "title": "Kit::Api::JsonApi::Services::Linkers::DefaultLinker",
    "doc": "Serializer entry point. There are 2 categories "
  },
  {
    "type": "module",
    "ref": "Kit.Api.JsonApi.Services.Paginators.html#Paginators-module",
    "title": "Kit::Api::JsonApi::Services::Paginators",
    "doc": "Namespace for Paginators strategies. "
  },
  {
    "type": "module",
    "ref": "Kit.Api.JsonApi.Services.Paginators.Cursor.html#Cursor-module",
    "title": "Kit::Api::JsonApi::Services::Paginators::Cursor",
    "doc": "Cursor based pagination strategy A cursor is what we call pagination data when it allows to identify precisely at least one boundary of a subset. URL format The expected format is: GET https://my.api/my-resource?page[(resource_path.)pagination_keyword]=cursor_data When the resource_path is omitted, pagination applies to the top level resource. With this strategy, pagination_keyword could be any of [:size, :after, :before]. Operations order For the following pagination data page[size]=10&page[next]=gt|Author.id=1000, steps will happen in a specific order: Add a boundary condition with the cursor data, Author.id > 1000 Apply filters & sorting Apply page size limit The boundary condition takes precedence on the filtering, sorting & page size limit. Nested pagination This paginator enables pagination on: the top level resource when it a collection any to-many relationships as long as every ancestor is singular (either a singular resource or a to-one relationship). Pagination data is provider per path, like: page[author.books.next]. So it only has meaning when that path identify a single collection. If there are different subsets, the data inside a cursor will only work with one the subset. As a result, an error is returned when trying to paginate on nested collections. Here are a few examples: # VALID: the top level resource is singular (author A.id=a1), so pagination data can apply # to `books`, because there can only be one books collection. GET https://my.api/authors/a1?page[books.next]=cursor_data # VALID: the top level resource is singular (book B.id=b1), it's author relationship is # singular (to-one relationship), so pagination can apply to `author.books`. # Again, there is only be one books collection. GET https://my.api/books/1?page[author.books.next]=cursor_data # INVALID: the top level resource is a collection (authors), so pagination data CAN NOT # apply to `books`, because there are multiple books collections (one for author A.id=a1, # one for author A.id=a2, etc). Except for luck, that pagination data is meaningless. GET https://my.api/authors?page[books.next]=cursor_data References https://jsonapi.org/profiles/ethanresnick/cursor-pagination/ "
  },
  {
    "type": "module",
    "ref": "Kit.Api.JsonApi.Services.Paginators.Cursor.Validation.html#Validation-module",
    "title": "Kit::Api::JsonApi::Services::Paginators::Cursor::Validation",
    "doc": "Holds the query_parameters validation logic for the Cursor paginator. TODO: good candidate to rewrite as Contracts. "
  },
  {
    "type": "module",
    "ref": "Kit.Api.JsonApi.Services.Paginators.Offset.html#Offset-module",
    "title": "Kit::Api::JsonApi::Services::Paginators::Offset",
    "doc": "Offset based pagination strategy For the following pagination data page[size]=10&page[offset]=2, steps will happen in a specific order: Apply filters & sorting Add an offset of offset_value * page_size Apply page size limit The filters & sorting take precedence on the offset condition. "
  },
  {
    "type": "module",
    "ref": "Kit.Api.JsonApi.Services.Request.html#Request-module",
    "title": "Kit::Api::JsonApi::Services::Request",
    "doc": "Transform hydrated query_params data to an actionable Request. "
  },
  {
    "type": "module",
    "ref": "Kit.Api.JsonApi.Services.Request.Export.html#Export-module",
    "title": "Kit::Api::JsonApi::Services::Request::Export",
    "doc": "Namespace for Request query_params generation. "
  },
  {
    "type": "module",
    "ref": "Kit.Api.JsonApi.Services.Request.Export.Filtering.html#Filtering-module",
    "title": "Kit::Api::JsonApi::Services::Request::Export::Filtering",
    "doc": "Logic to generate filter query_params for links "
  },
  {
    "type": "module",
    "ref": "Kit.Api.JsonApi.Services.Request.Export.Pagination.html#Pagination-module",
    "title": "Kit::Api::JsonApi::Services::Request::Export::Pagination",
    "doc": "Logic to generate page[size] query_params for links "
  },
  {
    "type": "module",
    "ref": "Kit.Api.JsonApi.Services.Request.Export.RelatedResources.html#RelatedResources-module",
    "title": "Kit::Api::JsonApi::Services::Request::Export::RelatedResources",
    "doc": "Logic to generate include query_params for links "
  },
  {
    "type": "module",
    "ref": "Kit.Api.JsonApi.Services.Request.Export.Sorting.html#Sorting-module",
    "title": "Kit::Api::JsonApi::Services::Request::Export::Sorting",
    "doc": "Logic to generate sort query_params for links "
  },
  {
    "type": "module",
    "ref": "Kit.Api.JsonApi.Services.Request.Export.SparseFieldsets.html#SparseFieldsets-module",
    "title": "Kit::Api::JsonApi::Services::Request::Export::SparseFieldsets",
    "doc": "Logic to generate fields query_params for links "
  },
  {
    "type": "module",
    "ref": "Kit.Api.JsonApi.Services.Request.Import.html#Import-module",
    "title": "Kit::Api::JsonApi::Services::Request::Import",
    "doc": "Namespace for Request generation from query_params "
  },
  {
    "type": "module",
    "ref": "Kit.Api.JsonApi.Services.Request.Import.Filtering.html#Filtering-module",
    "title": "Kit::Api::JsonApi::Services::Request::Import::Filtering",
    "doc": "JSON:API base specification is agnostic about filtering strategies supported by a server. Kit::Api::JsonApi supports: filtering on the top level collection and any to-many relationship multiple operators per field, defined per field type Kit::Api::JsonApi supports pagination on each included relationship. A relationship that is traversed through multiple paths can have per-path filters. URL format The format of a filter is: GET https://my.api/my-resource?filter[(resource_path.)filter_name]([operator])=value(s) If the resource_path is omitted, the filter applies to the top level resource. # Implicit: the filter `name` is applied on `authors` GET /authors?filter[name]=Dan # Explicit: the filter `title` is applied on `books.chapter` GET /authors?include=books.chapter&filter[books.chapter.title]=Strider If the operator is omitted, is defaults to eq or in, based on the values. # Single value: the two following are equal GET /authors?filter[id]=2 GET /authors?filter[id][eq]=2 # Multiple values: the two following are equal GET /authors?filter[id]=1,2 GET /authors?filter[id][in]=1,2 ⚠️ Warning Filters on relationship do not have any effect on the parent (upper level). This ensures Resources can be loaded from different datasources, where JOINs are not available. # The following will not affect the returned authors, only the books. GET /authors?filter[books.title]=Title References https://jsonapi.org/format/1.1/#fetching-filtering https://jsonapi.org/recommendations/#filtering "
  },
  {
    "type": "module",
    "ref": "Kit.Api.JsonApi.Services.Request.Import.Pagination.html#Pagination-module",
    "title": "Kit::Api::JsonApi::Services::Request::Import::Pagination",
    "doc": "JSON:API base specification is agnostic about pagination strategies supported by a server, it only reserves the page query parameter family for pagination. Kit::Api::JsonApi provides pagination strategies through Paginators. Paginators are set by Resource (types). ALthough not recommended, we support using different types of Paginators for different Resources in the same API. Kit::Api::JsonApi includes the following strategies: [x] cursor based pagination strategy [x] offset based pagination strategy URL format Regardless of the pagination strategy, the expected format is: GET https://my.api/my-resource?page[(resource_path.)pagination_keyword]=cursor_data When the resource_path is omitted, pagination applies to the top level resource. Each pagination strategy defines the pagination_keyword it accepts. Note that resource_path only reference relationship names, and not Resource name. # Here the pagination data apply to the top level Resource (books) GET https://my.api/books?page[next]=cursor_data # Here the pagination data apply to a relationship on the top level Resource (books), # with the name `books`, that can potentially map to any Resource type. # As this is quite confusing, it is recommended not to do it. GET https://my.api/books?page[books.next]=cursor_data Considerations for different strategies Pagination strategies may have different implications for data Resolvers. Please check the documentation of the Paginator you wish to use. References https://jsonapi.org/format/1.1/#fetching-pagination https://jsonapi.org/profiles/ethanresnick/cursor-pagination/ "
  },
  {
    "type": "module",
    "ref": "Kit.Api.JsonApi.Services.Request.Import.RelatedResources.html#RelatedResources-module",
    "title": "Kit::Api::JsonApi::Services::Request::Import::RelatedResources",
    "doc": "URL format The format to include related ressources is: GET https://my.api/my-resource?include=relationship1,relationship2.nested_relationship ⚠️ Warning Filtering, Sorting & Pagination potentially depend on include if they describe related resources, so this need to be ran first. References https://jsonapi.org/format/1.1/#fetching-includes "
  },
  {
    "type": "module",
    "ref": "Kit.Api.JsonApi.Services.Request.Import.Sorting.html#Sorting-module",
    "title": "Kit::Api::JsonApi::Services::Request::Import::Sorting",
    "doc": "Kit::Api::JsonApi supports: sorting on the top level collection and any to-many nested relationship multiple sorting criterias per path A relationship that is traversed through multiple paths can have per-path sorting. Sorting criterias do not necessarily need to correspond to resource attribute and relationship names. URL format The format for sorting is: GET https://my.api/my-resource?sort=(+|-)(resource_path.)sorting_criteria If the resource_path is omitted, the sorting criteria applies to the top level resource. If the sign is omitted, is defaults to + # The two following are equal GET /authors?sort=name GET /authors?sort=+name References https://jsonapi.org/format/1.1/#fetching-sorting "
  },
  {
    "type": "module",
    "ref": "Kit.Api.JsonApi.Services.Request.Import.SparseFieldsets.html#SparseFieldsets-module",
    "title": "Kit::Api::JsonApi::Services::Request::Import::SparseFieldsets",
    "doc": "JSON:API allows endpoint to return only specific fields in a response. ⚠️ Warning: this is done on a per-type (Resource) basis, not on a per-relationship. URL format The format for sparse fieldsets is: GET https://my.api/my-resource?fields[resource]=field1,field2 References https://jsonapi.org/format/1.1/#fetching-sparse-fieldsets "
  },
  {
    "type": "module",
    "ref": "Kit.Api.JsonApi.Services.Serialization.html#Serialization-module",
    "title": "Kit::Api::JsonApi::Services::Serialization",
    "doc": "Namespace for internal Serialization related logic. "
  },
  {
    "type": "module",
    "ref": "Kit.Api.JsonApi.Services.Serialization.Query.html#Query-module",
    "title": "Kit::Api::JsonApi::Services::Serialization::Query",
    "doc": "Serializer entry point. "
  },
  {
    "type": "module",
    "ref": "Kit.Api.JsonApi.Services.Serialization.QueryNode.html#QueryNode-module",
    "title": "Kit::Api::JsonApi::Services::Serialization::QueryNode",
    "doc": "Serialization logic for an entire QueryNode "
  },
  {
    "type": "module",
    "ref": "Kit.Api.JsonApi.Services.Serialization.Relationship.html#Relationship-module",
    "title": "Kit::Api::JsonApi::Services::Serialization::Relationship",
    "doc": "Serialization logic for Relatiobships "
  },
  {
    "type": "module",
    "ref": "Kit.Api.JsonApi.Services.Serialization.ResourceObject.html#ResourceObject-module",
    "title": "Kit::Api::JsonApi::Services::Serialization::ResourceObject",
    "doc": "Serialization logic for ResourceObjects "
  },
  {
    "type": "module",
    "ref": "Kit.Api.JsonApi.Services.Serializers.html#Serializers-module",
    "title": "Kit::Api::JsonApi::Services::Serializers",
    "doc": "Namespace for Serializers strategies "
  },
  {
    "type": "module",
    "ref": "Kit.Api.JsonApi.Services.Serializers.ActiveRecord.html#ActiveRecord-module",
    "title": "Kit::Api::JsonApi::Services::Serializers::ActiveRecord",
    "doc": "ActiveRecord data resolver. "
  },
  {
    "type": "module",
    "ref": "Kit.Api.JsonApi.Services.Url.html#Url-module",
    "title": "Kit::Api::JsonApi::Services::Url",
    "doc": "Namespace for URL related logic. "
  },
  {
    "type": "module",
    "ref": "Kit.Api.Services.html#Services-module",
    "title": "Kit::Api::Services",
    "doc": "Kit::Api various Services "
  },
  {
    "type": "module",
    "ref": "Kit.Api.Services.Config.html#Config-module",
    "title": "Kit::Api::Services::Config",
    "doc": "Hold config data. Example { page_size: 50, max_page_size: 100, } Todo: rewrite this with Kit::Config when available! "
  },
  {
    "type": "module",
    "ref": "Kit.Api.Services.Debug.html#Debug-module",
    "title": "Kit::Api::Services::Debug",
    "doc": "Namespace for Debug related logic. "
  },
  {
    "type": "module",
    "ref": "Kit.Api.Services.Encryption.html#Encryption-module",
    "title": "Kit::Api::Services::Encryption",
    "doc": "Symmetric 256-bit AES encryption for strings. Wrapper around URLcrypt methods, with explicit key. References https://github.com/cheerful/URLcrypt https://github.com/cheerful/URLcrypt/blob/master/lib/URLcrypt.rb "
  },
  {
    "type": "module",
    "ref": "Kit.Api.Services.QueryBuilder.html#QueryBuilder-module",
    "title": "Kit::Api::Services::QueryBuilder",
    "doc": "Build a Query (a fully actionable AST) from a Request. Each level is a query node, even when there are 1:N or N:N scenarios. For instance Author -> Books -> Chapters will be resolved as 3 corresponding query nodes total, eventhough there are many books, with many chapters. Each type of relationship generates a query node even if they target the same resource. For instance Author -> [Chapter | FirstChapter] will generate 3 corresponding query nodes total, eventhough the two relationships Chapter and FirstChapter target the same Resource (Chapter) "
  },
  {
    "type": "module",
    "ref": "Kit.Api.Services.QueryResolver.html#QueryResolver-module",
    "title": "Kit::Api::Services::QueryResolver",
    "doc": "Resolve a Query: load data & map it "
  },
  {
    "type": "module",
    "ref": "Kit.Api.Services.Resolvers.html#Resolvers-module",
    "title": "Kit::Api::Services::Resolvers",
    "doc": "Namespace for data Resolvers strategies. "
  },
  {
    "type": "module",
    "ref": "Kit.Api.Services.Resolvers.ActiveRecord.html#ActiveRecord-module",
    "title": "Kit::Api::Services::Resolvers::ActiveRecord",
    "doc": "ActiveRecord data resolver. "
  },
  {
    "type": "module",
    "ref": "Kit.Api.Services.Resolvers.Sql.html#Sql-module",
    "title": "Kit::Api::Services::Resolvers::Sql",
    "doc": "Transform AST to a SQL query string "
  },
  {
    "type": "module",
    "ref": "Kit.Api.Services.Resolvers.Sql.Filtering.html#Filtering-module",
    "title": "Kit::Api::Services::Resolvers::Sql::Filtering",
    "doc": "Transform Conditions AST to a SQL string "
  },
  {
    "type": "module",
    "ref": "Kit.Api.Services.Resolvers.Sql.Limit.html#Limit-module",
    "title": "Kit::Api::Services::Resolvers::Sql::Limit",
    "doc": "Generate LIMIT sql string statement. "
  },
  {
    "type": "module",
    "ref": "Kit.Api.Services.Resolvers.Sql.Sanitization.html#Sanitization-module",
    "title": "Kit::Api::Services::Resolvers::Sql::Sanitization",
    "doc": ""
  },
  {
    "type": "module",
    "ref": "Kit.Api.Services.Resolvers.Sql.Sorting.html#Sorting-module",
    "title": "Kit::Api::Services::Resolvers::Sql::Sorting",
    "doc": "Transform sorting parameters from the AST to a SQL string "
  },
  {
    "type": "module",
    "ref": "Kit.html#Kit-module",
    "title": "Top Level Namespace::Kit",
    "doc": "rubocop:disable Style/Documentation "
  },
  {
    "type": "module",
    "ref": "Kit.Api.html#Api-module",
    "title": "Kit::Api",
    "doc": "rubocop:disable Style/Documentation "
  },
  {
    "type": "class method",
    "ref": "Kit.JsonApiSpec.Resources.Store.html#name-class_method",
    "title": "Kit::JsonApiSpec::Resources::Store#name",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.JsonApiSpec.Resources.Store.html#model-class_method",
    "title": "Kit::JsonApiSpec::Resources::Store#model",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.JsonApiSpec.Resources.Store.html#fields_setup-class_method",
    "title": "Kit::JsonApiSpec::Resources::Store#fields_setup",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.JsonApiSpec.Resources.Store.html#relationships-class_method",
    "title": "Kit::JsonApiSpec::Resources::Store#relationships",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.JsonApiSpec.Resources.Serie.html#name-class_method",
    "title": "Kit::JsonApiSpec::Resources::Serie#name",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.JsonApiSpec.Resources.Serie.html#model-class_method",
    "title": "Kit::JsonApiSpec::Resources::Serie#model",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.JsonApiSpec.Resources.Serie.html#fields_setup-class_method",
    "title": "Kit::JsonApiSpec::Resources::Serie#fields_setup",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.JsonApiSpec.Resources.Serie.html#relationships-class_method",
    "title": "Kit::JsonApiSpec::Resources::Serie#relationships",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.JsonApiSpec.Resources.Serie.html#assemble_authors_relationship_sql_query-class_method",
    "title": "Kit::JsonApiSpec::Resources::Serie#assemble_authors_relationship_sql_query",
    "doc": "Note: we might want to add helpers to handle JOINs. Or leave it as is as an exemple since it's something we want to discourage. "
  },
  {
    "type": "class method",
    "ref": "Kit.JsonApiSpec.Resources.Photo.html#name-class_method",
    "title": "Kit::JsonApiSpec::Resources::Photo#name",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.JsonApiSpec.Resources.Photo.html#model-class_method",
    "title": "Kit::JsonApiSpec::Resources::Photo#model",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.JsonApiSpec.Resources.Photo.html#fields_setup-class_method",
    "title": "Kit::JsonApiSpec::Resources::Photo#fields_setup",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.JsonApiSpec.Resources.Photo.html#relationships-class_method",
    "title": "Kit::JsonApiSpec::Resources::Photo#relationships",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.JsonApiSpec.Resources.Chapter.html#name-class_method",
    "title": "Kit::JsonApiSpec::Resources::Chapter#name",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.JsonApiSpec.Resources.Chapter.html#model-class_method",
    "title": "Kit::JsonApiSpec::Resources::Chapter#model",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.JsonApiSpec.Resources.Chapter.html#fields_setup-class_method",
    "title": "Kit::JsonApiSpec::Resources::Chapter#fields_setup",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.JsonApiSpec.Resources.Chapter.html#relationships-class_method",
    "title": "Kit::JsonApiSpec::Resources::Chapter#relationships",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.JsonApiSpec.Resources.Chapter.html#record_serializer-class_method",
    "title": "Kit::JsonApiSpec::Resources::Chapter#record_serializer",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.JsonApiSpec.Resources.BookStore.html#name-class_method",
    "title": "Kit::JsonApiSpec::Resources::BookStore#name",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.JsonApiSpec.Resources.BookStore.html#model-class_method",
    "title": "Kit::JsonApiSpec::Resources::BookStore#model",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.JsonApiSpec.Resources.BookStore.html#fields_setup-class_method",
    "title": "Kit::JsonApiSpec::Resources::BookStore#fields_setup",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.JsonApiSpec.Resources.BookStore.html#relationships-class_method",
    "title": "Kit::JsonApiSpec::Resources::BookStore#relationships",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.JsonApiSpec.Resources.Book.html#name-class_method",
    "title": "Kit::JsonApiSpec::Resources::Book#name",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.JsonApiSpec.Resources.Book.html#model-class_method",
    "title": "Kit::JsonApiSpec::Resources::Book#model",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.JsonApiSpec.Resources.Book.html#fields_setup-class_method",
    "title": "Kit::JsonApiSpec::Resources::Book#fields_setup",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.JsonApiSpec.Resources.Book.html#relationships-class_method",
    "title": "Kit::JsonApiSpec::Resources::Book#relationships",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.JsonApiSpec.Resources.Author.html#name-class_method",
    "title": "Kit::JsonApiSpec::Resources::Author#name",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.JsonApiSpec.Resources.Author.html#model-class_method",
    "title": "Kit::JsonApiSpec::Resources::Author#model",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.JsonApiSpec.Resources.Author.html#fields_setup-class_method",
    "title": "Kit::JsonApiSpec::Resources::Author#fields_setup",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.JsonApiSpec.Resources.Author.html#filters-class_method",
    "title": "Kit::JsonApiSpec::Resources::Author#filters",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.JsonApiSpec.Resources.Author.html#relationships-class_method",
    "title": "Kit::JsonApiSpec::Resources::Author#relationships",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.JsonApiSpec.Resources.Author.html#assemble_series_relationship_sql_query-class_method",
    "title": "Kit::JsonApiSpec::Resources::Author#assemble_series_relationship_sql_query",
    "doc": "Note: we might want to add helpers to handle JOINs. Or leave it as is as an exemple since it's something we want to discourage. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Services.Resolvers.Sql.Sorting.html#sorting_to_sql_str-class_method",
    "title": "Kit::Api::Services::Resolvers::Sql::Sorting#sorting_to_sql_str",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Services.Resolvers.Sql.Sanitization.html#sanitize_sql-class_method",
    "title": "Kit::Api::Services::Resolvers::Sql::Sanitization#sanitize_sql",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Services.Resolvers.Sql.Sanitization.html#quote_bound_value-class_method",
    "title": "Kit::Api::Services::Resolvers::Sql::Sanitization#quote_bound_value",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Services.Resolvers.Sql.Limit.html#limit_to_sql_str-class_method",
    "title": "Kit::Api::Services::Resolvers::Sql::Limit#limit_to_sql_str",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Services.Resolvers.Sql.Filtering.html#filtering_to_sql_str-class_method",
    "title": "Kit::Api::Services::Resolvers::Sql::Filtering#filtering_to_sql_str",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Services.Resolvers.Sql.Filtering.html#filter_to_presanitized_sql-class_method",
    "title": "Kit::Api::Services::Resolvers::Sql::Filtering#filter_to_presanitized_sql",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Services.Resolvers.Sql.html#sql_query-class_method",
    "title": "Kit::Api::Services::Resolvers::Sql#sql_query",
    "doc": "Given an ActiveRecord model and some options, generate the sql query. ⚠️ Warning: the SQL is generated for Postgres. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Services.Resolvers.Sql.html#detect_relationship-class_method",
    "title": "Kit::Api::Services::Resolvers::Sql#detect_relationship",
    "doc": "Detect \"upper relationship\" (the current level is dependent on the parent one.) "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Services.Resolvers.Sql.html#assemble_sql_query-class_method",
    "title": "Kit::Api::Services::Resolvers::Sql#assemble_sql_query",
    "doc": "Assemble the final SQL query. Multiple collections As only one query is done per QueryNode, we sometime need to retrieve several subsets with their own ordering. We use a nested query to avoid naming collisions with the added attribute (rank) References https://blog.jooq.org/2018/05/14/selecting-all-columns-except-one-in-postgresql/ http://sqlfiddle.com/#!17/378a3/10 Single collection When querying a single collection, we use a simpler query that avoid the window function (RANK). "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Services.Resolvers.ActiveRecord.html#generate_resolvers-class_method",
    "title": "Kit::Api::Services::Resolvers::ActiveRecord#generate_resolvers",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Services.Resolvers.ActiveRecord.html#generate_inherited_filters-class_method",
    "title": "Kit::Api::Services::Resolvers::ActiveRecord#generate_inherited_filters",
    "doc": "Return a generic condition Callable for a nested relationship QueryNode "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Services.Resolvers.ActiveRecord.html#inherited_filter_classic-class_method",
    "title": "Kit::Api::Services::Resolvers::ActiveRecord#inherited_filter_classic",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Services.Resolvers.ActiveRecord.html#inherited_filter_to_many_polymorphic-class_method",
    "title": "Kit::Api::Services::Resolvers::ActiveRecord#inherited_filter_to_many_polymorphic",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Services.Resolvers.ActiveRecord.html#inherited_filter_to_one_polymorphic-class_method",
    "title": "Kit::Api::Services::Resolvers::ActiveRecord#inherited_filter_to_one_polymorphic",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Services.Resolvers.ActiveRecord.html#generate_records_selector-class_method",
    "title": "Kit::Api::Services::Resolvers::ActiveRecord#generate_records_selector",
    "doc": "Note: we use read_attribute for JOINs where we added the data on the element. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Services.Resolvers.ActiveRecord.html#data_resolver-class_method",
    "title": "Kit::Api::Services::Resolvers::ActiveRecord#data_resolver",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Services.Resolvers.ActiveRecord.html#generate_data_resolver-class_method",
    "title": "Kit::Api::Services::Resolvers::ActiveRecord#generate_data_resolver",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Services.QueryResolver.html#resolve_query_node-class_method",
    "title": "Kit::Api::Services::QueryResolver#resolve_query_node",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Services.QueryResolver.html#resolve_query_node_condition-class_method",
    "title": "Kit::Api::Services::QueryResolver#resolve_query_node_condition",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Services.QueryResolver.html#resolve_condition-class_method",
    "title": "Kit::Api::Services::QueryResolver#resolve_condition",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Services.QueryResolver.html#resolve_data-class_method",
    "title": "Kit::Api::Services::QueryResolver#resolve_data",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Services.QueryResolver.html#resolve_relationships_query_nodes-class_method",
    "title": "Kit::Api::Services::QueryResolver#resolve_relationships_query_nodes",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Services.QueryResolver.html#resolve_relationships_records-class_method",
    "title": "Kit::Api::Services::QueryResolver#resolve_relationships_records",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Services.QueryBuilder.html#build_query-class_method",
    "title": "Kit::Api::Services::QueryBuilder#build_query",
    "doc": "Given a Request, creates the complete AST of the query. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Services.QueryBuilder.html#build_query_node-class_method",
    "title": "Kit::Api::Services::QueryBuilder#build_query_node",
    "doc": "Creates a QueryNode for a given layer. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Services.QueryBuilder.html#build_nested_relationships-class_method",
    "title": "Kit::Api::Services::QueryBuilder#build_nested_relationships",
    "doc": "Resolves the relationships of each QueryNode. This calls back build_query_node, creating the AST recursively. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Services.QueryBuilder.html#get_limit-class_method",
    "title": "Kit::Api::Services::QueryBuilder#get_limit",
    "doc": "Get the limit value (size of the subset) "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Services.QueryBuilder.html#add_condition-class_method",
    "title": "Kit::Api::Services::QueryBuilder#add_condition",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Services.Encryption.html#encrypt-class_method",
    "title": "Kit::Api::Services::Encryption#encrypt",
    "doc": "Encrypt data using key. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Services.Encryption.html#decrypt-class_method",
    "title": "Kit::Api::Services::Encryption#decrypt",
    "doc": "Decrypt encrypted_data using key. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Services.Encryption.html#generate_cipher-class_method",
    "title": "Kit::Api::Services::Encryption#generate_cipher",
    "doc": "Generate an OpenSSL cipher. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Services.Debug.html#print_query-class_method",
    "title": "Kit::Api::Services::Debug#print_query",
    "doc": "Print a text representation of the Query AST. Example output: # rs-name type count subsets-count records-id {parent_id => [child_ids]} top-level author 2 [2] [1, 2] ┣ books book 6 [3, 3] {1=>[1, 2, 3], 2=>[4, 5, 6]} ┃ ┣ author author 2 [1, 1, 1, 1, 1, 1] {1=>[1], 2=>[1], 3=>[1], 4=>[2], 5=>[2], 6=>[2]} ┃ ┣ book_stores book_store 7 [1, 1, 1, 1, 2, 1] {1=>[1], 2=>[2], 3=>[3], 4=>[4], 5=>[5, 6], 6=>[7]} ┃ ┣ chapters chapter 18 [3, 3, 3, 3, 3, 3] {1=>[1, 2, 3], 2=>[23, 24, 25], 3=>[44, 45, 46], 4=>[63, 64, 65], 5=>[80, 81, 82], 6=>[98, 99, 100]} ┃ ┣ photos photo 6 [1, 1, 1, 1, 1, 1] {1=>[1], 2=>[2], 3=>[3], 4=>[4], 5=>[5], 6=>[6]} ┃ ┗ serie serie 3 [1, 1, 1, 0, 0, 0] {1=>[1], 2=>[2], 3=>[3], 4=>[], 5=>[], 6=>[]} ┗ photos photo 4 [2, 2] {1=>[1, 2], 2=>[3, 4]} ┣ author author 2 [1, 1, 1, 1] {1=>[1], 2=>[1], 3=>[2], 4=>[2]} ┣ book book 3 [1, 1, 1, 1] {1=>[1], 2=>[1], 3=>[2], 4=>[2]} ┣ chapter chapter 3 [1, 1, 1, 1] {1=>[1], 2=>[1], 3=>[2], 4=>[2]} ┗ serie serie 3 [1, 1, 1, 1] {1=>[1], 2=>[1], 3=>[2], 4=>[2]} "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Services.Debug.html#add_query_nodes-class_method",
    "title": "Kit::Api::Services::Debug#add_query_nodes",
    "doc": "Add query_nodes recursively for debug display. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Services.Config.html#default_config-class_method",
    "title": "Kit::Api::Services::Config#default_config",
    "doc": "Returns an api config object. This is per API. "
  },
  {
    "type": "instance method",
    "ref": "Kit.Api.Services.Config.html#validate_config-instance_method",
    "title": "Kit::Api::Services::Config.validate_config",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Services.Config.html#validate_config_resources-class_method",
    "title": "Kit::Api::Services::Config#validate_config_resources",
    "doc": "Ensure that used Types are registered on the config object, including relationship resources. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Url.html#parse_query_params-class_method",
    "title": "Kit::Api::JsonApi::Services::Url#parse_query_params",
    "doc": "Extract query parameters from an url string. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Url.html#serialize_query_params-class_method",
    "title": "Kit::Api::JsonApi::Services::Url#serialize_query_params",
    "doc": "Generate string version of query_params "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Url.html#path_to_link-class_method",
    "title": "Kit::Api::JsonApi::Services::Url#path_to_link",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Serializers.ActiveRecord.html#record_serializer-class_method",
    "title": "Kit::Api::JsonApi::Services::Serializers::ActiveRecord#record_serializer",
    "doc": "Generate the serialized version of a Record raw_data is whatever was added to data, in this case, the ActiveRecord Model instance that was retrieved. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Serialization.ResourceObject.html#serialize_resource_object-class_method",
    "title": "Kit::Api::JsonApi::Services::Serialization::ResourceObject#serialize_resource_object",
    "doc": "Serializes a single resource_object. Handles relationship resource linkage. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Serialization.ResourceObject.html#add_record_to_cache-class_method",
    "title": "Kit::Api::JsonApi::Services::Serialization::ResourceObject#add_record_to_cache",
    "doc": "Add the resource_object to document cache. Extend the resource_object if it already exists (loaded through different relationships). TODO: split this into multiple actions? "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Serialization.ResourceObject.html#ensure_uniqueness_in_document-class_method",
    "title": "Kit::Api::JsonApi::Services::Serialization::ResourceObject#ensure_uniqueness_in_document",
    "doc": "Ensures the resource_object is only included in the response once, per specs. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Serialization.ResourceObject.html#add_resource_object_links-class_method",
    "title": "Kit::Api::JsonApi::Services::Serialization::ResourceObject#add_resource_object_links",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Serialization.Relationship.html#serialize_record_relationship-class_method",
    "title": "Kit::Api::JsonApi::Services::Serialization::Relationship#serialize_record_relationship",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Serialization.Relationship.html#get_relationship_pathname-class_method",
    "title": "Kit::Api::JsonApi::Services::Serialization::Relationship#get_relationship_pathname",
    "doc": "Get full relationship pathname to avoid collisions on collections that are loaded through different paths. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Serialization.Relationship.html#get_document_relationship_container-class_method",
    "title": "Kit::Api::JsonApi::Services::Serialization::Relationship#get_document_relationship_container",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Serialization.Relationship.html#add_record_relationship_linkage-class_method",
    "title": "Kit::Api::JsonApi::Services::Serialization::Relationship#add_record_relationship_linkage",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Serialization.Relationship.html#add_record_relationship_links-class_method",
    "title": "Kit::Api::JsonApi::Services::Serialization::Relationship#add_record_relationship_links",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Serialization.QueryNode.html#serialize_query_node-class_method",
    "title": "Kit::Api::JsonApi::Services::Serialization::QueryNode#serialize_query_node",
    "doc": "Serialize \"every data\" element in a QueryNode. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Serialization.QueryNode.html#add_resource_type_to_document-class_method",
    "title": "Kit::Api::JsonApi::Services::Serialization::QueryNode#add_resource_type_to_document",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Serialization.QueryNode.html#generate_records_resource_objects-class_method",
    "title": "Kit::Api::JsonApi::Services::Serialization::QueryNode#generate_records_resource_objects",
    "doc": "Serializes every data element in a query_node. Handles relationship resource linkage. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Serialization.QueryNode.html#if_top_level_add_links-class_method",
    "title": "Kit::Api::JsonApi::Services::Serialization::QueryNode#if_top_level_add_links",
    "doc": "Add the top level data links if this is the top level QueryNode "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Serialization.QueryNode.html#if_top_level_and_singular_flatten-class_method",
    "title": "Kit::Api::JsonApi::Services::Serialization::QueryNode#if_top_level_and_singular_flatten",
    "doc": "Flatten data from an array to a single resource object if this is the top level QueryNode and it is tagged as singular "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Serialization.QueryNode.html#serialize_relationships_query_nodes-class_method",
    "title": "Kit::Api::JsonApi::Services::Serialization::QueryNode#serialize_relationships_query_nodes",
    "doc": "Calls serialize_query_node on every relationship (nested) query node. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Serialization.QueryNode.html#generate_records_relationships-class_method",
    "title": "Kit::Api::JsonApi::Services::Serialization::QueryNode#generate_records_relationships",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Serialization.Query.html#serialize_query-class_method",
    "title": "Kit::Api::JsonApi::Services::Serialization::Query#serialize_query",
    "doc": "Entry point to serialize a query AST "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Serialization.Query.html#create_document-class_method",
    "title": "Kit::Api::JsonApi::Services::Serialization::Query#create_document",
    "doc": "Create a Document object that contains the json response and various caches "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Request.Import.SparseFieldsets.html#handle_sparse_fieldsets-class_method",
    "title": "Kit::Api::JsonApi::Services::Request::Import::SparseFieldsets#handle_sparse_fieldsets",
    "doc": "Entry point. Parse & validate sparse-fieldsets data before adding it to the Request. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Request.Import.SparseFieldsets.html#parse-class_method",
    "title": "Kit::Api::JsonApi::Services::Request::Import::SparseFieldsets#parse",
    "doc": "Extract fields query params and transform it into a normalized hash. Examples irb> ex_qp = \"fields[author]=name,date_of_birth&fields[book]=title\" irb> _, ctx = Services::Url.parse_query_params(url: \"scheme://my.api/my-resource?#{ ex_qp }\") irb> ctx[:query_params] { fields: { author: 'name,date_of_birth', book: 'title', }, } irb> _, ctx = parse(query_params: ctx[:query_params]) irb> ctx[:parsed_query_params_fields] { author: ['name', 'date_of_birth'], book: ['title'], } "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Request.Import.SparseFieldsets.html#validate_params-class_method",
    "title": "Kit::Api::JsonApi::Services::Request::Import::SparseFieldsets#validate_params",
    "doc": "Ensures that: types (Resources) exist fields exist "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Request.Import.SparseFieldsets.html#add_to_request-class_method",
    "title": "Kit::Api::JsonApi::Services::Request::Import::SparseFieldsets#add_to_request",
    "doc": "When sparse fieldsets data is valid, add it to the Request. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Request.Import.Sorting.html#handle_sorting-class_method",
    "title": "Kit::Api::JsonApi::Services::Request::Import::Sorting#handle_sorting",
    "doc": "Entry point. Parse & validate sorting data before adding it to the Request. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Request.Import.Sorting.html#parse-class_method",
    "title": "Kit::Api::JsonApi::Services::Request::Import::Sorting#parse",
    "doc": "Extract sort query-param and transform it into a normalized hash. Examples irb> ex_qp = 'authors?sort=-name,books.date_published,date_of_birth,-books.title' irb> _, ctx = Services::Url.parse_query_params(url: \"scheme://my.api/my-resource?#{ ex_qp }\") irb> ctx[:query_params] { sort: '-name,books.date_published,date_of_birth,-books.title', } irb> _, ctx = parse(query_params: ctx[:query_params]) irb> ctx[:parsed_query_params_include] { authors: [ { sort_name: 'name', direction: :desc }, { sort_name: 'date_of_birth', direction: :asc }, ], :'authors.books' => [ { sort_name: 'date_published', direction: :asc }, { sort_name: 'title', direction: :desc }, ], } "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Request.Import.Sorting.html#validate-class_method",
    "title": "Kit::Api::JsonApi::Services::Request::Import::Sorting#validate",
    "doc": "Ensure that: nested relationships are included when sorted on sort criterias exist ⚠️ Warning: in order to validate inclusion, the related resources need to have been run first. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Request.Import.Sorting.html#add_to_request-class_method",
    "title": "Kit::Api::JsonApi::Services::Request::Import::Sorting#add_to_request",
    "doc": "When sorting data is valid, add it to the Request. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Request.Import.RelatedResources.html#handle_related_resources-class_method",
    "title": "Kit::Api::JsonApi::Services::Request::Import::RelatedResources#handle_related_resources",
    "doc": "Entry point. Parse & validate include data before adding it to the Request. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Request.Import.RelatedResources.html#parse-class_method",
    "title": "Kit::Api::JsonApi::Services::Request::Import::RelatedResources#parse",
    "doc": "Extract include query-param and transform it into a normalized array. Examples irb> ex_qp = 'author?include=books.author.books,series.books' irb> _, ctx = Services::Url.parse_query_params(url: \"scheme://my.api/my-resource?#{ ex_qp }\") irb> ctx[:query_params] { include: 'books.author.books,series.books', } irb> _, ctx = parse(query_params: ctx[:query_params]) irb> ctx[:parsed_query_params_include] ['books.author.books', 'series.books'] "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Request.Import.RelatedResources.html#validate_and_parse-class_method",
    "title": "Kit::Api::JsonApi::Services::Request::Import::RelatedResources#validate_and_parse",
    "doc": "Ensure that: top level resource is valid nested relationships are valid This resolve the Resource object for every path requested and replace parsed_query_params_include with a normalized hash. Examples irb> parsed_query_params_include = ['books.author.books', 'series.books'] irb> _, ctx = validate_and_add_to_request(parsed_query_params_include: parsed_query_params_include) irb> ctx[:parsed_query_params_include] { 'books' => BookResource, 'books.author' => AuthorResource, 'books.author.books' => BookResource, 'series' => SerieResource, 'series.books' => BookResource, } "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Request.Import.RelatedResources.html#add_to_request-class_method",
    "title": "Kit::Api::JsonApi::Services::Request::Import::RelatedResources#add_to_request",
    "doc": "When inclusion data is valid, add it to the Request. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Request.Import.Pagination.html#handle_pagination-class_method",
    "title": "Kit::Api::JsonApi::Services::Request::Import::Pagination#handle_pagination",
    "doc": "Entry point. Parse & validate pagination data before adding it to the Request. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Request.Import.Pagination.html#parse-class_method",
    "title": "Kit::Api::JsonApi::Services::Request::Import::Pagination#parse",
    "doc": "Extract page query params and transform it into a normalized & per-path hash. Examples irb> ex_qp = \"include=books.chapters&page[size]=2&page[after]=XdJ6Fh&page[books.size]=3&page[books.offset]=4&page[books.chapters.size]=4\" irb> _, ctx = Services::Url.parse_query_params(url: \"scheme://my.api/my-resource?#{ ex_qp }\") irb> ctx[:query_params] { include: 'books.chapters', page: { :size => '2', :after =>'XdJ6Fh', :\"books.size\" => '3', :\"books.offset\" => '2', :\"books.chapters.size\" => '4', }, } irb> _, ctx = parse(query_params: ctx[:query_params]) irb> ctx[:parsed_query_params_page] { :top_level => { size: '2', after: 'XdJ6Fh' }, :'books' => { size: '3', offset: '2', }, :'books.chapters' => { size: '4', }, } "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Request.Import.Pagination.html#validate-class_method",
    "title": "Kit::Api::JsonApi::Services::Request::Import::Pagination#validate",
    "doc": "Ensure that: nested relationships are included when paginated on Everything else is the responsability of each Paginator. ⚠️ Warning: in order to validate inclusion, the related resources need to have been run first. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Request.Import.Pagination.html#run_paginators_import-class_method",
    "title": "Kit::Api::JsonApi::Services::Request::Import::Pagination#run_paginators_import",
    "doc": "Find all paginators in use for the Request and run their validation logic. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Request.Import.Pagination.html#add_to_request-class_method",
    "title": "Kit::Api::JsonApi::Services::Request::Import::Pagination#add_to_request",
    "doc": "When pagination data is valid, add it to the Request. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Request.Import.Filtering.html#handle_filtering-class_method",
    "title": "Kit::Api::JsonApi::Services::Request::Import::Filtering#handle_filtering",
    "doc": "Entry point. Parse & validate filtering data before adding it to the Request. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Request.Import.Filtering.html#parse-class_method",
    "title": "Kit::Api::JsonApi::Services::Request::Import::Filtering#parse",
    "doc": "Extract filter query params and transform it into a normalized hash. Examples irb> ex_qp = \"filter[name][eq]=Tolkien,Rowling&filter[books.date_published][lt]=2002&filter[date_of_birth][gt]=1950&filter[books.title]=Title\" irb> _, ctx = Services::Url.parse_query_params(url: \"scheme://my.api/my-resource?#{ ex_qp }\") irb> ctx[:query_params] { filter: { :name => { eq: 'Tolkien,Rowling' }, :'books.date_published' => { lt: '2002' }, :date_of_birth => { gt: '1950' }, :'books.title' => \"Title\" }, }, } irb> _, ctx = parse(query_params: ctx[:query_params]) irb> ctx[:parsed_query_params_filters] { :top_level => [ { name: :name, op: :in, value: ['Tolkien', 'Rowling'] }, { name: :date_of_birth, op: :gt, value: ['1950'] }, ], 'books' => [ { name: :date_published, op: :lt, value: ['2002'] }, { name: :title, op: :eq, value: ['Title'] }, ], } "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Request.Import.Filtering.html#validate-class_method",
    "title": "Kit::Api::JsonApi::Services::Request::Import::Filtering#validate",
    "doc": "Ensure that: nested relationships are included when filtered on filters types are supported on the fields ⚠️ Warning: in order to validate inclusion, the related resources need to have been run first. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Request.Import.Filtering.html#add_to_request-class_method",
    "title": "Kit::Api::JsonApi::Services::Request::Import::Filtering#add_to_request",
    "doc": "When filtering data is valid, add it to the Request. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Request.Import.html#import-class_method",
    "title": "Kit::Api::JsonApi::Services::Request::Import#import",
    "doc": "Takes hydrated query params to create a Request. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Request.Export.SparseFieldsets.html#handle_sparse_fieldsets-class_method",
    "title": "Kit::Api::JsonApi::Services::Request::Export::SparseFieldsets#handle_sparse_fieldsets",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Request.Export.Sorting.html#handle_sorting-class_method",
    "title": "Kit::Api::JsonApi::Services::Request::Export::Sorting#handle_sorting",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Request.Export.RelatedResources.html#included_paths-class_method",
    "title": "Kit::Api::JsonApi::Services::Request::Export::RelatedResources#included_paths",
    "doc": "Export included_paths for a given path. Examples irb> request[:related_resources] { 'books' => BookResource, 'books.author' => AuthorResource, 'books.author.books' => BookResource, 'series' => SerieResource, 'series.books' => BookResource, } irb> included_paths(request: request, path: 'books') [ok, { included_paths: { path: 'books', list: { 'books' => BookResource, 'books.author' => AuthorResource, 'books.author.books' => BookResource, }, }] "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Request.Export.RelatedResources.html#handle_related_resources-class_method",
    "title": "Kit::Api::JsonApi::Services::Request::Export::RelatedResources#handle_related_resources",
    "doc": "Export include query_params for included_paths. Examples irb> request[:related_resources] { 'books' => BookResource, 'books.author' => AuthorResource, 'books.author.books' => BookResource, 'series' => SerieResource, 'series.books' => BookResource, } irb> included_paths { path: 'books', list: { 'books' => BookResource, 'books.author' => AuthorResource, 'books.author.books' => BookResource, }, } irb> handle_related_resources(request: request, included_paths: included_paths) [ok, { query_params: { include: 'author.books', }] "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Request.Export.Pagination.html#handle_page_size-class_method",
    "title": "Kit::Api::JsonApi::Services::Request::Export::Pagination#handle_page_size",
    "doc": "Add page[size] to query params "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Request.Export.Filtering.html#handle_filtering-class_method",
    "title": "Kit::Api::JsonApi::Services::Request::Export::Filtering#handle_filtering",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Request.Export.html#export-class_method",
    "title": "Kit::Api::JsonApi::Services::Request::Export#export",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Request.Export.html#adjusted_path-class_method",
    "title": "Kit::Api::JsonApi::Services::Request::Export#adjusted_path",
    "doc": "Helper method to check if current_path is part of included_paths[:list] and adjust it given included_paths[:path] "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Request.html#create_request-class_method",
    "title": "Kit::Api::JsonApi::Services::Request#create_request",
    "doc": "Takes hydrated query params to create a Request. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Request.html#create_query_params-class_method",
    "title": "Kit::Api::JsonApi::Services::Request#create_query_params",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Paginators.Offset.html#paginator_type-class_method",
    "title": "Kit::Api::JsonApi::Services::Paginators::Offset#paginator_type",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Paginators.Offset.html#to_h-class_method",
    "title": "Kit::Api::JsonApi::Services::Paginators::Offset#to_h",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Paginators.Offset.html#pagination_import-class_method",
    "title": "Kit::Api::JsonApi::Services::Paginators::Offset#pagination_import",
    "doc": "Add validation on Request creation. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Paginators.Offset.html#pagination_condition-class_method",
    "title": "Kit::Api::JsonApi::Services::Paginators::Offset#pagination_condition",
    "doc": "Add condition on QueryNode. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Paginators.Offset.html#pagination_export-class_method",
    "title": "Kit::Api::JsonApi::Services::Paginators::Offset#pagination_export",
    "doc": "Generate query_params from collection "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Paginators.Cursor.Validation.html#validate-class_method",
    "title": "Kit::Api::JsonApi::Services::Paginators::Cursor::Validation#validate",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Paginators.Cursor.Validation.html#validate_keys-class_method",
    "title": "Kit::Api::JsonApi::Services::Paginators::Cursor::Validation#validate_keys",
    "doc": "Only accepts :size, :after, :before keywords "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Paginators.Cursor.Validation.html#ensure_single_value-class_method",
    "title": "Kit::Api::JsonApi::Services::Paginators::Cursor::Validation#ensure_single_value",
    "doc": "Only accept single value as query_parameter, not lists. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Paginators.Cursor.Validation.html#validate_size_parameters-class_method",
    "title": "Kit::Api::JsonApi::Services::Paginators::Cursor::Validation#validate_size_parameters",
    "doc": "Validate :size parameters. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Paginators.Cursor.Validation.html#decrypt_cursors-class_method",
    "title": "Kit::Api::JsonApi::Services::Paginators::Cursor::Validation#decrypt_cursors",
    "doc": "Decrypt :after && :before cursors if present. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Paginators.Cursor.Validation.html#ensure_no_nesting-class_method",
    "title": "Kit::Api::JsonApi::Services::Paginators::Cursor::Validation#ensure_no_nesting",
    "doc": "Detect nested pagination (pagination that targets a nested to_many). This is probably never what API developers want because the a cursor only target one subset. See Nested pagination in the module doc. Traverse every request path and count the collection nesting level. If > 1, not paginateable. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Paginators.Cursor.Validation.html#error-class_method",
    "title": "Kit::Api::JsonApi::Services::Paginators::Cursor::Validation#error",
    "doc": "Simple error formatting. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Paginators.Cursor.html#paginator_type-class_method",
    "title": "Kit::Api::JsonApi::Services::Paginators::Cursor#paginator_type",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Paginators.Cursor.html#to_h-class_method",
    "title": "Kit::Api::JsonApi::Services::Paginators::Cursor#to_h",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Paginators.Cursor.html#pagination_condition-class_method",
    "title": "Kit::Api::JsonApi::Services::Paginators::Cursor#pagination_condition",
    "doc": "Add condition on QueryNode. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Paginators.Cursor.html#pagination_export-class_method",
    "title": "Kit::Api::JsonApi::Services::Paginators::Cursor#pagination_export",
    "doc": "Generate query_params from collection "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Linkers.DefaultLinker.html#to_h-class_method",
    "title": "Kit::Api::JsonApi::Services::Linkers::DefaultLinker#to_h",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Linkers.DefaultLinker.html#single-class_method",
    "title": "Kit::Api::JsonApi::Services::Linkers::DefaultLinker#single",
    "doc": "Presence: on every record possibly at the top level (virtually a to-one relationship) Impacted by: sparse fieldsets "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Linkers.DefaultLinker.html#collection-class_method",
    "title": "Kit::Api::JsonApi::Services::Linkers::DefaultLinker#collection",
    "doc": "Presence: at top level when requestion a collection (virtually a to-many relationship) Impacted by: sparse fieldsets sort filters related resources pagination "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Linkers.DefaultLinker.html#relationship_single-class_method",
    "title": "Kit::Api::JsonApi::Services::Linkers::DefaultLinker#relationship_single",
    "doc": "Presence: in a resource object to-one relationship Impacted by: sparse fieldsets sort filters related resources "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Linkers.DefaultLinker.html#relationship_collection-class_method",
    "title": "Kit::Api::JsonApi::Services::Linkers::DefaultLinker#relationship_collection",
    "doc": "Presence: in a resource object to-many relationship Impacted by: sparse fieldsets sort filters related resources pagination "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Linkers.DefaultLinker.html#generate_single_element_links-class_method",
    "title": "Kit::Api::JsonApi::Services::Linkers::DefaultLinker#generate_single_element_links",
    "doc": "Generate links from single element. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Services.Linkers.DefaultLinker.html#generate_collection_links-class_method",
    "title": "Kit::Api::JsonApi::Services::Linkers::DefaultLinker#generate_collection_links",
    "doc": "Generate paginated links from links paths. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Resources.ActiveRecordResource.html#default_filters-class_method",
    "title": "Kit::Api::Resources::ActiveRecordResource#default_filters",
    "doc": "Default filter configuration based on field type "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Resources.ActiveRecordResource.html#default_sort_fields-class_method",
    "title": "Kit::Api::Resources::ActiveRecordResource#default_sort_fields",
    "doc": "Default sort_field behaviour based on field type. Please remember that sort fields do not necessarily need to correspond to resource attribute and relationship names. sortable means we want to create a sort criteria for the field, with the same name. unique means we don't need a tie-breaker for pagination purposes tie_breaker is the unique field to use when a tie breaker is needed. The default config assumes that there will likely only be one Id type field per Resource, but that might not hold true. "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Resources.ActiveRecordResource.html#to_h-class_method",
    "title": "Kit::Api::Resources::ActiveRecordResource#to_h",
    "doc": "Returns a Resource we actualy depend on, everything else is syntaxic sugar. after Ct::Resource # TODO: in order for this to work, add ActiveSupport::Concern support in Kit::Contract "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Resources.ActiveRecordResource.html#name-class_method",
    "title": "Kit::Api::Resources::ActiveRecordResource#name",
    "doc": "Should contain the name (type) of the Resource "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Resources.ActiveRecordResource.html#model-class_method",
    "title": "Kit::Api::Resources::ActiveRecordResource#model",
    "doc": "Should contain the ActiveRecord model "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Resources.ActiveRecordResource.html#fields_setup-class_method",
    "title": "Kit::Api::Resources::ActiveRecordResource#fields_setup",
    "doc": "Hold data to generate fields, filters && sort_fields. Example The following: def self.fields_setup { id: { type: :id_numeric, sort_field: { default: true, tie_breaker: true } }, created_at: { type: :date }, updated_at: { type: :date }, name: { type: :string }, date_of_birth: { type: :date }, date_of_death: { type: :date, sort_field: { order: :desc } }, } end Is equivalent to declarings: def self.fields [:id, :created_at, :updated_at, :name, :date_of_birth, :date_of_death] end def self.filters { id: [:eq, :in], created_at: [:eq, :in, :gt, :gte, :lt, :lte], updated_at: [:eq, :in, :gt, :gte, :lt, :lte], name: [:eq, :in, :contain, :start_with, :end_with], date_of_birth: [:eq, :in, :gt, :gte, :lt, :lte], date_of_death: [:eq, :in, :gt, :gte, :lt, :lte], } end def self.sort_fields { id: { order: [[:id, :asc]], default: true }, created_at: { order: [[:created_at, :asc], [:id, :asc]] }, updated_at: { order: [[:updated_at, :asc], [:id, :asc]] }, name: { order: [[:name, :asc], [:id, :asc]] }, date_of_birth: { order: [[:date_of_birth, :asc], [:id, :asc]] }, date_of_death: { order: [[:date_of_death, :desc], [:id, :asc]] }, } end "
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Resources.ActiveRecordResource.html#fields-class_method",
    "title": "Kit::Api::Resources::ActiveRecordResource#fields",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Resources.ActiveRecordResource.html#sort_fields-class_method",
    "title": "Kit::Api::Resources::ActiveRecordResource#sort_fields",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Resources.ActiveRecordResource.html#filters-class_method",
    "title": "Kit::Api::Resources::ActiveRecordResource#filters",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Resources.ActiveRecordResource.html#relationships-class_method",
    "title": "Kit::Api::Resources::ActiveRecordResource#relationships",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Resources.ActiveRecordResource.html#data_resolver-class_method",
    "title": "Kit::Api::Resources::ActiveRecordResource#data_resolver",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Resources.ActiveRecordResource.html#record_serializer-class_method",
    "title": "Kit::Api::Resources::ActiveRecordResource#record_serializer",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Resources.ActiveRecordResource.html#linker-class_method",
    "title": "Kit::Api::Resources::ActiveRecordResource#linker",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.Resources.ActiveRecordResource.html#paginator-class_method",
    "title": "Kit::Api::Resources::ActiveRecordResource#paginator",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Controllers.JsonApi.html#ensure_media_type-class_method",
    "title": "Kit::Api::JsonApi::Controllers::JsonApi#ensure_media_type",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Controllers.JsonApi.html#ensure_content_type-class_method",
    "title": "Kit::Api::JsonApi::Controllers::JsonApi#ensure_content_type",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Api.JsonApi.Controllers.JsonApi.html#ensure_http_accept-class_method",
    "title": "Kit::Api::JsonApi::Controllers::JsonApi#ensure_http_accept",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Api.html#VERSION-constant",
    "title": "Kit::Api::VERSION",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Api.Services.Resolvers.Sql.Filtering.html#OPERATORS_STR-constant",
    "title": "Kit::Api::Services::Resolvers::Sql::Filtering::OPERATORS_STR",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Api.Services.Resolvers.ActiveRecord.html#ClassicField-constant",
    "title": "Kit::Api::Services::Resolvers::ActiveRecord::ClassicField",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Api.Services.Resolvers.ActiveRecord.html#PolymorphicField-constant",
    "title": "Kit::Api::Services::Resolvers::ActiveRecord::PolymorphicField",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Api.Services.Encryption.html#MIN_KEY_SIZE-constant",
    "title": "Kit::Api::Services::Encryption::MIN_KEY_SIZE",
    "doc": "Size of a valid key for AES-256 "
  },
  {
    "type": "constant",
    "ref": "Kit.Api.Services.Config.html#PAGE_SIZE_MAX_DEFAULT-constant",
    "title": "Kit::Api::Services::Config::PAGE_SIZE_MAX_DEFAULT",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Api.Services.Config.html#PAGE_SIZE_DEFAULT-constant",
    "title": "Kit::Api::Services::Config::PAGE_SIZE_DEFAULT",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Api.JsonApi.Controllers.JsonApi.html#JSONAPI_MEDIA_TYPE-constant",
    "title": "Kit::Api::JsonApi::Controllers::JsonApi::JSONAPI_MEDIA_TYPE",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Api.JsonApi.Contracts.html#Document-constant",
    "title": "Kit::Api::JsonApi::Contracts::Document",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Api.Contracts.html#SymbolOrString-constant",
    "title": "Kit::Api::Contracts::SymbolOrString",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Api.Contracts.html#PositiveInt-constant",
    "title": "Kit::Api::Contracts::PositiveInt",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Api.Contracts.html#FieldName-constant",
    "title": "Kit::Api::Contracts::FieldName",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Api.Contracts.html#FieldNames-constant",
    "title": "Kit::Api::Contracts::FieldNames",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Api.Contracts.html#ColumnName-constant",
    "title": "Kit::Api::Contracts::ColumnName",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Api.Contracts.html#ConditionOp-constant",
    "title": "Kit::Api::Contracts::ConditionOp",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Api.Contracts.html#ConditionOps-constant",
    "title": "Kit::Api::Contracts::ConditionOps",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Api.Contracts.html#ExtendedConditionOp-constant",
    "title": "Kit::Api::Contracts::ExtendedConditionOp",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Api.Contracts.html#Condition-constant",
    "title": "Kit::Api::Contracts::Condition",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Api.Contracts.html#FilterName-constant",
    "title": "Kit::Api::Contracts::FilterName",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Api.Contracts.html#SortOrderType-constant",
    "title": "Kit::Api::Contracts::SortOrderType",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Api.Contracts.html#SortOrderField-constant",
    "title": "Kit::Api::Contracts::SortOrderField",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Api.Contracts.html#SortOrder-constant",
    "title": "Kit::Api::Contracts::SortOrder",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Api.Contracts.html#SortOrders-constant",
    "title": "Kit::Api::Contracts::SortOrders",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Api.Contracts.html#Config-constant",
    "title": "Kit::Api::Contracts::Config",
    "doc": "The config for an API. "
  },
  {
    "type": "constant",
    "ref": "Kit.Api.Contracts.html#ResourceName-constant",
    "title": "Kit::Api::Contracts::ResourceName",
    "doc": "Resources ------------------------------------------------------------------ "
  },
  {
    "type": "constant",
    "ref": "Kit.Api.Contracts.html#Resource-constant",
    "title": "Kit::Api::Contracts::Resource",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Api.Contracts.html#Resources-constant",
    "title": "Kit::Api::Contracts::Resources",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Api.Contracts.html#ResourcesHash-constant",
    "title": "Kit::Api::Contracts::ResourcesHash",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Api.Contracts.html#RelationshipName-constant",
    "title": "Kit::Api::Contracts::RelationshipName",
    "doc": "Relationships -------------------------------------------------------------- "
  },
  {
    "type": "constant",
    "ref": "Kit.Api.Contracts.html#Relationship-constant",
    "title": "Kit::Api::Contracts::Relationship",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Api.Contracts.html#RelationshipsHash-constant",
    "title": "Kit::Api::Contracts::RelationshipsHash",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Api.Contracts.html#Resolvers-constant",
    "title": "Kit::Api::Contracts::Resolvers",
    "doc": "Resolvers ------------------------------------------------------------------ "
  },
  {
    "type": "constant",
    "ref": "Kit.Api.Contracts.html#Request-constant",
    "title": "Kit::Api::Contracts::Request",
    "doc": "Request -------------------------------------------------------------------- "
  },
  {
    "type": "constant",
    "ref": "Kit.Api.Contracts.html#Record-constant",
    "title": "Kit::Api::Contracts::Record",
    "doc": "Record --------------------------------------------------------------------- "
  },
  {
    "type": "constant",
    "ref": "Kit.Api.Contracts.html#Records-constant",
    "title": "Kit::Api::Contracts::Records",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Api.Contracts.html#QueryNode-constant",
    "title": "Kit::Api::Contracts::QueryNode",
    "doc": "QueryNode ------------------------------------------------------------------ "
  },
  {
    "type": "extra",
    "ref": "README.html",
    "title": "Kit::Api",
    "doc": "Kit::Api Kit::Api is a library that helps you build growth-ready APIs, fast. Create extensible graphs that can be exposed through one or multiple apps, and through standards like JSON:API and GraphQL for free. To learn more about Kit::Api, see Kit::Api's documentation. To understand how we think about APIs, see the About APIs guide. To learn how to use Kit::Api in your projects, see the Usage guide. Features Define Resources that are agnostic of the persistence layer Expose Resources through JSON:API endpoints and responses In progress: Expose Resources through GraphQL Copyright & License Copyright (c) 2020, Nathan Appere. Kit::Api is licensed under MIT License. "
  },
  {
    "type": "extra",
    "ref": "apis.html",
    "title": "About APIs",
    "doc": "About APIs APIs are a way of doing message-passing between systems. They allow a client to access & act on ressources of a remote system, while hidding most of the complexity of that system (encapsulation). JSON:API & GraphQL are two set of specifications that help you build API's in a standardized way, faster, avoiding bikeshedding. What truly matters Kit helps you design your apps in a domain driven way. The \"growth-ready\" way is to build your domain in a mono-repo. At first, they will likely be exposed through the same app-container in production, as it is simpler & cheaper. External clients will be able to connect to 1 API. As your business & system grow, there will be valid reasons to expose these domains as different apps in production. So now you effectively have N APIs, but you don't want clients to have to know about the specifics of the production setup. This is why having a way to aggregate & expose the various graphs (resources + operations of your domain) through a gateway is important. Layers There are different layers that can be identified for any API. Properties Definition A Query interface How you express your request (acting on data) B Query format How the various operations (read, create, update, delete) are expressed. C API's resources standardization How you standardize your API's business resources. This allows API auto-discovery and connecting graphs. (Ex for Stripe: PaymentSource, Charge, Refund, etc). D Response format The API's response format (serialization). Once we identify them in the specs, we gain the ability to build APIs that can be exposed for free through both standards. You can even mix & match if you find a valid usecase, like: GraphQL query interface + GraphQL resources standardization + JSON:API response format) This is what Kit::Api is about. "
  },
  {
    "type": "extra",
    "ref": "architecture.html",
    "title": "Architecture",
    "doc": "Architecture TODO: explain the various objects of Kit::Api & how they fit / interact with each other. Steps Parsing a request: transform the data from a JSON:API HTTP request or GraphQL request to a Request object (high level representation of the requested data). Generate a Query from that Request. Validate the Query. Resolve the Query: load the Resources data using pagination (subset), sort (ordering), filtering (conditions). Every Resource can be loaded in isolation, regardless of the level of nesting. Serialize the Query according to the used specs (generate links, apply sparse fieldsets, etc) Resolvers Load data from your persistence layer or external services as Resources. TODO: add explaination on JOIN / PRELOAD impact for distributed systems, Presto like solutions, etc. Query query = Query[ data: [Post1, Post2, Post3], relationships: [ { # Relationships for Post1 comments: { data: [Comment1A, Comment2B], relationships: [...], }, { # Relationships for Post2 comments: [Comment2A], relationships: [...], }, ], included: { comments: { data: [...], }, }, }] # Access to relationship of Post1 (might trigger a call since we traverse trough Post1) query.data[1].comments # Access to the ordered collection of Post1: query.relationships[1].comments.data "
  },
  {
    "type": "extra",
    "ref": "graphql_support.html",
    "title": "GraphQL support",
    "doc": "GraphQL support TODO: start implementation 😊. "
  },
  {
    "type": "extra",
    "ref": "jsonapi_support.html",
    "title": "JsonApi support",
    "doc": "JsonApi support Kit::Api::JsonApi helps you to implement a server side API conforming to JSON:API v1.1 spec. The goals of this gems are to: describe endpoints that can serve & modify JSON:API Documents parse & verify JSON:API query strings requests describe Resources that can be exposed as JSON:API Documents Support Current status: [x] JSONAPI Document encoding [x] Links [x] Sparse fieldsets Note that fieldsets are per type and not per relationship. [x] Sorting [x] Pagination [x] Relationships: links (including nested pagination) [x] Relationships: includes [x] Relationships: compound documents (sideloading) [x] Top level resources queries [ ] Top level relationships queries [ ] Top level meta data [ ] Errors Not supported: Polymorphic relationships. Nothing in the spec prevents them, but this seems mostly like an anti-pattern: trying to hide a join model works only if there are no attributes in use on that model, appart from foreign keys. This is often unlikely. References jsonapi-grader fantasy-dabatase endpoints-example Elixir implementation "
  },
  {
    "type": "extra",
    "ref": "jsonapi_vs_graphql.html",
    "title": "JSON:API vs GraphQL",
    "doc": "JSON:API vs GraphQL While JSON:API & GraphQL attempt to solve the same categories of problems, they take different approaches. JSON:API The spec is mostly about defining operations & the response format. Because the operations are CRUD based, you are always acting on Resources. A search operation could be modeled as POST /searches?author=Leckie. Property Quick overview A Query interface URL based. The API will need to provide N endpoints that describe the top level resources being acted on. B Query format REST based CRUD operations. Top level resource verb + top level resource url. Pagination / filters / sorting are specified through query parameters. C API's resources standardization Resources types are identified but not checked on. Schema Support #1281 D Response format This is what the spec is mostly about. The response format is quite complete: relationship VS attributes, resource de-duplication, linkage options... GraphQL GraphQL scope is larger, so it does more things. Property Quick overview A Query interface Database like. You can expose an entry point through various protocols to receive a GraphQL query. B Query format GraphQL is its own query language. It differentiates between read-only (\"query\") operations and write (\"mutable\") operations. C API's resources standardization Through schemas of the type system. D Response format JSON based. Allows duplication of resources in the payload (this makes returning collections easier.) Various: GraphQL provides \"subscription\" operations. They allow the API server to push data to registered clients. "
  }
];