#pragma once

#include <bits/alltypes.h>

#define __STDC_VERSION_STDINT_H__ 202311L

typedef int8_t int_least8_t;
typedef int16_t int_least16_t;
typedef int32_t int_least32_t;
typedef int64_t int_least64_t;

typedef uint8_t uint_least8_t;
typedef uint16_t uint_least16_t;
typedef uint32_t uint_least32_t;
typedef uint64_t uint_least64_t;

typedef int8_t int_fast8_t;
typedef int32_t int_fast16_t;
typedef int32_t int_fast32_t;
typedef int64_t int_fast64_t;

typedef uint8_t uint_fast8_t;
typedef uint32_t uint_fast16_t;
typedef uint32_t uint_fast32_t;
typedef uint64_t uint_fast64_t;

typedef _Addr intptr_t;
typedef unsigned _Addr uintptr_t;

typedef _Int64 intmax_t;
typedef unsigned _Int64 uintmax_t;

#define INT8_WIDTH 8
#define INT16_WIDTH 16
#define INT32_WIDTH 32
#define INT64_WIDTH 64
#define UINT8_WIDTH 8
#define UINT16_WIDTH 16
#define UINT32_WIDTH 32
#define UINT64_WIDTH 64

#define INT_LEAST8_WIDTH 8
#define INT_LEAST16_WIDTH 16
#define INT_LEAST32_WIDTH 32
#define INT_LEAST64_WIDTH 64
#define UINT_LEAST8_WIDTH 8
#define UINT_LEAST16_WIDTH 16
#define UINT_LEAST32_WIDTH 32
#define UINT_LEAST64_WIDTH 64

#define INT_FAST8_WIDTH 8
#define INT_FAST16_WIDTH 16
#define INT_FAST32_WIDTH 32
#define INT_FAST64_WIDTH 64
#define UINT_FAST8_WIDTH 8
#define UINT_FAST16_WIDTH 16
#define UINT_FAST32_WIDTH 32
#define UINT_FAST64_WIDTH 64

#define INTPTR_WIDTH 16
#define UINTPTR_WIDTH 16

#define INTMAX_WIDTH 64
#define UINTMAX_WIDTH 64

#define PTRDIFF_WIDTH 16
#define SIG_ATOMIC_WIDTH 8
#define SIZE_WIDTH 16
#define WCHAR_WIDTH 8
#define WINT_WIDTH 16

#define INT8_C(c)  c
#define INT16_C(c) c
#define INT32_C(c) c

#define UINT8_C(c)  c
#define UINT16_C(c) c
#define UINT32_C(c) c ## U

#define INT64_C(c) c ## LL
#define UINT64_C(c) c ## ULL
#define INTMAX_C(c)  c ## LL
#define UINTMAX_C(c) c ## ULL
