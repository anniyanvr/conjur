---
title: CyberArk Conjur
layout: home
section: welcome
id: index
description: Conjur is a scalable, flexible, open source security service that stores secrets, provides machine identity based authorization, and more.
---



<div class="container">
  <h1>Conjur Open Source</h1>

  <div id="repo-tabs">

    <ul>
      <li><a href="#repo-tabs-core">Conjur Core</a></li>
      <li><a href="#repo-tabs-integrations">Conjur Integrations</a></li>
      <li><a href="#repo-tabs-last-mile">Last Mile Secrets Delivery</a></li>
    </ul>

    <div id="repo-tabs-core">

      {% assign section = site.data.repositories.core.section %}
      {% assign categories = section.categories %}

      <p>{{ section.description }}</p>

      {% for category in categories %}
        {% assign repos = category.repos %}

        <h2>{{ category.name }}</h2>
        <p>{{ category.description }}</p>

        <ul class="posts">
          {% for repo in repos %}
            <li class="post card">
              {% if repo.image %}
                <img class="post-list-thumb" src="{{ base.url }}/img/repos/{{ repo.thumb }}" alt="{{ repo.image-alt }}">
              {% endif %}
              <div class="post-content">
                <a href="{{ repo.url }}"><h2>{{ repo.name }}</h2><span class="blog-subhead">{{ repo.sub }}</span></a>
                {{ repo.description | strip_html | truncatewords: 40 }}
              </div>
            </li>
          {% endfor %}
        </ul>
      {% endfor %}

    </div>

    <div id="repo-tabs-integrations">

      {% assign section = site.data.repositories.integrations.section %}
      {% assign categories = section.categories %}

      <p>{{ section.description }}</p>

      {% for category in categories %}
        {% assign repos = category.repos %}

        <h2>{{ category.name }}</h2>
        <p>{{ category.description }}</p>

        <ul class="posts">
          {% for repo in repos %}
            <li class="post card">
              {% if repo.image %}
                <img class="post-list-thumb" src="{{ base.url }}/img/repos/{{ repo.thumb }}" alt="{{ repo.image-alt }}">
              {% endif %}
              <div class="post-content">
                <a href="{{ repo.url }}"><h2>{{ repo.name }}</h2><span class="blog-subhead">{{ repo.sub }}</span></a>
                <strong>{{ repo.tool }}:</strong> {{ repo.description | strip_html | truncatewords: 40 }}
              </div>
            </li>
          {% endfor %}
        </ul>
      {% endfor %}

    </div>

    <div id="repo-tabs-last-mile">

      {% assign section = site.data.repositories.delivery.section %}
      {% assign categories = section.categories %}

      <p>{{ section.description }}</p>

      {% for category in categories %}
        {% assign repos = category.repos %}

        <h2>{{ category.name }}</h2>
        <p>{{ category.description }}</p>

        <ul class="posts">
          {% for repo in repos %}
            <li class="post card">
              {% if repo.image %}
                <img class="post-list-thumb" src="{{ base.url }}/img/repos/{{ repo.thumb }}" alt="{{ repo.image-alt }}">
              {% endif %}
              <div class="post-content">
                <a href="{{ repo.url }}"><h2>{{ repo.name }}</h2><span class="blog-subhead">{{ repo.sub }}</span></a>
                {{ repo.description | strip_html | truncatewords: 40 }}
              </div>
            </li>
          {% endfor %}
        </ul>
      {% endfor %}

    </div>

  </div>
</div>

<script>
  $( function() {
    $( "#repo-tabs" ).tabs();
  } );
</script>
