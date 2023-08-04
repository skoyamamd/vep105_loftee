#!/bin/bash

unset DX_WORKSPACE_ID; \
dx cd $DX_PROJECT_CONTEXT_ID:; \
dx download /annotation/data/*
