# Path Parser Documentation (pparser.c)

This module is responsible for taking raw string paths (e.g., `0:/bin/shell.exe`) and converting them into a structured format that the **PeruOS** kernel can understand.

---

## Data Structures

The parser relies on a linked list structure:
* **`path_root`**: Contains the drive number and a pointer to the first part of the path.
* **`path_part`**: A node in a linked list containing the name of a single directory or file.



---

## Function Reference

### `pathparser_path_valid_format`
**Signature:** `static int pathparser_path_valid_format(const char* filename)`

* **Description:** Validates if the string follows the required OS format.
* **Requirements:** * Must be at least 3 characters long.
    * Must start with a numeric digit (the drive).
    * The second and third characters must be `:/`.
* **Returns:** `1` if valid, `0` if invalid.

### `pathparser_path_get_drive_by_path`
**Signature:** `static int pathparser_path_get_drive_by_path(const char** path)`

* **Description:** Extracts the drive ID and advances the string pointer.
* **Logic:** It converts the first character to an integer and then increments the pointer by 3 to skip the `X:/` prefix.
* **Returns:** The drive number (integer) or `-EBADPATH` on failure.

### `pathparser_create_root`
**Signature:** `static struct path_root* pathparser_create_root(int drive_number)`

* **Description:** Allocates and initializes the root of the path structure.
* **Memory:** Uses `kzalloc` to ensure the structure is zeroed out.

### `pathparser_get_path_part`
**Signature:** `static const char* pathparser_get_path_part(const char** path)`

* **Description:** The "worker" function that slices the string.
* **Logic:** It reads characters until it hits a forward slash `/` or a null terminator. It allocates a buffer of size `PERUOS_MAX_PATH` for the resulting string.
* **Note:** If the path is empty (e.g., a double slash `//`), it returns `0`.

### `pathparser_parse_path_part`
**Signature:** `struct path_part* pathparser_parse_path_part(struct path_part* last_part, const char** path)`

* **Description:** Creates a new node in the linked list.
* **Logic:** It calls `pathparser_get_path_part` and wraps the result in a `path_part` struct. If a `last_part` is provided, it automatically links the previous node to this new one.

### `pathparser_free`
**Signature:** `void pathparser_free(struct path_root* root)`

* **Description:** Cleans up all memory associated with a parsed path.
* **Logic:** It traverses the linked list, freeing both the strings within the parts and the part structures themselves, finally freeing the root.

### `pathparser_parse`
**Signature:** `struct path_root* pathparser_parse(const char* path, const char* current_directory_path)`

* **Description:** The main entry point for the parser.
* **Workflow:**
    1. Validates path length.
    2. Identifies the drive number.
    3. Iteratively calls `pathparser_parse_path_part` in a loop until the entire string is consumed.
* **Returns:** A pointer to a `path_root` or `NULL` if parsing fails.

---

## Error Handling
The parser uses standard kernel status codes. If a path exceeds `PERUOS_MAX_PATH` or contains an invalid drive format, the functions will return `0` or a negative error code (e.g., `-EBADPATH`).
