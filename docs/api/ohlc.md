# Open-High-Low-Close

## Request

> <https://api.bitpanda.com/v2/ohlc/eur/${PERIOD}?assets=${ASSET_SYMBOL}>

where `ASSET_SYMBOL` is retrieved from [assets request](assets.md) and period is:

- `day`
- `week`
- `month`
- `year`

> ⚠️ More assets can be specified at once, if separated by `,` (which must be urlencoded then)

## Response

```json
{
  "data": {
    "AMZN": [
      {
        "type": "candle",
        "attributes": {
          "open": "114.44",
          "high": "114.52",
          "close": "114.52",
          "low": "114.52",
          "time": {
            "date_iso8601": "2022-10-14T07:30:00+02:00",
            "unix": "1665725400"
          }
        }
      }
    ]
  }
}
```
