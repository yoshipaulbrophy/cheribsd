#	from: @(#)Makefile	5.11 (Berkeley) 5/21/91
# $FreeBSD$

.include <src.opts.mk>

FILESGROUPS=	FILES

# No need as it is empty and just causes rebuilds since this file does so much.
UPDATE_DEPENDFILE=	no

.if ${MK_SENDMAIL} != "no"
SUBDIR+=sendmail
.endif

BIN1=	crontab \
	devd.conf \
	devfs.conf \
	ddb.conf \
	dhclient.conf \
	disktab \
	fbtab \
	gettytab \
	group \
	hosts \
	hosts.allow \
	hosts.equiv \
	libalias.conf \
	libmap.conf \
	login.access \
	login.conf \
	mac.conf \
	motd \
	netconfig \
	network.subr \
	networks \
	newsyslog.conf \
	nsswitch.conf \
	phones \
	profile \
	protocols \
	rc \
	rc.bsdextended \
	rc.firewall \
	rc.initdiskless \
	rc.shutdown \
	rc.subr \
	remote \
	rpc \
	services \
	shells \
	sysctl.conf \
	syslog.conf \
	termcap.small

.if exists(${.CURDIR}/etc.${MACHINE}/ttys)
BIN1+=	etc.${MACHINE}/ttys
.elif exists(${.CURDIR}/etc.${MACHINE_ARCH}/ttys)
BIN1+=	etc.${MACHINE_ARCH}/ttys
.elif exists(${.CURDIR}/etc.${MACHINE_CPUARCH}/ttys)
BIN1+=	etc.${MACHINE_CPUARCH}/ttys
.else
.error etc.MACHINE/ttys missing
.endif

OPENBSMDIR=			${SRCTOP}/contrib/openbsm
BSM_ETC_OPEN_FILES=		${OPENBSMDIR}/etc/audit_class \
				${OPENBSMDIR}/etc/audit_event
BSM_ETC_RESTRICTED_FILES=	${OPENBSMDIR}/etc/audit_control \
				${OPENBSMDIR}/etc/audit_user
BSM_ETC_EXEC_FILES=		${OPENBSMDIR}/etc/audit_warn
BSM_ETC_DIR=			${DESTDIR}/etc/security

# NB: keep these sorted by MK_* knobs

.if ${MK_AMD} != "no"
BIN1+= amd.map
.endif

.if ${MK_APM} != "no"
BIN1+= apmd.conf
.endif

.if ${MK_AUTOFS} != "no"
BIN1+=	auto_master
.endif

.if ${MK_BLACKLIST} != "no"
BIN1+= blacklistd.conf
.endif

.if ${MK_FREEBSD_UPDATE} != "no"
BIN1+= freebsd-update.conf
.endif

.if ${MK_FTP} != "no"
BIN1+= ftpusers
.endif

.if ${MK_INETD} != "no"
BIN1+= inetd.conf
.endif

.if ${MK_LOCATE} != "no"
BIN1+=	${SRCTOP}/usr.bin/locate/locate/locate.rc
.endif

.if ${MK_LPR} != "no"
BIN1+=	hosts.lpd printcap
.endif

.if ${MK_MAIL} != "no"
BIN1+=	${SRCTOP}/usr.bin/mail/misc/mail.rc
.endif

.if ${MK_NTP} != "no"
BIN1+=	ntp.conf
.endif

.if ${MK_OPENSSH} != "no"
SSH=	${SRCTOP}/crypto/openssh/ssh_config \
	${SRCTOP}/crypto/openssh/sshd_config \
	${SRCTOP}/crypto/openssh/moduli
.endif
.if ${MK_OPENSSL} != "no"
SSL=	${SRCTOP}/crypto/openssl/apps/openssl.cnf
.endif

.if ${MK_NS_CACHING} != "no"
BIN1+= nscd.conf
.endif

.if ${MK_PORTSNAP} != "no"
BIN1+= portsnap.conf
.endif

.if ${MK_PF} != "no"
BIN1+= pf.os
.endif

.if ${MK_SENDMAIL} != "no"
BIN1+=	rc.sendmail
.endif

.if ${MK_TCSH} != "no"
BIN1+= csh.cshrc csh.login csh.logout
.endif

.if ${MK_WIRELESS} != "no"
BIN1+= regdomain.xml
.endif

# -rwxr-xr-x root:wheel, for the new cron root:wheel
BIN2=	netstart pccard_ether rc.suspend rc.resume

MTREE=	BSD.debug.dist BSD.include.dist BSD.root.dist BSD.usr.dist BSD.var.dist
.if ${MK_CHERI} != "no"
MTREE+=	BSD.libcheri.dist
.endif
.if ${MK_LIB32} != "no"
MTREE+=	BSD.lib32.dist
.endif
.if ${MK_LIBSOFT} != "no"
MTREE+=	BSD.libsoft.dist
.endif
.if ${MK_TESTS} != "no"
MTREE+=	BSD.tests.dist
.endif
.if ${MK_SENDMAIL} != "no"
MTREE+=	BSD.sendmail.dist
.endif

PPPCNF=	ppp.conf

.if ${MK_SENDMAIL} == "no"
ETCMAIL=mailer.conf aliases
.else
ETCMAIL=Makefile README mailer.conf access.sample virtusertable.sample \
	mailertable.sample aliases
.endif

# Special top level files for FreeBSD
FREEBSD=COPYRIGHT

# Sanitize DESTDIR
DESTDIR:=	${DESTDIR:C://*:/:g}

afterinstall:
.if ${MK_MAN} != "no"
	${_+_}cd ${SRCTOP}/share/man; ${MAKE} makedb
.endif

distribute:
	# Avoid installing tests here; "make distribution" will do this and
	# correctly place them in the right location.
	${_+_}cd ${.CURDIR} ; ${MAKE} MK_TESTS=no install \
	    DESTDIR=${DISTDIR}/${DISTRIBUTION}
	${_+_}cd ${.CURDIR} ; ${MAKE} distribution DESTDIR=${DISTDIR}/${DISTRIBUTION}

.include <bsd.endian.mk>
.if ${TARGET_ENDIANNESS} == "1234"
CAP_MKDB_ENDIAN?= -l
.elif ${TARGET_ENDIANNESS} == "4321"
CAP_MKDB_ENDIAN?= -b
.else
CAP_MKDB_ENDIAN?=
.endif

.if defined(NO_ROOT)
METALOG.add?=	cat -l >> ${METALOG}
.endif

distribution:
.if !defined(DESTDIR)
	@echo "set DESTDIR before running \"make ${.TARGET}\""
	@false
.endif
	cd ${.CURDIR}; \
	    ${INSTALL} -o ${BINOWN} -g ${BINGRP} -m 644 \
		${BIN1} ${DESTDIR}/etc; \
	    cap_mkdb ${CAP_MKDB_ENDIAN} ${DESTDIR}/etc/login.conf; \
	    services_mkdb ${CAP_MKDB_ENDIAN} -q -o ${DESTDIR}/var/db/services.db \
		${DESTDIR}/etc/services; \
	    ${INSTALL} -o ${BINOWN} -g ${BINGRP} -m 755 \
		${BIN2} ${DESTDIR}/etc; \
	    ${INSTALL} -o ${BINOWN} -g ${BINGRP} -m 600 \
		master.passwd nsmb.conf opieaccess ${DESTDIR}/etc;
.if ${MK_BSNMP} != "no"
	cd ${.CURDIR}; \
	    ${INSTALL} -o ${BINOWN} -g ${BINGRP} -m 600 \
		snmpd.config ${DESTDIR}/etc;
.endif
.if ${MK_AT} == "no"
	sed -i "" -e 's;.*/usr/libexec/atrun;#&;' ${DESTDIR}/etc/crontab
.endif
.if ${MK_TCSH} == "no"
	sed -i "" -e 's;/bin/csh;/bin/sh;' ${DESTDIR}/etc/master.passwd
.endif
	pwd_mkdb -i -p -d ${DESTDIR}/etc ${DESTDIR}/etc/master.passwd
.if defined(NO_ROOT)
	( \
		echo "./etc/login.conf.db type=file mode=0644 uname=root gname=wheel"; \
		echo "./etc/passwd type=file mode=0644 uname=root gname=wheel"; \
		echo "./etc/pwd.db type=file mode=0644 uname=root gname=wheel"; \
		echo "./etc/spwd.db type=file mode=0600 uname=root gname=wheel"; \
	) | ${METALOG.add}
.endif
.if ${MK_AUTOFS} != "no"
	${_+_}cd ${.CURDIR}/autofs; ${MAKE} install
.endif
.if ${MK_BLUETOOTH} != "no"
	${_+_}cd ${.CURDIR}/bluetooth; ${MAKE} install
.endif
.if ${MK_CASPER} != "no"
	${_+_}cd ${.CURDIR}/casper; ${MAKE} install
.endif
	${_+_}cd ${.CURDIR}/cron.d; ${MAKE} install
	${_+_}cd ${.CURDIR}/defaults; ${MAKE} install
	${_+_}cd ${.CURDIR}/devd; ${MAKE} install
	${_+_}cd ${.CURDIR}/gss; ${MAKE} install
	${_+_}cd ${.CURDIR}/newsyslog.conf.d; ${MAKE} install
.if ${MK_NTP} != "no"
	${_+_}cd ${.CURDIR}/ntp; ${MAKE} install
.endif
	${_+_}cd ${.CURDIR}/periodic; ${MAKE} install
.if ${MK_PKGBOOTSTRAP} != "no"
	${_+_}cd ${.CURDIR}/pkg; ${MAKE} install
.endif
	${_+_}cd ${.CURDIR}/rc.d; ${MAKE} install
	${_+_}cd ${SRCTOP}/share/termcap; ${MAKE} etc-termcap
	${_+_}cd ${.CURDIR}/syslog.d; ${MAKE} install
	${_+_}cd ${SRCTOP}/usr.sbin/rmt; ${MAKE} etc-rmt
	${_+_}cd ${.CURDIR}/pam.d; ${MAKE} install
	cd ${.CURDIR}; ${INSTALL} -o ${BINOWN} -g ${BINGRP} -m 0444 \
	    ${BSM_ETC_OPEN_FILES} ${BSM_ETC_DIR}
	cd ${.CURDIR}; ${INSTALL} -o ${BINOWN} -g ${BINGRP} -m 0600 \
	    ${BSM_ETC_RESTRICTED_FILES} ${BSM_ETC_DIR}
	cd ${.CURDIR}; ${INSTALL} -o ${BINOWN} -g ${BINGRP} -m 0500 \
	    ${BSM_ETC_EXEC_FILES} ${BSM_ETC_DIR}
.if ${MK_UNBOUND} != "no"
	if [ ! -e ${DESTDIR}/etc/unbound ]; then \
		${INSTALL_SYMLINK} ../var/unbound ${DESTDIR}/etc/unbound; \
	fi
.endif
.if ${MK_SENDMAIL} != "no"
	${_+_}cd ${.CURDIR}/sendmail; ${MAKE} distribution
.endif
.if ${MK_OPENSSH} != "no"
	cd ${.CURDIR}; ${INSTALL} -o ${BINOWN} -g ${BINGRP} -m 644 \
	    ${SSH} ${DESTDIR}/etc/ssh
.endif
.if ${MK_OPENSSL} != "no"
	cd ${.CURDIR}; ${INSTALL} -o ${BINOWN} -g ${BINGRP} -m 644 \
	    ${SSL} ${DESTDIR}/etc/ssl
.endif
.if ${MK_KERBEROS} != "no"
	cd ${.CURDIR}/root; \
	    ${INSTALL} -o ${BINOWN} -g ${BINGRP} -m 644 \
		dot.k5login ${DESTDIR}/root/.k5login;
.endif
	cd ${.CURDIR}/root; \
	    ${INSTALL} -o ${BINOWN} -g ${BINGRP} -m 644 \
		dot.profile ${DESTDIR}/root/.profile; \
	    rm -f ${DESTDIR}/.profile; \
	    ln ${DESTDIR}/root/.profile ${DESTDIR}/.profile
.if ${MK_TCSH} != "no"
	cd ${.CURDIR}/root; \
	    ${INSTALL} -o ${BINOWN} -g ${BINGRP} -m 644 \
		dot.cshrc ${DESTDIR}/root/.cshrc; \
	    ${INSTALL} -o ${BINOWN} -g ${BINGRP} -m 644 \
		dot.login ${DESTDIR}/root/.login; \
	    rm -f ${DESTDIR}/.cshrc; \
	    ln ${DESTDIR}/root/.cshrc ${DESTDIR}/.cshrc
.endif
	cd ${.CURDIR}/mtree; ${INSTALL} -o ${BINOWN} -g ${BINGRP} -m 444 \
	    ${MTREE} ${DESTDIR}/etc/mtree
.if ${MK_MAIL} != "no"
	cd ${.CURDIR}/mail; ${INSTALL} -o ${BINOWN} -g ${BINGRP} -m 644 \
	    ${ETCMAIL} ${DESTDIR}/etc/mail
	if [ -d ${DESTDIR}/etc/mail -a -f ${DESTDIR}/etc/mail/aliases -a \
	      ! -f ${DESTDIR}/etc/aliases ]; then \
		ln -s mail/aliases ${DESTDIR}/etc/aliases; \
	fi
.endif
	${INSTALL} -o ${BINOWN} -g operator -m 664 /dev/null \
	    ${DESTDIR}/etc/dumpdates
.if ${MK_LOCATE} != "no"
	${INSTALL} -o nobody -g ${BINGRP} -m 644 /dev/null \
	    ${DESTDIR}/var/db/locate.database
.endif
	${INSTALL} -o ${BINOWN} -g ${BINGRP} -m 644 ${.CURDIR}/minfree \
	    ${DESTDIR}/var/crash
	cd ${.CURDIR}/..; ${INSTALL} -o ${BINOWN} -g ${BINGRP} -m 444 \
		${FREEBSD} ${DESTDIR}/
.if ${MK_BOOT} != "no"
.if exists(${SRCTOP}/sys/${MACHINE}/conf/GENERIC.hints)
	${INSTALL} -o ${BINOWN} -g ${BINGRP} -m 444 \
	    ${SRCTOP}/sys/${MACHINE}/conf/GENERIC.hints \
	    ${DESTDIR}/boot/device.hints
.endif
.endif
.if ${MK_NIS} == "no"
	sed -i "" -e 's/.*_compat:/# &/' -e 's/compat$$/files/' \
		${DESTDIR}/etc/nsswitch.conf
.endif

MTREE_CMD?=	mtree

.if ${MK_INSTALL_AS_USER} == "yes" && ${_uid} != 0
MTREE_FILTER= sed -e 's,\([gu]\)name=,\1id=,g' \
	-e 's,\(uid=\)[^ ]* ,\1${_uid} ,' \
	-e 's,\(gid=\)[^ ]* ,\1${_gid} ,' \
	-e 's,\(uid=\)[^ ]*$$,\1${_uid},' \
	-e 's,\(gid=\)[^ ]*$$,\1${_gid},' 
.else
MTREE_FILTER= cat
.if !defined(NO_FSCHG)
MTREE_FSCHG=	-i
.endif
.endif

MTREES=		mtree/BSD.root.dist		/		\
		mtree/BSD.var.dist		/var		\
		mtree/BSD.usr.dist		/usr		\
		mtree/BSD.include.dist		/usr/include	\
		mtree/BSD.debug.dist		/usr/lib
.if ${MK_CHERI} != "no"
MTREES+=	mtree/BSD.libcheri.dist		/usr
MTREES+=	mtree/BSD.libcheri.dist		/usr/lib/debug/usr
.endif
.if ${MK_GROFF} != "no"
MTREES+=	mtree/BSD.groff.dist		/usr
.endif
.if ${MK_LIB32} != "no"
MTREES+=	mtree/BSD.lib32.dist		/usr
MTREES+=	mtree/BSD.lib32.dist		/usr/lib/debug/usr
.endif
.if ${MK_LIBSOFT} != "no"
MTREES+=	mtree/BSD.libsoft.dist		/usr
MTREES+=	mtree/BSD.libsoft.dist		/usr/lib/debug/usr
.endif
.if ${MK_TESTS} != "no"
MTREES+=	mtree/BSD.tests.dist		${TESTSBASE}
MTREES+=	mtree/BSD.tests.dist		/usr/lib/debug/${TESTSBASE}
.if ${MK_CHERI} != "no"
MTREES+=	mtree/BSD.tests.dist		${TESTSBASE}/cheri
MTREES+=	mtree/BSD.tests.dist		/usr/lib/debug/${TESTSBASE}/cheri
.endif
.endif
.if ${MK_SENDMAIL} != "no"
MTREES+=	mtree/BSD.sendmail.dist		/
.endif
.for mtree in ${LOCAL_MTREE}
MTREES+=	../${mtree}			/
.endfor

# Clean up some directories that where mistakenly created as files that
# should not have been as part of the nvi update in r281994.
# This should be removed after 11.0-RELEASE.
DISTRIB_CLEANUP_SHARE_FILES=	${SHAREDIR}/doc/usd/10.exref ${SHAREDIR}/doc/usd/11.edit
DISTRIB_CLEANUP_SHARE_FILES+=	${SHAREDIR}/doc/usd/12.vi ${SHAREDIR}/doc/usd/13.viref
distrib-cleanup: .PHONY
	for file in ${DISTRIB_CLEANUP_SHARE_FILES}; do \
		if [ -f ${DESTDIR}/$${file} ]; then \
			rm -f ${DESTDIR}/$${file}; \
		fi; \
	done

distrib-dirs: ${MTREES:N/*} distrib-cleanup .PHONY
	@set ${MTREES}; \
	while test $$# -ge 2; do \
		m=${.CURDIR}/$$1; \
		shift; \
		d=${DESTDIR}$$1; \
		shift; \
		test -d $$d || mkdir -p $$d; \
		${ECHO} ${MTREE_CMD} -deU ${MTREE_FSCHG} \
		    ${MTREE_FOLLOWS_SYMLINKS} -f $$m -p $$d; \
		${MTREE_FILTER} $$m | \
		${MTREE_CMD} -deU ${MTREE_FSCHG} ${MTREE_FOLLOWS_SYMLINKS} \
		    -p $$d; \
	done; true
.if defined(NO_ROOT)
	@set ${MTREES}; \
	while test $$# -ge 2; do \
		m=${.CURDIR}/$$1; \
		shift; \
		d=$$1; \
		test "$$d" == "/" && d=""; \
		d=${DISTBASE}$$d; \
		shift; \
		test -d ${DESTDIR}/$$d || mkdir -p ${DESTDIR}/$$d; \
		${ECHO} "${MTREE_CMD:N-W} -C -f $$m -K uname,gname | " \
		    "sed s#^\.#.$$d# | ${METALOG.add}" ; \
		${MTREE_FILTER} $$m | \
		${MTREE_CMD:N-W} -C -K uname,gname | sed s#^\.#.$$d# | \
		    ${METALOG.add} ; \
	done; true
.endif
	${INSTALL_SYMLINK} usr/src/sys ${DESTDIR}/sys
.if ${MK_MAN} != "no"
	cd ${DESTDIR}${SHAREDIR}/man; \
	for mandir in man*; do \
		${INSTALL_SYMLINK} ../$$mandir \
		    ${DESTDIR}${SHAREDIR}/man/en.ISO8859-1/; \
		${INSTALL_SYMLINK} ../$$mandir \
		    ${DESTDIR}${SHAREDIR}/man/en.UTF-8/; \
	done
.if ${MK_OPENSSL} != "no"
	cd ${DESTDIR}${SHAREDIR}/openssl/man; \
	for mandir in man*; do \
		${INSTALL_SYMLINK} ../$$mandir \
		    ${DESTDIR}${SHAREDIR}/openssl/man/en.ISO8859-1/; \
	done
.endif
	set - `grep "^[a-zA-Z]" ${.CURDIR}/man.alias`; \
	while [ $$# -gt 0 ] ; do \
		${INSTALL_SYMLINK} "$$2" "${DESTDIR}${SHAREDIR}/man/$$1"; \
		if [ "${MK_OPENSSL}" != "no" ]; then \
			${INSTALL_SYMLINK} "$$2" \
			    "${DESTDIR}${SHAREDIR}/openssl/man/$$1"; \
		fi; \
		shift; shift; \
	done
.endif
.if ${MK_NLS} != "no"
	set - `grep "^[a-zA-Z]" ${.CURDIR}/nls.alias`; \
	while [ $$# -gt 0 ] ; do \
		${INSTALL_SYMLINK} "$$2" "${DESTDIR}${SHAREDIR}/nls/$$1"; \
		shift; shift; \
	done
.endif

etc-examples-install: ${META_DEPS}
	cd ${.CURDIR}; ${INSTALL} ${TAG_ARGS} -o ${BINOWN} -g ${BINGRP} -m 444 \
	    ${BIN1} ${BIN2} nsmb.conf opieaccess \
	    ${DESTDIR}${SHAREDIR}/examples/etc

etc-examples: etc-examples-install
	${_+_}cd ${.CURDIR}/defaults; \
	    ${MAKE} ${${MK_STAGING} == "yes":?all:install} \
	    DESTDIR=${DESTDIR}${SHAREDIR}/examples

.include <bsd.prog.mk>
