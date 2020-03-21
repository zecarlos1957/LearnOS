#pragma once

#include <stdint.h>

//-----------------------------------------------
//	Operational Command Bit masks
//-----------------------------------------------

#define		I86_PIT_OCW_MASK_BINCOUNT		1		//00000001
#define		I86_PIT_OCW_MASK_MODE			0xE		//00001110
#define		I86_PIT_OCW_MASK_RL				0x30	//00110000
#define		I86_PIT_OCW_MASK_COUNTER		0xC0	//11000000

//-----------------------------------------------
//	Operational Command control bits
//-----------------------------------------------

//! Use when setting binary count mode
#define		I86_PIT_OCW_BINCOUNT_BINARY		0		//0
#define		I86_PIT_OCW_BINCOUNT_BCD		1		//1

//! Use when setting counter mode
#define		I86_PIT_OCW_MODE_TERMINALCOUNT	0		//0000
#define		I86_PIT_OCW_MODE_ONESHOT		0x2		//0010
#define		I86_PIT_OCW_MODE_RATEGEN		0x4		//0100
#define		I86_PIT_OCW_MODE_SQUAREWAVEGEN	0x6		//0110
#define		I86_PIT_OCW_MODE_SOFTWARETRIG	0x8		//1000
#define		I86_PIT_OCW_MODE_HARDWARETRIG	0xA		//1010

//! Use when setting data transfer
#define		I86_PIT_OCW_RL_LATCH			0			//000000
#define		I86_PIT_OCW_RL_LSBONLY			0x10		//010000
#define		I86_PIT_OCW_RL_MSBONLY			0x20		//100000
#define		I86_PIT_OCW_RL_DATA				0x30		//110000

//! Use when setting the counter we are working with
#define		I86_PIT_OCW_COUNTER_0			0		//00000000
#define		I86_PIT_OCW_COUNTER_1			0x40	//01000000
#define		I86_PIT_OCW_COUNTER_2			0x80	//10000000

#ifdef __cplusplus
extern "C" {
#endif

//! send operational command to pit. Set up command by using the operational
//! command bit masks and setting them with the control bits. Shouldn't need to use
//! this outside the interface
void pit_send_command(uint8_t cmd);

//! write data byte to a counter
void pit_send_data(uint16_t data, uint8_t counter);

//! reads data from a counter
uint8_t pit_read_data(uint16_t counter);

//! starts a counter. Counter continues until another call to this routine
void pit_start_counter(uint32_t freq, uint8_t counter, uint8_t mode);

//! returns current tick count
uint32_t pit_get_tick_count();

//! Initialize minidriver
void pit_initialize();

#ifdef __cplusplus
}
#endif