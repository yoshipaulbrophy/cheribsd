/*	$NetBSD: rtld_start.S,v 1.10 2009/12/14 00:41:19 matt Exp $	*/

/*
 * Copyright 1997 Michael L. Hitch <mhitch@montana.edu>
 * Portions copyright 2002 Charles M. Hannum <root@ihack.net>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * $FreeBSD$
 */

#include <machine/asm.h>
#include <machine/cherireg.h>

.globl _C_LABEL(_rtld_relocate_nonplt_self)
.globl _C_LABEL(_rtld)

#define	PTR_SIZE	32

/*
 *      c3      cheriabi_execdata pointer
 */
LEAF(rtld_start)
	/*
	 * XXX: Assume the kernel aligned the stack correctly.
	 */
	/*
	 * NB: Use 32 to retain stack alignment
	 *
	 * XXX-BD: this is all zeros...
	 */
	daddiu		sp, sp, -32
	csd		gp, sp, 0($c11)
	csd		s8, sp, 8($c11)
	csd		ra, sp, 16($c11)
			/* 24($c11) relocbase */

	daddiu		sp, sp, -4*CHERICAP_SIZE
			/* 0*CHERICAP_SIZE($c11) atexit */
			/* 1*CHERICAP_SIZE($c11) obj_main */
	csc		$c3, sp, 2*CHERICAP_SIZE($c11)
	csc		$c17, sp, 3*CHERICAP_SIZE($c11)

	SETUP_GP64(s4, rtld_start)

	move		s8, sp

	dla		a0, 1f
1:	cgetpcc		$c12
	cgetoffset	a1, $c12
	dsubu		a1, a1, a0
	csd		a1, sp, 24($c11)
	cgetdefault	$c4
	csetoffset	$c4, $c4, a1	/* relocbase */

	dla		a0, _DYNAMIC
	cincoffset	$c3, $c4, a0	/* dynp */

	/* XXX: Assume PCC and DDC share an offset. */
	csetoffset	$c12, $c12, a1
	dla		t0, _C_LABEL(_rtld_relocate_nonplt_self)
	cincoffset	$c12, $c12, t0
	cjalr		$c12, $c17
	nop

	clc		$c3, sp, 2*CHERICAP_SIZE($c11)	/* execdata */
	/* XXX-BD: Should allocate cleanup and objp outside stack. */
	dla		t1, CHERICAP_SIZE
	daddi		t0, sp, 0*CHERICAP_SIZE
	csetoffset	$c4, $c11, t0			/* &cleanup */
	csetbounds	$c4, $c4, t1
	daddi		t0, sp, 1*CHERICAP_SIZE
	csetoffset	$c5, $c11, t0			/* &objp */
	csetbounds	$c5, $c5, t1
	cld		t0, sp, 24($c11)	/* relocbase */
	dla		t9, _C_LABEL(_rtld)
	daddu		t0, t0, t9
	cgetpcc		$c12
	csetoffset	$c12, $c12, t0
	cjalr		$c12, $c17	/* v0 = _rtld(execdata, cleanup, objp) */
	nop

	cmove		$c12, $c3
	clc		$c3, sp, 2*CHERICAP_SIZE($c11)	/* execdata */
	clc		$c4, sp, 0*CHERICAP_SIZE($c11)	/* cleanup */
	clc		$c5, sp, 1*CHERICAP_SIZE($c11)	/* objp */

	cmove		$c17, $c12 /* return == PCC signals backtrace routine to stop */
	cjr		$c12
	nop
END(rtld_start)

#define	XCALLFRAME_CAPSIZ	(9*CHERICAP_SIZE)
#define	XCALLFRAME_SIZ		(12*SZREG + XCALLFRAME_CAPSIZ)
#define	XCALLFRAME_RA		(10*SZREG + XCALLFRAME_CAPSIZ)
#define	XCALLFRAME_GP		(9*SZREG + XCALLFRAME_CAPSIZ)
#define	XCALLFRAME_S0		(8*SZREG + XCALLFRAME_CAPSIZ)
#define	XCALLFRAME_A3		(7*SZREG + XCALLFRAME_CAPSIZ)
#define	XCALLFRAME_A2		(6*SZREG + XCALLFRAME_CAPSIZ)
#define	XCALLFRAME_A1		(5*SZREG + XCALLFRAME_CAPSIZ)
#define	XCALLFRAME_A0		(4*SZREG + XCALLFRAME_CAPSIZ)
#define	XCALLFRAME_A7		(3*SZREG + XCALLFRAME_CAPSIZ)
#define	XCALLFRAME_A6		(2*SZREG + XCALLFRAME_CAPSIZ)
#define	XCALLFRAME_A5		(1*SZREG + XCALLFRAME_CAPSIZ)
#define	XCALLFRAME_A4		(0*SZREG + XCALLFRAME_CAPSIZ)
#define	XCALLFRAME_C3		(8*CHERICAP_SIZE)
#define	XCALLFRAME_C4		(7*CHERICAP_SIZE)
#define	XCALLFRAME_C5		(6*CHERICAP_SIZE)
#define	XCALLFRAME_C6		(5*CHERICAP_SIZE)
#define	XCALLFRAME_C7		(4*CHERICAP_SIZE)
#define	XCALLFRAME_C8		(3*CHERICAP_SIZE)
#define	XCALLFRAME_C9		(2*CHERICAP_SIZE)
#define	XCALLFRAME_C10		(1*CHERICAP_SIZE)
#define	XCALLFRAME_C17		(0*CHERICAP_SIZE)

	.globl	_rtld_bind_start
	.ent	_rtld_bind_start
_rtld_bind_start:
	.frame	sp, XCALLFRAME_SIZ, $15
	move	v1, gp			/* save old GP */
	PTR_SUBU sp, XCALLFRAME_SIZ	/* save arguments and sp value in stack */
	//SETUP_GP64(XCALLFRAME_GP, _rtld_bind_start)
	csd	gp,  sp, XCALLFRAME_GP($c11)
	csd	a0,  sp, XCALLFRAME_A0($c11)
	csd	a1,  sp, XCALLFRAME_A1($c11)
	csd	a2,  sp, XCALLFRAME_A2($c11)
	csd	a3,  sp, XCALLFRAME_A3($c11)
	csd	a4,  sp, XCALLFRAME_A4($c11)
	csd	a5,  sp, XCALLFRAME_A5($c11)
	csd	a6,  sp, XCALLFRAME_A6($c11)
	csd	a7,  sp, XCALLFRAME_A7($c11)
	csd	$15, sp, XCALLFRAME_RA($c11)	/* ra is in t7/t3 */
	csd	s0,  sp, XCALLFRAME_S0($c11)
	/* XXX-BD: What about ccall functions?  Do we need v0, c1, c2? */
	csc	$c3, sp, XCALLFRAME_C3($c11)
	csc	$c4, sp, XCALLFRAME_C4($c11)
	csc	$c5, sp, XCALLFRAME_C5($c11)
	csc	$c6, sp, XCALLFRAME_C6($c11)
	csc	$c7, sp, XCALLFRAME_C7($c11)
	csc	$c8, sp, XCALLFRAME_C8($c11)
	csc	$c9, sp, XCALLFRAME_C9($c11)
	csc	$c10, sp, XCALLFRAME_C10($c11)
	csc	$c17, sp, XCALLFRAME_C17($c11)
	move	s0, sp

	move	a0, v1			/* old GP */
	PTR_SUBU	a0, a0, 0x7ff0	/* The offset of $gp from the	*/
       					/* beginning of the .got section: */
					/* $gp = .got + 0x7ff0, so	*/
					/* .got = $gp - 0x7ff0		*/
					/* Simple math as you can see.	*/
	ld	a0, 8(a0)	/* object = pltgot[1] */
	dli	t9, 0x7fffffffffffffff;
	and	a0, a0, t9
	cgetdefault	$c3
	csetoffset	$c3, $c3, a0
	move	a0, t8			/* symbol index */

	/* XXX-BD: hacky PIC call */
	dla		t0, 1f
1:	cgetpcc		$c12
	cgetoffset	t1, $c12
	dsub		t0, t1, t0
	csetoffset	$c12, $c12, t0
	dla		t9, _C_LABEL(_mips_rtld_bind)
	cincoffset	$c12, $c12, t9
	cjalr	$c12, $c17
	nop
	cgetpccsetoffset $c12, v0

	move	sp, s0
	clc	$c17, sp, XCALLFRAME_C17($c11)
	clc	$c10, sp, XCALLFRAME_C10($c11)
	clc	$c9, sp, XCALLFRAME_C9($c11)
	clc	$c8, sp, XCALLFRAME_C8($c11)
	clc	$c7, sp, XCALLFRAME_C7($c11)
	clc	$c6, sp, XCALLFRAME_C6($c11)
	clc	$c5, sp, XCALLFRAME_C5($c11)
	clc	$c4, sp, XCALLFRAME_C4($c11)
	clc	$c3, sp, XCALLFRAME_C3($c11)
	cld	ra, sp, XCALLFRAME_RA($c11)
	cld	s0, sp, XCALLFRAME_S0($c11)
	cld	a0, sp, XCALLFRAME_A0($c11)
	cld	a1, sp, XCALLFRAME_A1($c11)
	cld	a2, sp, XCALLFRAME_A2($c11)
	cld	a3, sp, XCALLFRAME_A3($c11)
	cld	a4, sp, XCALLFRAME_A4($c11)
	cld	a5, sp, XCALLFRAME_A5($c11)
	cld	a6, sp, XCALLFRAME_A6($c11)
	cld	a7, sp, XCALLFRAME_A7($c11)
	cld	gp, sp, XCALLFRAME_GP($c11)
	//RESTORE_GP64
	PTR_ADDU sp, XCALLFRAME_SIZ
	cjr	$c12
	nop
END(_rtld_bind_start)
