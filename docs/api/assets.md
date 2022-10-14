# Asset

## Request

> <https://api.bitpanda.com/v3/assets?page=0&page_size=500&type[]=${ASSET_CLASS}>

Where ASSET_CLASS is:

- cryptocoin
- etf
- stock
- metals
- etc (commodities)

## Response

```json
{
  "data": [
    {
      "type": "asset",
      "attributes": {
        "symbol": "ALUMINIUM",
        "name": "Aluminium"
      },
      "id": "2680"
    }
  ],
  "meta": {
    "total_count": 30,
    "page": 1,
    "page_size": 1
  },
  "links": {
    "next": "?page=2&page_size=1",
    "last": "?page=30&page_size=1",
    "self": "?page=1&page_size=1"
  }
}
```

if `data.links.next` is `nil`; then stop sending requests.
