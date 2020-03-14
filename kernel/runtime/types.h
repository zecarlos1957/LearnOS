
#ifndef TYPES_H
#define TYPES_H

/*
 *	General C-Types
 */
typedef unsigned char 	uint8_t;
typedef unsigned short 	uint16_t;
typedef unsigned int32_t 	uint32_t;
typedef unsigned long long 	uint64_t;


typedef signed char 	int8_t;
typedef signed short 	int16_t;
typedef signed int32_t 		int32_t;
typedef signed long long	int64_t;


typedef unsigned char uchar_t;

typedef unsigned int32_t size_t;
typedef int32_t pid_t;
typedef int64_t ino_t;
typedef int64_t off_t;
typedef int32_t dev_t;
typedef int32_t mode_t;
typedef int32_t nlink_t;
typedef int32_t uid_t;
typedef int32_t gid_t;
typedef int32_t blksize_t;
typedef int64_t blkcnt_t;
#define time_t int64_t

struct stat_fs {
    dev_t st_dev;
    ino_t st_ino;
    mode_t st_mode;
    nlink_t st_nlink;
    uid_t st_uid;
    gid_t st_gid;
    dev_t st_rdev;
    off_t st_size;
    blksize_t st_blksize;
    blkcnt_t st_blocks;
    time_t st_atime;
    time_t st_mtime;
    time_t st_ctime;
};


/*
* Return code
*/
enum{
	RETURN_OK=0,
	NOT_DEFINED=-1, //If not implemented
	ERROR_MEMORY=-2,
	PARAM_NULL=-3,
	ERROR_PARAM=-4,
	RETURN_FAILURE=-128 //Added by NoMaintener aka William. In case of error
};
 
 
/*
 *	Interruption handler
 */
typedef void (*int_handler)(void);


#define NULL 0
#define true 1
#define false 0

#endif
