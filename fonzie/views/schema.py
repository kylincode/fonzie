# -*- coding: utf-8 -*-
"""
Schema-related API views
"""
from __future__ import absolute_import, unicode_literals

from drf_openapi.views import SchemaView
from rest_framework import permissions


class FonzieSchemaView(SchemaView):
    """Fonzie, Open API schema view"""

    permission_classes = (permissions.AllowAny, )