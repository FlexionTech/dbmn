---
lesson_id: lesson_1
number: 1
slug: first-contact
title: First Contact
goal: Connect Dobermann to The Training Ground and run your first API requests
estimate: ~10 minutes
completion:
  criteria: Successful GETs against all four reference endpoints
  summary: carriers, locations, products and trading partners
checkpoint:
  pass: Good dog. All four reference endpoints fetched — Lesson 2 is unlocked.
  fail: Did the dog eat your homework? Looks like you haven't fetched all the reference data yet.
---

## Step 1 — Install and Sign In

Click the Dobermann icon in your VS Code activity bar.

Not installed yet? [Get it from the VS Code Marketplace.](https://marketplace.visualstudio.com/items?itemName=dbmn.dobermann)

Sign in with the same account you used to get here. Once you're in, you're ready.

## Step 2 — Create Your Environment

An **environment** is where an API lives — its address and how you authenticate against it.
Set it up once, and every endpoint you build inside it inherits both.

In Dobermann, go to **Environments** and create a new one:

| Field | Value |
|---|---|
| Name | `DBMN Puppy School` |
| Base URL | `https://api.dbmn.io/functions/v1/playground` |
| Authentication | `DBMN` |

No tokens to copy. No headers to configure by hand. Dobermann injects your authentication
automatically at runtime, across every endpoint in this environment.

> **In a hurry?**
>
> You can [download the starter file](/puppy-school/files/puppy-school-starter.dbmn.zip)
> and import via the dbmn hub menu — it creates this environment and every endpoint in
> the course. Do it by hand first if you can, though. Knowing how an environment is put
> together is worth the two minutes.

## Step 3 — Your First Request

Copy the template below, then click **Paste**  option on the New Endpoint menu in Dobermann (do we need a screen shot here??) 

```
// Name: Get Carriers
// Method: GET
// Path: /reference/carriers
```

Hit **Run**. The Console opens automatically with your results.

## Step 4 — Reading the Console

The Console is where every response lands. It has several tabs — let's walk through the
ones that matter right now.

**The Completed tab** shows your successful responses as a structured data table. It should
open by default with your carrier data. If you don't directly see the data you expect at this point, it could be because the data you want to see is "nested" within the JSON response. 

```json
{
  "data": [
    {
      "scac": "BARK",
      "name": "BarkPost Express",
      "breed": "Golden Retriever",
      "motto": "Every package gets a tail wag"
    }
  ]
}
```

The carrier records are inside that `data` array. If you see only "data" we will need to ((we have by default expand data, and set as root. we could also put a link to "View Manager" here for people wanting to skip ahead. we must talk about view manager here a LITTLE bit.)) The table
re-renders instantly with each carrier as its own row — SCAC codes, names, breeds, mottos —
sortable and searchable.

**The RAW tab** shows the full HTTP conversation: the exact request sent and the complete
response received, syntax-highlighted. Click it now and have a look. This is where you go
when you need to know what actually went over the wire. Toggle the **Request** and
**Response** checkboxes to show or hide each half.

## Step 5 — Explore the Reference Data

Create an endpoint for each of the following. Copy each template, use the new from clipboard, save, then hit **Run**.

```
// Name: Get Locations
// Method: GET
// Path: /reference/locations
```

```
// Name: Get Products
// Method: GET
// Path: /reference/products
```

```
// Name: Get Trading Partners
// Method: GET
// Path: /reference/trading-partners
```

For each one, use what you just learned: **Completed** tab, expand the `data` field,
and **Set as Root**. This updates the current **View**, and will default for every API call made in future. Views are covered in detail in section ((linkto section, and another link)). for impatient puppies, click here for dbmn docs

These four are your master data — carriers, warehouses, products and trading partners.
You'll reference them throughout Puppy School, and they behave exactly like the lookup
tables on a real implementation project: everything you load has to point at something
that already exists here. In Lesson 3 you'll find out what happens when it doesn't.

The full API reference lives at [dbmn.io/docs/playground](/docs/playground/) if you want to
see everything The Training Ground offers.

> **🐾 Dobermann Philosophy**
>
> Authentication should be configured once and forgotten. In Dobermann, auth lives at the
> environment level — every endpoint in that environment inherits it automatically. If your
> session expires, Dobermann tells you before execution begins, not halfway through a large
> batch run.

> **🦴 Dig Deeper**
>
> REST APIs use standard HTTP methods to declare intent — GET retrieves without modifying,
> POST creates, PUT updates, DELETE removes. Everything you just ran was a GET: read-only
> calls that leave the data exactly as you found it.
> [MDN's HTTP methods reference](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods)
> is worth bookmarking.
