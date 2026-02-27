# 🐧 peruOS:A 32-bit Multithreaded Kernel from Scratch

peruOS is a hobbyist operating system designed to explore low-level systems programming, memory management, and hardware abstraction. Built for the intel 32-bit architecture, it aims to implement a fully preemptive multitasking environment.



---

## 🛠 System Specifications & Toolchain
To build and run peruOS correctly, you must use a cross-compiler to target `i686-elf`. This prevents host-machine headers and configurations from leaking into the kernel.

* **Compiler:** `i686-elf-gcc`
* **Assembler:** `nasm`
* **Emulator:** `QEMU` (qemu-system-x86_64)
* **Cross-Compiler Setup:** [OSDev: GCC Cross-Compiler Guide](https://wiki.osdev.org/GCC_Cross-Compiler)

---

## 📂 Project Documentation
The technical implementation details for each subsystem are organized within the `/docs` folder. Each link below leads to a dedicated folder containing the logical understanding for that functionality.

* 🏗️ **[/docs/bootloader](./docs/bootloader/)** - Boot process and Stage 1/2 Assembly.
* 🧠 **[/docs/memory](./docs/memory/)** - Virtualization and Memory Management.
* 💾 **[/docs/filesystem](./docs/filesystem/)** - FAT16 and Virtual File System (VFS) design.
* ⌨️ **[/docs/drivers](./docs/drivers/)** - Keyboard and hardware I/O.
* 🧵 **[/docs/processes](./docs/processes/)** - Task switching and ELF loading.

---

## 📜 Development Roadmap

### 1. Real Mode Development (16-bit)
The foundation of the boot sequence where the kernel interacts directly with the BIOS.
* **Boot Process:** Understanding the x86 power-on sequence and memory map.
* **Assembly Bootloader:** Writing the boot sector and stage loaders in NASM.
* **Real Mode Interrupts:** Utilizing BIOS interrupts for early-stage I/O.
* **Disk Reading:** Implementing logic to read 512-byte sectors from the hard disk.



### 2. Protected Mode Development (32-bit)
Transitioning to a higher-half multitasking kernel.
* **Memory & Virtualization:** Implementing paging and memory isolation.
* **FAT16 Filesystem:** Direct hardware implementation of the FAT16 specification.
* **Keyboard Driver:** Writing a driver to handle PS/2 input interrupts.
* **ELF File Loader:** Parsing and executing standard ELF binaries.
* **Virtual Filesystem (VFS):** A Linux-inspired abstraction layer for file operations.
* **Process Management:** Implementing tasks, context switching, and scheduling.



---

## 🚀 How to Build and Run
Follow these steps precisely to ensure a clean build and successful boot in Protected Mode.

1.  **Clean the previous build:**
    ```bash
    make clean
    ```

2.  **Run the build script:**
    ```bash
    ./build.sh
    ```

3.  **Launch the Kernel:**
    Navigate to the binary output folder and run the system using QEMU:
    ```bash
    cd bin
    qemu-system-x86_64 -hda ./os.bin
    ```

---

