#!/bin/bash

set -e

glxinfo | egrep "OpenGL vendor|OpenGL renderer"

