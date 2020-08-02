jikan-rest-docker
=================

Simplified deployment of  `Jikan - Unofficial MyAnimeList.net REST API <https://github.com/jikan-me/jikan-rest>`_ using Docker and docker-compose with php-fpm and nginx.

Default configuration
---------------------
By default ``jikan-rest-docker`` will build latest master branch of Jikan REST API and deploy it on ``127.0.0.1:8889``, while internally using ``192.168.217.224/28`` as it's bridged network. To change any of this one needs to edit ``docker-compose.yml`` and ``Dockerfile``.

Usage
-----

Build and deploy::

  docker-compose build
  docker-compose up -d

Then one can use access API under http://127.0.0.1:8889/, like::

  curl http://127.0.0.1:8889/v3/anime/1

To update to latest code, run::

  docker-compose build --no-cache
  docker-compose up -d

