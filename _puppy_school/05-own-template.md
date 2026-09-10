---
lesson_id: lesson_5
number: 5
slug: own-template
title: Your Own Template
goal: Build an endpoint and a nested data load from scratch, using data you extracted yourself
estimate: ~20 minutes
completion:
  criteria: Five or more successful POSTs to /purchase-orders after Lesson 4 was completed
  summary: purchase orders created from your own template
checkpoint:
  pass: Good dog. You built the endpoint, you shaped the data, you loaded it. There is nothing left for us to teach you — go and do it on something that matters.
  fail: We can't see your purchase orders yet. Check the batch ran, and that the Errors tab is empty — a template that isn't quite right shows up there with the reason.
note_to_reviewer: >
  This lesson verifies Lesson 4 indirectly — the spreadsheet being loaded here is the export
  produced there. Distinct resource path (/purchase-orders) keeps the check unambiguous.
---

Everything so far has handed you a template. This lesson does not.

You have a low-stock report from Lesson 4. The warehouses need replenishing, which means
turning that flat spreadsheet into **purchase orders** — a nested structure, one order per
warehouse, one line per product.

Flat data in, nested data out. That is the job, on every project, forever.

## Step 1 — Look Before You Build

Never write a template against an API you haven't looked at. Create a quick endpoint and run it:

```
// Name: Puppy School — List Purchase Orders
// Method: GET
// Path: /purchase-orders
// QueryParam: size: 5 [enabled]
```

In the Console, expand a purchase order and look at its shape. A header — PO number, buyer,
supplier, status, currency — with a `lines` array hanging off it, each line carrying a
product, a quantity and a price.

That nesting is what you have to produce. The full field list is in the
[Training Ground API reference](/docs/playground/#po-upload) if you want it written down.

## Step 2 — Write One Purchase Order by Hand

Create a new endpoint. This time you're writing the body yourself, not pasting a template.

```
// Name: My Replenishment Orders
// Method: POST
// Path: /purchase-orders
// Header: Content-Type: application/json [enabled]
```

In the body, write a single, complete, real purchase order with hardcoded values:

```json
{
  "poNumber": "PO-REPLEN-001",
  "buyerName": "Golden Retriever Distribution Center",
  "supplierName": "Chewy Supply Co",
  "status": "submitted",
  "currency": "USD",
  "lines": [
    {
      "lineNumber": 1,
      "sku": "SKU-WOOF-001-00001",
      "description": "Premium Belly Rub Machine",
      "orderedQty": 500,
      "unitPrice": 24.99,
      "uom": "EA"
    }
  ]
}
```

**Run it.** Not because you need this order, but because a template built on an untested body
is a template that fails five thousand times in a row. Get one right first. If it errors, the
Console tells you which field it objected to — fix it, run again.

Now you know the endpoint works.

## Step 3 — Turn It Into a Template

Put your cursor on each line in turn and press **Ctrl+M**.

Dobermann replaces each hardcoded value with a `{{variable}}`, names it from the key, infers
the type, and keeps the original as a comment. Your body becomes:

```json
{
  "poNumber": "{{poNumber}}",
  "buyerName": "{{buyerName}}",
  "supplierName": "{{supplierName}}",
  "status": "{{status}}",
  "currency": "USD",
  "lines": [
    {
      "lineNumber": "{{lineNumber:number}}",
      "sku": "{{sku}}",
      "description": "{{description}}",
      "orderedQty": "{{orderedQty:number}}",
      "unitPrice": "{{unitPrice:number}}",
      "uom": "{{uom}}"
    }
  ]
}
```

Leave `currency` hardcoded. Not everything needs to be a variable — fields that never vary
are clearer left alone, and it's one less column to carry.

**Run** has become **Run Batch**. You built that.

## Step 4 — Shape Your Spreadsheet

Open your Lesson 4 export. You need one row per **line item**, with the order's details
repeated on every row that belongs to it. Dobermann groups them back up for you.

Starting from the columns you exported, you need:

| Column | Where it comes from |
|---|---|
| `poNumber` | you invent it — one value per warehouse, e.g. `PO-REPLEN-001` |
| `buyerName` | your exported `location.name` |
| `supplierName` | pick anything sensible — it's your order |
| `status` | `submitted` |
| `lineNumber` | 1, 2, 3… within each order |
| `sku` | your exported `sku` |
| `description` | your exported `description` |
| `orderedQty` | how much to reorder — a fixed number is fine |
| `unitPrice` | make one up, or reuse `product.unitPrice` |
| `uom` | your exported `uom` |

Trim it down to something manageable first — a handful of warehouses and a few dozen lines
each is plenty. You're proving a structure, not restocking a continent. (The API accepts up
to 1,000 rows per request, counting headers *and* lines together.)

## Step 5 — Load It

Open **Batch Preparation** and load your spreadsheet.

At **Review JSON**, look carefully at the generated request. Every row that shares a
`poNumber` has been folded into a **single purchase order with multiple lines** — the header
fields taken once, the line fields repeated per row. You wrote a flat spreadsheet and
Dobermann rebuilt the nesting from it.

That is the trick the whole course has been walking towards. Nested APIs, flat source data,
no scripting.

Run the batch.

## Step 6 — Prove It Landed

Go back to **Puppy School — List Purchase Orders** and run it again.

Your orders are there, with their lines nested underneath and the supplier resolved from the
reference data. Build a view over it if you want to see them properly — you know how now.

---

That's Puppy School. You can connect to an API, load data at volume, deal with the failures,
get data back out in a shape a human can use, and build your own templates for structures
nobody handed you.

The rest is just other people's APIs.

> **🐾 Dobermann Philosophy**
>
> Every tool can do the demo. The test is whether it can do the thing nobody demoed — an
> endpoint you've never seen, a structure invented by a committee, a spreadsheet from a
> system that was decommissioned in 2011. Dobermann is built so the answer is always the same
> handful of moves: look at the shape, write one, make it a template, load the file.

> **🦴 Dig Deeper**
>
> Flat-to-nested is the oldest problem in data integration and the reason most projects end
> up with a folder of one-off scripts. The general shape is always the same: decide which
> columns identify the parent, group the rows by them, and nest the rest.
> [Template Variables](/docs/template-variables/) and
> [Batch Preparation](/docs/batch-preparation/) cover everything Dobermann can do with it.
