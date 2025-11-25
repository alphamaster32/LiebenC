#pragma once

#define __STDC_VERSION_STDIO_H__ 202311L

// Because we always return a pointer this type is irrelevant.
typedef struct {
    char __x;
} _IO_FILE;
typedef _IO_FILE FILE;
