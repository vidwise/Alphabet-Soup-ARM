@;=== startup function for ARM assembly programs ===

.text
		.arm
		.global _start
	_start:
		nop						@; phony instruction for setting initial breakpoint correctly
		bl principal			@; call the main routine
	.Lstop:
		b .Lstop				@; endless loop

.end
