#pragma once

#include <bits/alltypes.h>

#define __STDC_VERSION_STDDEF_H__ 202311L

typedef _Addr ptrdiff_t;

typedef unsigned _Addr size_t;

// musl way of a max alignment object.
typedef struct {
    long long __ll;
    long double __ld;
} max_align_t;
typedef unsigned wchar_t;

#define NULL ((void*) 0)

#if defined(__GNUC__) || defined(__clang__)
#define unreachable() do { __builtin_unreachable(); } while (0)
#endif

#define offsetof(type, member) \
    ((size_t)( (char *)&(((type *)0)->member) - (char *)0 ))

// TODO: Maybe check if the compiler supports c23 or not?
typedef typeof_unqual(nullptr) nullptr_t;
