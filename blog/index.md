---
title: Blog
layout: default
nav_order: 50
has_children: false
---

# Blog

{% for post in site.posts %}
### [{{ post.title }}]({{ post.url }})
*{{ post.date | date: "%B %d, %Y" }}*

{{ post.excerpt }}

---
{% endfor %}

{% if site.posts.size == 0 %}
*No posts yet. Check back soon!*
{% endif %}
