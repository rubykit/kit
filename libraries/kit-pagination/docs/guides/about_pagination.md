# About Pagination

For a `set` that contains N `elements`, pagination is way to obtain `subsets` of this `set` (often with `ordering` constraints). This `subset` can be referred to as a `page`".

## Page ID

In order to identify that `subset`, you will need a `subset identifier` (or `subset id`, `page id`).

This `page id`  contains the data necessary to obtain a `subset`.

|  | **Transparent** | **Opaque** |
|-----------------|-------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Example | `page=2` | `page=LKJlhJ_h2` |
| Pagination data | Visible to the pagination user  | Not visible to the pagination user  |
| Access | Sequential or not | Sequential only |
| Used when | * The pagination data is simple * Non sequential access is needed | * The pagination data is complex * non sequential access is not needed Here the client receives an opaque chunk of data, the `cursor`, that is sent back to get the next or previous page. |                                                               |
