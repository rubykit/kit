# JSON:API vs GraphQL

API's are a way of solving RPC: they allow a client to access & act on ressources of a remote system, while hidding the complexity of that system (encapsulation).

If your system is distributed (think: micro-services with their own specialized APIs), standadization helps you expose it as one API to your clients.

![API Proxy](assets/images/api_proxy.png)

While JsonAPI & GraphQL are mostly interchangeable, they have some differences.

| Properties | `JsonApi` | `GraphQL` |
| -------- | -------- | -------- |
| `A` Schemas | [Json-Schema](https://json-schema.org/) | ✅ |
| `B` Mutations | REST Based | Anything you want. |
| `C` Payloads | Object embedded once | Objects embedded N times |
| `D` Scale | ✅ | ✅ |



