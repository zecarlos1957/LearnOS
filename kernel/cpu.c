#include "common.h"
#include "monitor.h"
#include "isr.h"

#define CPU_DATA_MAXLEVEL           0
#define CPU_DATA_MAXEXTENDEDLEVEL   1
#define CPU_DATA_FEATURES_ECX       2
#define CPU_DATA_FEATURES_EDX       3

#define isspace(c) ((c >= 0x09 && c <= 0x0D) || (c == 0x20))

typedef uint32_t uintptr_t;
typedef unsigned int Flags_t;

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

enum CpuFeatures {
	//Features contained in ECX register
	CPUID_FEAT_ECX_SSE3 = 1 << 0,
	CPUID_FEAT_ECX_PCLMUL = 1 << 1,
	CPUID_FEAT_ECX_DTES64 = 1 << 2,
	CPUID_FEAT_ECX_MONITOR = 1 << 3,
	CPUID_FEAT_ECX_DS_CPL = 1 << 4,
	CPUID_FEAT_ECX_VMX = 1 << 5,
	CPUID_FEAT_ECX_SMX = 1 << 6,
	CPUID_FEAT_ECX_EST = 1 << 7,
	CPUID_FEAT_ECX_TM2 = 1 << 8,
	CPUID_FEAT_ECX_SSSE3 = 1 << 9,
	CPUID_FEAT_ECX_CID = 1 << 10,
	CPUID_FEAT_ECX_FMA = 1 << 12,
	CPUID_FEAT_ECX_CX16 = 1 << 13,
	CPUID_FEAT_ECX_ETPRD = 1 << 14,
	CPUID_FEAT_ECX_PDCM = 1 << 15,
	CPUID_FEAT_ECX_DCA = 1 << 18,
	CPUID_FEAT_ECX_SSE4_1 = 1 << 19,
	CPUID_FEAT_ECX_SSE4_2 = 1 << 20,
	CPUID_FEAT_ECX_x2APIC = 1 << 21,
	CPUID_FEAT_ECX_MOVBE = 1 << 22,
	CPUID_FEAT_ECX_POPCNT = 1 << 23,
	CPUID_FEAT_ECX_AES = 1 << 25,
	CPUID_FEAT_ECX_XSAVE = 1 << 26,
	CPUID_FEAT_ECX_OSXSAVE = 1 << 27,
	CPUID_FEAT_ECX_AVX = 1 << 28,
	CPUID_FEAT_ECX_F16C = 1 << 29,
	CPUID_FEAT_ECX_RDRAND = 1 << 30,

	//Features contained in EDX register
	CPUID_FEAT_EDX_FPU = 1 << 0,
	CPUID_FEAT_EDX_VME = 1 << 1,
	CPUID_FEAT_EDX_DE = 1 << 2,
	CPUID_FEAT_EDX_PSE = 1 << 3,
	CPUID_FEAT_EDX_TSC = 1 << 4,
	CPUID_FEAT_EDX_MSR = 1 << 5,
	CPUID_FEAT_EDX_PAE = 1 << 6,
	CPUID_FEAT_EDX_MCE = 1 << 7,
	CPUID_FEAT_EDX_CX8 = 1 << 8,
	CPUID_FEAT_EDX_APIC = 1 << 9,
	CPUID_FEAT_EDX_SEP = 1 << 11,
	CPUID_FEAT_EDX_MTRR = 1 << 12,
	CPUID_FEAT_EDX_PGE = 1 << 13,
	CPUID_FEAT_EDX_MCA = 1 << 14,
	CPUID_FEAT_EDX_CMOV = 1 << 15,
	CPUID_FEAT_EDX_PAT = 1 << 16,
	CPUID_FEAT_EDX_PSE36 = 1 << 17,
	CPUID_FEAT_EDX_PSN = 1 << 18,
	CPUID_FEAT_EDX_CLF = 1 << 19,
	CPUID_FEAT_EDX_DTES = 1 << 21,
	CPUID_FEAT_EDX_ACPI = 1 << 22,
	CPUID_FEAT_EDX_MMX = 1 << 23,
	CPUID_FEAT_EDX_FXSR = 1 << 24,
	CPUID_FEAT_EDX_SSE = 1 << 25,
	CPUID_FEAT_EDX_SSE2 = 1 << 26,
	CPUID_FEAT_EDX_SS = 1 << 27,
	CPUID_FEAT_EDX_HTT = 1 << 28,
	CPUID_FEAT_EDX_TM1 = 1 << 29,
	CPUID_FEAT_EDX_IA64 = 1 << 30,
	CPUID_FEAT_EDX_PBE = 1 << 31
};

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
        monitor_write("CpuEnableGpe");monitor_write("\n");
    }

    // Can we enable FPU?
    if (CpuHasFeatures(0, CPUID_FEAT_EDX_FPU)) 
    {
        CpuEnableFpu();
        monitor_write("CpuEnableFpu");monitor_write("\n");
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