;;
;; Copyright (C) 2009-2016, Intel Corporation
;; All rights reserved.
;; 
;; Redistribution and use in source and binary forms, with or without
;; modification, are permitted provided that the following conditions
;; are met:
;; 
;;   * Redistributions of source code must retain the above copyright
;;     notice, this list of conditions and the following disclaimer.
;;   * Redistributions in binary form must reproduce the above copyright
;;     notice, this list of conditions and the following disclaimer in
;;     the documentation and/or other materials provided with the
;;     distribution.
;;   * Neither the name of Intel Corporation nor the names of its
;;     contributors may be used to endorse or promote products derived
;;     from this software without specific prior written permission.
;; 
;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
;; "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
;; LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
;; A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
;; HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
;; INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
;; BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
;; OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
;; AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
;; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
;; WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
;; POSSIBILITY OF SUCH DAMAGE.
;; 
;; *********************************************************************
;; 
;; PLEASE NOTE: This file is a downstream copy of a file mainitained in
;; a repository at cilkplus.org. Changes made to this file that are not
;; submitted through the contribution process detailed at
;; http://www.cilkplus.org/submit-cilk-contribution will be lost the next
;; time that a new version is released. Changes only submitted to the
;; GNU compiler collection or posted to the git repository at
;; https://bitbucket.org/intelcilkruntime/itnel-cilk-runtime.git are
;; not tracked.
;; 
;; We welcome your contributions to this open source project. Thank you
;; for your assistance in helping us improve Cilk Plus.
;;
;;*****************************************************************************
;;
;; win64-asm.asm
;;
;; This module contains functions that cannot be implemented in C
;; using the Win64 compiler
;;
;; NOTE: If you're getting errors building this file, you may need to do
;; the following:
;;
;; If you're working on a 32-bit OS, go to the
;; "C:\Program Files\Microsoft Visual Studio 8\VC\bin\x86_amd64"
;; directory and copy ml64.exe to ml.exe.
;;
;; If you're working on a 64-bit OS, go to the
;; "C:\Program Files (x86)\Microsoft Visual Studio 8\VC\bin\amd64"
;; directory and copy ml64.exe to ml.exe.
;;
;; Why is this necessary?  Because the ml.rules can't allow for the
;; differing path names.  This was the easiest modification.  Supposedly
;; this is fixed in VS2010.  If you're building with a Makefile, use
;; ml64.exe instead of ml.exe.

;; Allow names with leading dots (like .CILKMTDT)
OPTION DOTNAME

.CODE

;; void longjmp_and_rethrow(__cilkrts_stack_frame *sf,    // RCX
;;                          jmp_buf _Buf                         // RDX

__cilkrts_longjmp_and_rethrow PROC FRAME

    push        rbp         ;; Save the previous frame pointer
    .pushreg rbp

    sub         rsp,20h     ;; Reserve space for 4 output parameters
    .allocstack 20h

    lea         rbp,[rsp]   ;; Set up the new frame pointer
    .setframe rbp, 0

    .endprolog

    ;; Start by loading the context from the jmp_buf.  This is copied from the
    ;; debugger's disassembly of longjmp.  We don't need to worry about frame
    ;; being set, since we don't want to do another unwind (it should have been
    ;; done earlier) and we don't need to let anybody set the return value

    mov         rbx,qword ptr [rdx+8]
    mov         rsi,qword ptr [rdx+20h] 
    mov         rdi,qword ptr [rdx+28h] 
    mov         r12,qword ptr [rdx+30h] 
    mov         r13,qword ptr [rdx+38h] 
    mov         r14,qword ptr [rdx+40h] 
    mov         r15,qword ptr [rdx+48h] 
    ldmxcsr     dword ptr [rdx+58h] 
    fnclex           
    fldcw       word ptr [rdx+5Ch] 
    movdqa      xmm6, xmmword ptr [rdx+0060h] 
    movdqa      xmm7, xmmword ptr [rdx+0070h] 
    movdqa      xmm8, xmmword ptr [rdx+0080h] 
    movdqa      xmm9, xmmword ptr [rdx+0090h] 
    movdqa      xmm10,xmmword ptr [rdx+00A0h] 
    movdqa      xmm11,xmmword ptr [rdx+00B0h] 
    movdqa      xmm12,xmmword ptr [rdx+00C0h] 
    movdqa      xmm13,xmmword ptr [rdx+00D0h] 
    movdqa      xmm14,xmmword ptr [rdx+00E0h] 
    movdqa      xmm15,xmmword ptr [rdx+00F0h] 
    mov         rbp,qword ptr [rdx+18h] 

    ;; Call __cilkrts_rethrow to actually raise the exception.  It will patch
    ;; the correct return address onto the stack so the unwinder will never
    ;; see this function.
    ;;
    ;; Note that pointer to the __cilkrts_stack_frame is already in RCX

    call __cilkrts_rethrow

    ;; Should never return!

    lea rsp,[rbp]
    add rsp,20h
    pop rbp
    ret

__cilkrts_longjmp_and_rethrow ENDP


;;; Moved to os-win.c
;; ;; void __cilkrts_fence(void)
;; ;;
;; ;; Executes an MFENCE instruction to serialize all load and store
;; ;; instructions that were issued prior the MFENCE instruction. This
;; ;; serializing operation guarantees that every load and store instruction
;; ;; that precedes the MFENCE instruction is globally visible before any load
;; ;; or store instruction that follows the MFENCE instruction. The MFENCE
;; ;; instruction is ordered with respect to all load and store instructions,
;; ;; other MFENCE instructions, any SFENCE and LFENCE instructions, and any
;; ;; serializing instructions (such as the CPUID instruction).

;; __cilkrts_fence PROC
;;     mfence
;;     ret 0
;; __cilkrts_fence ENDP

;;; Moved to os-win.c
;; ;; void __cilkrts_short_pause(void)
;; ;; 
;; ;; Executes a PAUSE instruction which is a hint to the processor that the
;; ;; code sequence is a spin-wait loop. The processor uses this hint to avoid
;; ;; the memory order violation in most situations, which greatly improves
;; ;; processor performance.

;; __cilkrts_short_pause PROC
;;     pause
;;     ret 0
;; __cilkrts_short_pause ENDP

EXTRN   __cilkrts_rethrow:PROC

END
