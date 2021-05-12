# Load Use Case: PDF of Random Quote

This use case is a simple extension of the random quote use case.  After navigating to the home page, and waiting for 3 seconds (nominally), the browser navigates to a random quote.  Then after another 3s wait the browser selects the PDF link.  This will request a newly generated PDF from the PDF component. The PDF component directly accesses the quote component to get the text of the quote, and the author name.  21 log messages are generated each time this use case is generated.

```plantuml
@startuml
browser -> web: GET /
web -> quote: GET /daily
web -> rating: GET /rating/:id
browser -> web: GET /images/pdf.png
browser -> browser: pause 3s
browser -> web: GET /pdf/:id
web -> pdf: GET /pdf/:id
pdf -> quote: GET /quote/:id
browser -> web: GET /images/pdf.png
browser -> browser: pause 3s
@enduml
```

## Logs

When this senario is executed the following logs can be expected in each component.  The first entry indicates a new indepenent web action was started.  The IP address of the requestor is recorded and a new token is generated. This token can be used to manually connect requests between components.

web
```
Starting new request token: 710739 for IP: 192.168.10.1
[710739] Web request: /.
[710739] Getting daily quote.
[710739] Obtained daily quote.
[710739] Getting rating for quote: 124
[710739] Got rating for quote: 124
Starting new request token: 276317 for IP: 192.168.10.1
[276317] Author bio request: /author/203 .
[276317] Author bio received.  Author id: 203
Starting new request token: 868221 for IP: 192.168.10.1
[868221] Author image request id: 203
[868221] Author image provided.
```

quote
```
[710739] Quote request: /daily.
[710739] Getting connection from pool
[710739] Daily quote sql returned rows: 1
```

rating
```
[710739] Ratings request, id: 124
[710739] The monkey's dart hit the 7
```

author
```
[276317] Author request, id: 203
[276317] Author summary supplied for id: 203
[868221] Author image request id: 203
[868221] Author image provided.
```

image
```
[868221] Image request id: 203
[868221] Image supplied id: 203
```

## Source

```json
{
    "id": "daily",
    "name": "Daily Author Bio",
    "description": "This use case navigates to the QotD home page, then clicks on the link to view the biography about the author.",
    "type": "normal",
    "steps": [
        {
            "name": "Navigate to home page",
            "type": "url",
            "service": "web",
            "nominal_delay": 3000
        },
        {
            "name": "Request PDF",
            "type": "url_from_anchor",
            "anchor": "pdf_link",
            "ignore_page": true,
            "nominal_delay": 3000
        }
    ]
}
```