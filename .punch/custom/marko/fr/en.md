# Entities
{{id: .en, parent: fr}}

The system utilises the following entities:

@@list

## User
{{id: .user}}



The entity should provide the following properties:

Property | Type | Multiplicity | Description
-------- | ---- | ------------ | -----------
name |  | 1 | User name from Users domain

Table: Entity "User"

## Article
{{id: .article}}



The entity should provide the following properties:

Property | Type | Multiplicity | Description
-------- | ---- | ------------ | -----------
title | title | 1 | Article Title
description | description | 1 | Article Description
price | money | 1 | Article Price
removed_at | timestamp | 1 | Article Removed At

Table: Entity "Article"

## Order
{{id: .order}}



The entity should provide the following properties:

Property | Type | Multiplicity | Description
-------- | ---- | ------------ | -----------
created_by | uuid | 1 | Order Created By
created_at | timestamp | 1 | Order Created At
status | order_status | 1 | Order Status
status_at | timestamp | 1 | Order Status Changed At
articles | order_articles | 1 | Order Articles

Table: Entity "Order"

