# $FreeBSD$

.include <src.opts.mk>

.if ${MK_CXX} != "no"
SUBDIR.${MK_GCC}+=	gperf
.endif

SUBDIR.${MK_BINUTILS}+=	binutils
SUBDIR.${MK_DIALOG}+=	dialog
SUBDIR.${MK_GCC}+=	cc
SUBDIR.${MK_GNU_DIFF}+=	diff3
SUBDIR.${MK_GNU_GREP}+=	grep
SUBDIR.${MK_GPL_DTC}+=	dtc
SUBDIR.${MK_GROFF}+=	groff
SUBDIR.${MK_TESTS}+=	tests

SUBDIR_PARALLEL=

.include <bsd.subdir.mk>
