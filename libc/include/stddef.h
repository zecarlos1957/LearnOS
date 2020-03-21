#pragma once

typedef long long ptrdiff_t;
typedef unsigned long long size_t;
typedef long double max_align_t;

#define NULL ((void*)0)

#define offsetof(s,m) ((size_t)&(((s*)0)->m))
