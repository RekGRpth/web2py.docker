#include <arpa/nameser.h>
#include <errno.h>
#include <resolv.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
//#include <libio/libioP.h>

/* Write formatted output to stdout from the format string FORMAT.  */
int
__printf_chk (int flag, const char *format, ...)
{
  /* For flag > 0 (i.e. __USE_FORTIFY_LEVEL > 1) request that %n
     can only come from read-only format strings.  */
//  unsigned int mode = (flag > 0) ? PRINTF_FORTIFY : 0;
  va_list ap;
  int ret;

  va_start (ap, format);
//  ret = __vfprintf_internal (stdout, format, ap, mode);
  ret = vfprintf (stdout, format, ap);
  va_end (ap);

  return ret;
}
//ldbl_strong_alias (___printf_chk, __printf_chk)

char *
canonicalize_file_name (const char *name)
{
  return realpath (name, NULL);
}

//#include <arpa/nameser.h>
//#include <resolv.h>
//#include <shlib-compat.h>
int
__dn_expand (const unsigned char *msg, const unsigned char *eom,
              const unsigned char *src, char *dst, int dstsiz)
{
  int n = ns_name_uncompress (msg, eom, src, dst, (size_t) dstsiz);
  if (n > 0 && dst[0] == '.')
    dst[0] = '\0';
  return n;
}

//#include <errno.h>
//#include <sys/ucontext.h>
//#include <ucontext.h>
# define __set_errno(val) (errno = (val))
int
//getcontext (ucontext_t *ucp)
getcontext (void *ucp)
{
  __set_errno (ENOSYS);
  return -1;
}

//#include <resolv.h>
//#include <resolv/resolv-internal.h>
//#include <resolv/resolv_context.h>
/*static int
context_search_common (void *ctx,
		       const char *name, int class, int type,
		       unsigned char *answer, int anslen)
{
  if (ctx == NULL)
    {
      RES_SET_H_ERRNO (&_res, NETDB_INTERNAL);
      return -1;
    }
  int result = res_context_search (ctx, name, class, type, answer, anslen,
				     NULL, NULL, NULL, NULL, NULL);
  __resolv_context_put (ctx);
  return result;
}*/
int
__res_nsearch (void *statp,
		const char *name,      /* Domain name.  */
		int class, int type,   /* Class and type of query.  */
		unsigned char *answer, /* Buffer to put answer.  */
		int anslen)	       /* Size of answer.  */
{
    return 0;
//  return context_search_common
//    (__resolv_context_get_override (statp), name, class, type, answer, anslen);
}
int
bindresvport (int sd, struct sockaddr_in *sin)
{
  static short port;
  struct sockaddr_in myaddr;
  int i;

#define STARTPORT 600
#define LOWPORT 512
#define ENDPORT (IPPORT_RESERVED - 1)
#define NPORTS	(ENDPORT - STARTPORT + 1)
  static short startport = STARTPORT;

  if (sin == (struct sockaddr_in *) 0)
    {
      sin = &myaddr;
      memset (sin, 0, sizeof (*sin));
      sin->sin_family = AF_INET;
    }
  else if (sin->sin_family != AF_INET)
    {
      __set_errno (EAFNOSUPPORT);
      return -1;
    }

  if (port == 0)
    {
      port = (getpid () % NPORTS) + STARTPORT;
    }

  /* Initialize to make gcc happy.  */
  int res = -1;

  int nports = ENDPORT - startport + 1;
  int endport = ENDPORT;

#define __libc_lock_lock(NAME)
  __libc_lock_lock (lock);

 again:
  for (i = 0; i < nports; ++i)
    {
      sin->sin_port = htons (port++);
      if (port > endport)
	port = startport;
      res = bind (sd, (const struct sockaddr *)sin, sizeof (struct sockaddr_in));
      if (res >= 0 || errno != EADDRINUSE)
	break;
    }

  if (i == nports && startport != LOWPORT)
    {
      startport = LOWPORT;
      endport = STARTPORT - 1;
      nports = STARTPORT - LOWPORT;
      port = LOWPORT + port % (STARTPORT - LOWPORT);
      goto again;
    }

#define __libc_lock_unlock(NAME)
  __libc_lock_unlock (lock);

  return res;
}
//libc_hidden_def (bindresvport)
int
__vsprintf_chk (char *s, int flag, size_t slen, const char *format,
		 va_list ap)
{
  /* For flag > 0 (i.e. __USE_FORTIFY_LEVEL > 1) request that %n
     can only come from read-only format strings.  */
//  unsigned int mode = (flag > 0) ? PRINTF_FORTIFY : 0;

  /* Regardless of the value of flag, let __vsprintf_internal know that
     this is a call from *printf_chk.  */
//  mode |= PRINTF_CHK;

//  if (slen == 0)
//    __chk_fail ();

  return vsprintf (s, format, ap);
}
//#include <arpa/nameser.h>
int
__dn_skipname (const unsigned char *ptr, const unsigned char *eom)
{
  const unsigned char *saveptr = ptr;
//  if (__ns_name_skip (&ptr, eom) < 0)
//    return -1;
  return ptr - saveptr;
}
//#include <arpa/nameser.h>

int
backtrace (void **array, int size)
{
  /*struct trace_arg arg =
    {
     .array = array,
     .unwind_link = __libc_unwind_link_get (),
     .cfa = 0,
     .size = size,
     .cnt = -1
    };

  if (size <= 0 || arg.unwind_link == NULL)
    return 0;

  UNWIND_LINK_PTR (arg.unwind_link, _Unwind_Backtrace)
    (backtrace_helper, &arg);

  / * _Unwind_Backtrace seems to put NULL address above
     _start.  Fix it up here.  * /
  if (arg.cnt > 1 && arg.array[arg.cnt - 1] == NULL)
    --arg.cnt;
  return arg.cnt != -1 ? arg.cnt : 0;*/
  return 0;
}

char **
backtrace_symbols (void *const *array, int size)
{
  return NULL;
  /*Dl_info info[size];
  int status[size];
  int cnt;
  size_t total = 0;
  char **result;

  /  Fill in the information we can get from `dladdr'.  * /
  for (cnt = 0; cnt < size; ++cnt)
    {
      struct link_map *map;
      status[cnt] = _dl_addr (array[cnt], &info[cnt], &map, NULL);
      if (status[cnt] && info[cnt].dli_fname && info[cnt].dli_fname[0] != '\0')
	{
	  / * We have some info, compute the length of the string which will be
	     "<file-name>(<sym-name>+offset) [address].  * /
	  total += (strlen (info[cnt].dli_fname ?: "")
		    + strlen (info[cnt].dli_sname ?: "")
		    + 3 + WORD_WIDTH + 3 + WORD_WIDTH + 5);

	  / * The load bias is more useful to the user than the load
	     address.  The use of these addresses is to calculate an
	     address in the ELF file, so its prelinked bias is not
	     something we want to subtract out.  * /
	  info[cnt].dli_fbase = (void *) map->l_addr;
	}
      else
	total += 5 + WORD_WIDTH;
    }

  / * Allocate memory for the result.  * /
  result = (char **) malloc (size * sizeof (char *) + total);
  if (result != NULL)
    {
      char *last = (char *) (result + size);

      for (cnt = 0; cnt < size; ++cnt)
	{
	  result[cnt] = last;

	  if (status[cnt]
	      && info[cnt].dli_fname != NULL && info[cnt].dli_fname[0] != '\0')
	    {
	      if (info[cnt].dli_sname == NULL)
		/ * We found no symbol name to use, so describe it as
		   relative to the file.  * /
		info[cnt].dli_saddr = info[cnt].dli_fbase;

	      if (info[cnt].dli_sname == NULL && info[cnt].dli_saddr == 0)
		last += 1 + sprintf (last, "%s(%s) [%p]",
				     info[cnt].dli_fname ?: "",
				     info[cnt].dli_sname ?: "",
				     array[cnt]);
	      else
		{
		  char sign;
		  ptrdiff_t offset;
		  if (array[cnt] >= (void *) info[cnt].dli_saddr)
		    {
		      sign = '+';
		      offset = array[cnt] - info[cnt].dli_saddr;
		    }
		  else
		    {
		      sign = '-';
		      offset = info[cnt].dli_saddr - array[cnt];
		    }

		  last += 1 + sprintf (last, "%s(%s%c%#tx) [%p]",
				       info[cnt].dli_fname ?: "",
				       info[cnt].dli_sname ?: "",
				       sign, offset, array[cnt]);
		}
	    }
	  else
	    last += 1 + sprintf (last, "[%p]", array[cnt]);
	}
      assert (last <= (char *) result + size * sizeof (char *) + total);
    }

  return result;*/
}
//#include <math.h>
//#include <fenv.h>
//#include <fenv_private.h>
/*# define _FCLASS(x) (__extension__ ({ int __res; \
  if (sizeof (x) * 8 > __riscv_flen) __builtin_trap (); \
  if (sizeof (x) == 4) asm ("fclass.s %0, %1" : "=r" (__res) : "f" (x)); \
  else if (sizeof (x) == 8) asm ("fclass.d %0, %1" : "=r" (__res) : "f" (x)); \
  else __builtin_trap (); \
  __res; }))

# define _FCLASS_MINF     (1 << 0)
# define _FCLASS_MNORM    (1 << 1)
# define _FCLASS_MSUBNORM (1 << 2)
# define _FCLASS_MZERO    (1 << 3)
# define _FCLASS_PZERO    (1 << 4)
# define _FCLASS_PSUBNORM (1 << 5)
# define _FCLASS_PNORM    (1 << 6)
# define _FCLASS_PINF     (1 << 7)
# define _FCLASS_SNAN     (1 << 8)
# define _FCLASS_QNAN     (1 << 9)
# define _FCLASS_ZERO     (_FCLASS_MZERO | _FCLASS_PZERO)
# define _FCLASS_SUBNORM  (_FCLASS_MSUBNORM | _FCLASS_PSUBNORM)
# define _FCLASS_NORM     (_FCLASS_MNORM | _FCLASS_PNORM)
# define _FCLASS_INF      (_FCLASS_MINF | _FCLASS_PINF)
# define _FCLASS_NAN      (_FCLASS_SNAN | _FCLASS_QNAN)*/

int
__finite (double x)
{
  return 0;//_FCLASS (x) & ~(_FCLASS_INF | _FCLASS_NAN);
}
//hidden_def (__finite)
//weak_alias (__finite, finite)

int
__fprintf_chk (FILE *fp, int flag, const char *format, ...)
{
  /* For flag > 0 (i.e. __USE_FORTIFY_LEVEL > 1) request that %n
     can only come from read-only format strings.  */
//  unsigned int mode = (flag > 0) ? PRINTF_FORTIFY : 0;
  va_list ap;
  int ret;

  va_start (ap, format);
  ret = vfprintf (fp, format, ap);
  va_end (ap);

  return ret;
}

static void
__res_iclose (void * statp, bool free_addr)
{
  /*if (statp->_vcsock >= 0)
    {
      __close_nocancel_nostatus (statp->_vcsock);
      statp->_vcsock = -1;
      statp->_flags &= ~(RES_F_VC | RES_F_CONN);
    }
  for (int ns = 0; ns < statp->nscount; ns++)
    if (statp->_u._ext.nsaddrs[ns] != NULL)
      {
        if (statp->_u._ext.nssocks[ns] != -1)
          {
            __close_nocancel_nostatus (statp->_u._ext.nssocks[ns]);
            statp->_u._ext.nssocks[ns] = -1;
          }
        if (free_addr)
          {
            free (statp->_u._ext.nsaddrs[ns]);
            statp->_u._ext.nsaddrs[ns] = NULL;
          }
      }
  if (free_addr)
    __resolv_conf_detach (statp);*/
}

void
__res_nclose (void * statp)
{
  __res_iclose (statp, true);
}

static int
__res_vinit (void * statp, bool free_addr)
{
    return 0;
}
int
__res_ninit (void * statp)
{
  return __res_vinit (statp, 0);
}

char *
__strncat_chk (char *s1, const char *s2, size_t n, size_t s1len)
{
  return strncat(s1, s2, n);
  /*char c;
  char *s = s1;

  / * Find the end of S1.  * /
  do
    {
      if (__glibc_unlikely (s1len-- == 0))
	__chk_fail ();
      c = *s1++;
    }
  while (c != '\0');

  / * Make S1 point before next character, so we can increment
     it while memory is read (wins on pipelined cpus).  * /
  ++s1len;
  s1 -= 2;

  if (n >= 4)
    {
      size_t n4 = n >> 2;
      do
	{
	  if (__glibc_unlikely (s1len-- == 0))
	    __chk_fail ();
	  c = *s2++;
	  *++s1 = c;
	  if (c == '\0')
	    return s;
	  if (__glibc_unlikely (s1len-- == 0))
	    __chk_fail ();
	  c = *s2++;
	  *++s1 = c;
	  if (c == '\0')
	    return s;
	  if (__glibc_unlikely (s1len-- == 0))
	    __chk_fail ();
	  c = *s2++;
	  *++s1 = c;
	  if (c == '\0')
	    return s;
	  if (__glibc_unlikely (s1len-- == 0))
	    __chk_fail ();
	  c = *s2++;
	  *++s1 = c;
	  if (c == '\0')
	    return s;
	} while (--n4 > 0);
      n &= 3;
    }

  while (n > 0)
    {
      if (__glibc_unlikely (s1len-- == 0))
	__chk_fail ();
      c = *s2++;
      *++s1 = c;
      if (c == '\0')
	return s;
      n--;
    }

  if (c != '\0')
    {
      if (__glibc_unlikely (s1len-- == 0))
	__chk_fail ();
      *++s1 = '\0';
    }

  return s;
  */
}
