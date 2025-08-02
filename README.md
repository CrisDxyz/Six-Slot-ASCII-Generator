# Six-Slot ASCII Generator

This tool generates a reproducible 6-digit code from a phrase, a date, and two extra settings.

## Demo Example

![](https://github.com/CrisDxyz/Six-Slot-ASCII-Generator/blob/main/img/Six-Slot.gif)

## Algorithm Overview

The process follows four main steps:

1.  **Salt Input:** A secret phrase is combined with a date (the "salt") to create a unique base string.
2.  **Hash to Slots:** Each character of the salted string is processed:
    *   The character's ASCII number digits are summed (e.g., `C` (67) → `6+7=13`).
    *   The last digit of the sum (`3`) is added to one of six number slots in a round-robin cycle.
3.  **Create Base Code:** The last digit from each of the six slots' totals are concatenated into a 6-digit string.
4.  **Finalize:** Two final modifications are applied:
    *   A **offset** number is added to each digit, wrapping from 9 to 0.
    *   The result is **reversed** if the option is checked.

## Step-by-step Example

*   **Phrase:** `Cat`
*   **Date:** `01/08/2024`
*   **Offset:** `5`
*   **Reverse:** `Checked`

**1. Salted Input:** `Cat01082024`

**2. Hash to Slots:**
| Slot | Calculation | Total |
| :--- | :--------------------- | :---- |
| #1   | 3 (`C`) + 1 (`8`)      | 4     |
| #2   | 6 (`a`) + 5 (`2`)      | 11    |
| #3   | 8 (`t`) + 2 (`0`)      | 10    |
| #4   | 2 (`0`) + 5 (`2`)      | 7     |
| #5   | 3 (`1`) + 7 (`4`)      | 10    |
| #6   | 2 (`0`)                | 2     |

**3. Base Code** (last digit of each total): `410702`

**4. Finalize:**
*   **Apply Offset (+5):** `410702` → `965257`
*   **Reverse (Checked):** `965257` → `752569`

**Result:** `752569`

![](https://github.com/CrisDxyz/Six-Slot-ASCII-Generator/blob/main/img/Six-Slot%20ASCII%20Generator%20Cat%20Example.png)
