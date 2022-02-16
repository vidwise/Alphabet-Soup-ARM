#---------------------------------------------------------------------------------
# Specific Makefile to assembly ARM source code from project "SopaDeLetras"
# Author: Santiago Romani
# Date: March 2013
# Licence: Public Domain
#---------------------------------------------------------------------------------

ifeq ($(strip $(DEVKITPRO)),)
$(error "Please set DEVKITPRO in your environment. export DEVKITPRO=<path to>devkitPro")
endif
export PATH	:=	$(DEVKITPRO)/devkitARM/bin:$(DEVKITPRO)/Insight/bin:$(PATH)


#---------------------------------------------------------------------------------
# options for code generation
#---------------------------------------------------------------------------------
ASFLAGS	:= -march=armv5te -mlittle-endian -g
LDFLAGS := --warn-section-align


#---------------------------------------------------------------------------------
# make commands
#---------------------------------------------------------------------------------

sopadeletras.elf : sopa.o deletras.o startup.o
	arm-none-eabi-ld $(LDFLAGS) sopa.o deletras.o startup.o -o sopadeletras.elf

sopa.o : sopa.s
	arm-none-eabi-as $(ASFLAGS) sopa.s -o sopa.o

deletras.o : deletras.s
	arm-none-eabi-as $(ASFLAGS) deletras.s -o deletras.o

startup.o : startup.s
	arm-none-eabi-as $(ASFLAGS) startup.s -o startup.o


#---------------------------------------------------------------------------------
# clean commands
#---------------------------------------------------------------------------------
clean : 
	@rm -fv startup.o
	@rm -fv sopa.o
	@rm -fv deletras.o
	@rm -fv sopadeletras.elf


#---------------------------------------------------------------------------------
# run commands
#---------------------------------------------------------------------------------
run : sopadeletras.elf
	arm-eabi-insight sopadeletras.elf &

