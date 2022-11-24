---
layout: default
title: Meta store
permalink: /meta_store/
has_children: true
nav_order: 11
---

# Meta store

It's a simple PORO to persist meta data about action, like errors or some status or whatever you want, depends on your needs.
By default each action uses `Decouplio::DefaultMetaStore`, but you can define your own.

## Behavior
 - In case if inner action is used, then meta_store from parent action will be used inside inner action.
