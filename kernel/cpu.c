#include "common.h"
#include "monitor.h"
#include "isr.h"

#define CPU_DATA_MAXLEVEL           0
#define CPU_DATA_MAXEXTENDEDLEVEL   1
#define CPU_DATA_FEATURES_ECX       2
#define CPU_DATA_FEATURES_EDX       3

#define isspace(c) ((c >= 0x09 && c <= 0x0D) || (c == 0x20))


extern void CpuEnableGpe(void);
extern void CpuEnableFpu(void);

typedef struct SystemCpu {
    char                Vendor[16];     // zero terminated string
    char                Brand[64];      // zero terminated string
    uintptr_t           Data[4];        // data available for usage
    int                 NumberOfCores;  // always minimum 1
  //  SystemCpuCore_t*    Cores;

    struct SystemCpu*   Link;
} SystemCpu_t;

typedef struct
{
    uint32_t eax, ebx, ecx, edx;
}regs;


regs CpuRegisters;
SystemCpu_t* Processor;

void __get_cpuid(int code)
{
    asm volatile("cpuid":"=a"(CpuRegisters.eax),"=b"(CpuRegisters.ebx),
                 "=c"(CpuRegisters.ecx),"=d"(CpuRegisters.edx):"0"(code));

}

/* TrimWhitespaces
 * Trims leading and trailing whitespaces in-place on the given string. This is neccessary
 * because of how x86 cpu's store their brand string (with middle alignment?)..*/
static char*
TrimWhitespaces(char *str)
{
    char *end;

    // Trim leading space
    while (isspace((unsigned char)*str)) str++;
    if(*str == 0) {
        return str; // All spaces?
    }

    // Trim trailing space
    end = str + strlen(str) - 1;
    while (end > str && isspace((unsigned char)*end)) end--;

    // Write new null terminator
    *(end + 1) = 0;
    return str;
}

int
CpuHasFeatures(Flags_t Ecx, Flags_t Edx)
{
	// Check ECX features @todo multiple cpus
	if (Ecx != 0) {
		if ((Processor->Data[CPU_DATA_FEATURES_ECX] & Ecx) != Ecx) {
			return 0;
		}
	}

	// Check EDX features @todo multiple cpus
	if (Edx != 0) {
		if ((Processor->Data[CPU_DATA_FEATURES_EDX] & Edx) != Edx) {
			return 0;
		}
	}
	return 1;
}

void
CpuInitializeFeatures(void)
{
    // Can we use global pages? We will use this for kernel mappings
    // to speed up refill performance
    if (CpuHasFeatures(0, CPUID_FEAT_EDX_PGE)) 
    {
        CpuEnableGpe();
 //       monitor_write("CpuEnableGpe");monitor_write("\n");
    }

    // Can we enable FPU?
    if (CpuHasFeatures(0, CPUID_FEAT_EDX_FPU)) 
    {
        CpuEnableFpu();
 //       monitor_write("CpuEnableFpu");monitor_write("\n");
    }
}


void init_cpu()
{
    SystemCpu_t cpu_data;
    Processor = &cpu_data;

    char     TemporaryBrand[64] = { 0 };
    char*    BrandPointer       = &TemporaryBrand[0];


    __get_cpuid(0x00);

    Processor->Data[CPU_DATA_MAXLEVEL] = CpuRegisters.eax;
    memcpy(Processor->Vendor, (char *) &CpuRegisters.ebx, 4);
    memcpy(Processor->Vendor+4, (char *) &CpuRegisters.edx, 4);
    memcpy(Processor->Vendor+8, (char *) &CpuRegisters.ecx, 4);
    Processor->Vendor[12] = '\0';
 
    // Does it support retrieving features?
    if (Processor->Data[CPU_DATA_MAXLEVEL] >= 1) {
        __get_cpuid(1);
        Processor->Data[CPU_DATA_FEATURES_ECX] = CpuRegisters.ecx;
        Processor->Data[CPU_DATA_FEATURES_EDX] = CpuRegisters.edx;
        if (CpuRegisters.edx & CPUID_FEAT_EDX_HTT) {
            Processor->NumberOfCores = (CpuRegisters.ebx >> 16) & 0xFF;
   //         PrimaryCore->Id          = (CpuRegisters.ebx >> 24) & 0xFF;
        }

        // This can be reported as 0, which means we assume a single cpu
        if (Processor->NumberOfCores == 0) {
            Processor->NumberOfCores = 1;
        }
    monitor_write("Features EDX ");
    monitor_write_hex(CpuRegisters.edx);
    monitor_write("\n");

    }

    // Get extensions supported
    __get_cpuid(0x80000000);

    // Extract the processor brand string if it's supported
    Processor->Data[CPU_DATA_MAXEXTENDEDLEVEL] = CpuRegisters.eax;
    if (Processor->Data[CPU_DATA_MAXEXTENDEDLEVEL] >= 0x80000004) 
    {
        __get_cpuid(0x80000002); // First 16 bytes
        memcpy(&TemporaryBrand[0], (char*)&CpuRegisters, 16);
        __get_cpuid(0x80000003); // Middle 16 bytes
        memcpy(&TemporaryBrand[16], (char*)&CpuRegisters, 16);
        __get_cpuid(0x80000004); // Last 16 bytes
        memcpy(&TemporaryBrand[32], (char*)&CpuRegisters, 16);
        BrandPointer = TrimWhitespaces(BrandPointer);
        memcpy(&Processor->Brand[0], BrandPointer, strlen(BrandPointer));
    }

    monitor_write(Processor->Vendor);
    monitor_write(" ");
    monitor_write(Processor->Brand);
    monitor_write("\n");

    // Enable cpu features
    CpuInitializeFeatures();

}