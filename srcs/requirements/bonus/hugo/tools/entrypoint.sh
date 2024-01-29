#!/bin/sh

cd /hugo

hugo

exec "$@"
