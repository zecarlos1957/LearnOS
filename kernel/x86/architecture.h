#ifndef ARCH_H
#define ARCH_H

#include <runtime/types.h>


/** Processor architecture class **/
class Architecture
{
	public:
		/** architecture class functions **/
		void	init();			/* start the processor interface */
		void	reboot();		/* reboot the computer */
		void	shutdown();		/* shutdown the computer */
		char*	detect();		/* detect the type of processor */
		void	install_irq(int_handler h);	/* install a interruption handler */
		void	enable_interrupt();		/* enable the interruption */
		void	disable_interrupt();	/* disable the interruption */
				
	private:

};

/** standart starting architecture interface **/
extern Architecture arch;

#endif
