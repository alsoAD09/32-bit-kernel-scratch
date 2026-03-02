
## 1. The Boot Process & MBR
After the **Power-On Self-Test (POST)**, the BIOS searches for a bootable device. The transition from hardware to software follows a specific sequence:

* **Boot Signature:** The BIOS scans the first sector (**Master Boot Record**) of storage media for the magic value `0x55AA` at the end of the 512-byte sector.
* **Memory Loading:** Once identified, the BIOS loads this 512-byte sector into physical memory at the fixed address `0x7C00`.
* **Execution:** Control is transferred to the code located at that address.
* **Padding:** To ensure the sector is exactly 512 bytes and ends with the signature, the code is padded with zeros.
    * *NASM implementation:* `times 510-($-$$) db 0` followed by `dw 0xAA55`.



---

## 2. Real Mode Initialization
Before loading the kernel, the bootloader must establish a stable environment.

### Segment Registers & Stack
I manually initialized the segment registers (`DS`, `ES`, `SS`) and defined the stack pointer. This ensures the CPU has a deterministic location to store temporary data and return addresses.

### Screen Output
A "Hello World" routine was implemented using BIOS interrupts (typically `int 0x10`) to verify that the bootloader is executing correctly.

### The Interrupt Vector Table (IVT)
In Real Mode, interrupts are handled via the **IVT** located at the very beginning of memory (`0x0000:0x0000`).
* **Structure:** 256 entries.
* **Size:** Each entry is 4 bytes long (Segment:Offset).
* **Purpose:** Used for hardware communication and basic BIOS services.

---

## 3. Transitioning to Protected Mode
Real Mode is limited to **1MB** of addressable memory. For **peruOS** to function as a modern 32-bit kernel, we must transition to Protected Mode.
https://wiki.osdev.org/Protected_Mode

### Enabling the A20 Line
Enabling the A20 Line is one of the most critical steps in this transition.
https://wiki.osdev.org/A20_Line

* **The Problem:** By default, the 21st bit of the address bus is disabled for backward compatibility with the Intel 8086. If we try to access memory above 1MB without enabling it, the address will "wrap around" to 0, leading to severe memory corruption.
* **The Solution:** By enabling the A20 line, we unlock access to memory beyond the 1MB barrier, which is essential for loading the kernel and setting up the **Global Descriptor Table (GDT)**.



---

## 4. Kernel Loading
The final role of this bootloader is to read the OS image from the disk and place it into main memory. 

Once the A20 line is enabled and the CPU is switched to **Protected Mode** (by setting the `PE` bit in `CR0`), the bootloader jumps to the kernel's entry point, handing over total control to **peruOS**.
