# TODO

- Improve granularity of error messages. Currently, only the error message is used, but the API sends back details as well.

```json
{
  "error": {
    "message": "invalid input in field 'name'",
    "code": "invalid_input",
    "details": {
      "fields": [
        {
          "name": "name",
          "messages": [
            "Name must be a valid hostname."
          ]
        }
      ]
    }
  }
}
```
