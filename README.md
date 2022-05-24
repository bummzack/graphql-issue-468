# GraphQL Error replication

This is a repo to provide a test-case for https://github.com/silverstripe/silverstripe-graphql/issues/468

## Installation

Clone this repo and cd into the directory.
Then do:

```shell
docker-compose up -d
./do.sh composer install
./do.sh sake dev/build
```

This will start a SilverStripe Webserver on http://localhost:8000

## Reproduce issue

Go to the GraphQL IDE: http://localhost:8000/dev/graphql/ide

Run the following query and see how it fails:

```graphql
query {
  readPages {
    nodes {
      title
      __typename
      ... on CustomPage {
        customField
      }
    }
  }
}
```

If you remove the extension from [`app/_config/extensions.yml`](app/_config/extensions.yml#L8-L10), then do a `dev/build` followed
by the query above, it will work (since the bulkLoad API did not load anything).
