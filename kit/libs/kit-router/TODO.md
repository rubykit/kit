2 categories of concepts:

- Endpoints (with aliases that represent the endpoint)

- Mountpoints
  [:http, [:get, '/users/sign-in']] || { type: :http, id: { verb: :get, path: '/users/sign-in' } }

  In the same way that alaises need to be explicitely attached to endpoints, we should probably force every alias to be mounted properly to avoid issues.

TODO:
  - Create store grouping (endpoints / aliases / mountpoints) to do dependency injection properly (like specs)
  - Create CLI tool to represent:
    - available endpoints
    - available aliases
    - available mountpoints
    - aliases that needs to be explicitely mounted (and provide default if an endpoint only has one mountpoint)
    - use types